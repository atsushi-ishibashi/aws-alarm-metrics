#!/bin/bash

CMDNAME=`basename $0`

L_THRESHOLD=2000
IL_THRESHOLD=2000

while getopts r: OPT
do
  case $OPT in
    "l" ) L_THRESHOLD="$OPTARG" ;;
    "i" ) IL_THRESHOLD="$OPTARG" ;;
      * ) echo "Usage: $CMDNAME [-l VALUE] [-i VALUE]" 1>&2
          exit 1 ;;
  esac
done

shift `expr $OPTIND - 1`

PROFILE=$1
ACTION=$2
API=$3

aws cloudwatch put-metric-alarm \
  --alarm-name "awsapigateway-$API-Latency" \
  --metric-name Latency \
  --namespace AWS/ApiGateway \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $L_THRESHOLD \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、APIGatewayがリクエストを受け取ってからレスポンスを返すまでの時間の平均が${L_THRESHOLD}ms以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=ApiName,Value=$API \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsapigateway-$API-IntegrationLatency" \
  --metric-name IntegrationLatency \
  --namespace AWS/ApiGateway \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $L_THRESHOLD \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、APIGatewayがバックエンドにリクエストを中継してからバックエンドからレスポンスを受け取るまでの時間の平均が${IL_THRESHOLD}ms以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=ApiName,Value=$API \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsapigateway-$API-5XXError" \
  --metric-name 5XXError \
  --namespace AWS/ApiGateway \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、サーバー側エラーの数の合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=ApiName,Value=$API \
  --profile $PROFILE \
  --region $AWS_REGION
