#!/bin/bash

CMDNAME=`basename $0`

GET_THRESHOLD=30.0
PUT_THRESHOLD=100.0
PUTS_THRESHOLD=200.0

while getopts g:h:p:q: OPT
do
  case $OPT in
    "g" ) GET_THRESHOLD="$OPTARG" ;;
    "p" ) PUT_THRESHOLD="$OPTARG" ;;
    "q" ) PUTS_THRESHOLD="$OPTARG" ;;
      * ) echo "Usage: $CMDNAME [-g VALUE] [-p VALUE] [-q VALUE]" 1>&2
          exit 1 ;;
  esac
done

shift `expr $OPTIND - 1`

PROFILE=$1
ACTION=$2
STREAM=$3

aws cloudwatch put-metric-alarm \
  --alarm-name "awskinesis-$STREAM-GetRecords.Latency" \
  --metric-name GetRecords.Latency \
  --namespace AWS/Kinesis \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $GET_THRESHOLD \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、GetRecordsにかかった時間の平均が${GET_THRESHOLD}ms以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=StreamName,Value=$STREAM \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awskinesis-$STREAM-PutRecord.Latency" \
  --metric-name PutRecord.Latency \
  --namespace AWS/Kinesis \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $PUT_THRESHOLD \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、PutRecordにかかった時間の平均が${PUT_THRESHOLD}ms以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=StreamName,Value=$STREAM \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awskinesis-$STREAM-PutRecords.Latency" \
  --metric-name PutRecords.Latency \
  --namespace AWS/Kinesis \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $PUTS_THRESHOLD \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、PutRecordsにかかった時間の平均が${PUTS_THRESHOLD}ms以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=StreamName,Value=$STREAM \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awskinesis-$STREAM-ReadProvisionedThroughputExceeded" \
  --metric-name ReadProvisionedThroughputExceeded \
  --namespace AWS/Kinesis \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold 0.0 \
  --comparison-operator GreaterThanThreshold \
  --alarm-description "1分間における、ストリームで調整されたGetRecords呼び出し回数の平均が0より大きい" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=StreamName,Value=$STREAM \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awskinesis-$STREAM-WriteProvisionedThroughputExceeded" \
  --metric-name WriteProvisionedThroughputExceeded \
  --namespace AWS/Kinesis \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold 0.0 \
  --comparison-operator GreaterThanThreshold \
  --alarm-description "1分間における、ストリームのスロットリングにより拒否されたレコードの数の平均が0より大きい" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=StreamName,Value=$STREAM \
  --profile $PROFILE \
  --region $AWS_REGION
