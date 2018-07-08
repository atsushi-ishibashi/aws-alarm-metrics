package main

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	sdklambda "github.com/aws/aws-sdk-go/service/lambda"
	"github.com/aws/aws-sdk-go/service/lambda/lambdaiface"
)

var (
	lambdaconn lambdaiface.LambdaAPI
	threshold  string
	threPer    float64
)

func init() {
	lambdaconn = sdklambda.New(session.New(), aws.NewConfig().WithRegion(os.Getenv("AWS_REGION")))
}

func main() {
	if os.Getenv("AWS_REGION") == "" {
		log.Fatalln("AWS_REGION missing")
	}
	if os.Getenv("SLACK_URL") == "" {
		log.Fatalln("SLACK_URL missing")
	}
	f, err := strconv.ParseFloat(threshold, 64)
	if err != nil {
		log.Fatalln(err)
	}
	threPer = f
	lambda.Start(handler)
}

type AlarmMessage struct {
	OldStateValue    string `json:"OldStateValue"`
	NewStateValue    string `json:"NewStateValue"`
	AlarmDescription string `json:"AlarmDescription"`
	AlarmName        string `json:"AlarmName"`
	NewStateReason   string `json:"NewStateReason"`
	StateChangeTime  string `json:"StateChangeTime"`
	Triger           struct {
		MetricName string `json:"MetricName"`
		Namespace  string `json:"Namespace"`
		Statistic  string `json:"Statistic"`
		Dimensions []struct {
			Name  string `json:"name"`
			Value string `json:"value"`
		} `json:"Dimensions"`
	} `json:"Triger"`
}

func handler(ctx context.Context, e events.SNSEvent) error {
	errs := make([]error, 0)
	for _, record := range e.Records {
		snsRecord := record.SNS

		var amsg AlarmMessage
		if err := json.Unmarshal([]byte(snsRecord.Message), &amsg); err != nil {
			errs = append(errs, err)
			continue
		}
		if err := postSlack(contructSlackMessage(amsg)); err != nil {
			errs = append(errs, err)
		}
	}
	return expandErrs(errs)
}

func expandErrs(errs []error) error {
	if len(errs) == 0 {
		return nil
	}
	errsStr := make([]string, len(errs))
	for k, v := range errs {
		errsStr[k] = v.Error()
	}
	return errors.New(strings.Join(errsStr, "\n"))
}

func contructSlackMessage(msg AlarmMessage) string {
	if msg.NewStateValue != "ALARM" {
		return ""
	}
	if msg.Triger.MetricName != "Duration" {
		return ""
	}
	if msg.Triger.Namespace != "AWS/Lambda" {
		return ""
	}
	var functionName string
	for _, v := range msg.Triger.Dimensions {
		if v.Name == "FunctionName" {
			functionName = v.Value
		}
	}
	if functionName == "" {
		return ""
	}
	durationStr := msg.NewStateReason[strings.Index(msg.NewStateReason, "[") : strings.Index(msg.NewStateReason, "(")-1]
	duration, err := strconv.ParseFloat(durationStr, 64)
	if err != nil {
		return ""
	}
	resp, err := lambdaconn.GetFunction(&sdklambda.GetFunctionInput{
		FunctionName: aws.String(functionName),
	})
	if err != nil {
		return ""
	}
	timeout := *resp.Configuration.Timeout
	if duration/float64(timeout) < threPer {
		return ""
	}
	status := ":exclamation:" + msg.NewStateValue
	durationText := fmt.Sprintf("Duration: %f, Timeout: %d", duration, timeout)
	return fmt.Sprintf("*%s: %s*\n%s\n%s\n%s @%s", status, msg.AlarmDescription, msg.AlarmName, durationText, msg.NewStateReason, msg.StateChangeTime)
}

func postSlack(msg string) error {
	if msg == "" {
		return nil
	}
	type Slack struct {
		Text string `json:"text"`
	}
	slackBody := &Slack{
		Text: msg,
	}
	body, _ := json.Marshal(slackBody)
	req, _ := http.NewRequest("POST", os.Getenv("SLACK_URL"), bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	retryCount := 0
	var senderr error
	for retryCount < 3 {
		resp, err := client.Do(req)
		senderr = err
		if senderr == nil {
			resp.Body.Close()
			break
		}
		time.Sleep(100 * time.Millisecond)
		retryCount++
	}
	return senderr
}
