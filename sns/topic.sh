#!/bin/bash

PROFILE=$1
ACTION=$2
TOPIC=$3

aws cloudwatch put-metric-alarm \
  --alarm-name "awssns-$TOPIC-NumberOfNotificationsFailed" \
  --metric-name NumberOfNotificationsFailed \
  --namespace AWS/SNS \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、SNSが配信に失敗したメッセージの数の合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TopicName,Value=$TOPIC \
  --profile $PROFILE \
  --region $AWS_REGION
