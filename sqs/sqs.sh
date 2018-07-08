#!/bin/bash

CMDNAME=`basename $0`

RT_THRESHOLD=3.0

while getopts r: OPT
do
  case $OPT in
    "r" ) RT_THRESHOLD="$OPTARG" ;;
      * ) echo "Usage: $CMDNAME [-r VALUE]" 1>&2
          exit 1 ;;
  esac
done

shift `expr $OPTIND - 1`

PROFILE=$1
ACTION=$2
QUEUE=$3

aws cloudwatch put-metric-alarm \
  --alarm-name "awssqs-$QUEUE-ApproximateAgeOfOldestMessage" \
  --metric-name ApproximateAgeOfOldestMessage \
  --namespace AWS/SQS \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Maximum \
  --threshold $RT_THRESHOLD \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、キューで最も古い削除されていないメッセージの経過期間の最大が${RT_THRESHOLD}s以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=QueueName,Value=$QUEUE \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awssqs-$QUEUE-ApproximateNumberOfMessagesDelayed" \
  --metric-name ApproximateNumberOfMessagesDelayed \
  --namespace AWS/SQS \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、遅延が発生したためすぐに読み取ることのできないキューのメッセージ数の合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=QueueName,Value=$QUEUE \
  --profile $PROFILE \
  --region $AWS_REGION
