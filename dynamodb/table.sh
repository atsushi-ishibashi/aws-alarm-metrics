#!/bin/bash

PROFILE=$1
ACTION=$2
TABLE=$3

aws cloudwatch put-metric-alarm \
  --alarm-name "awsdynamodb-$TABLE-WriteThrottleEvents" \
  --metric-name WriteThrottleEvents \
  --namespace AWS/DynamoDB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、プロビジョニングされた書き込み容量ユニットを超えるDynamoDBへのリクエストの合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TableName,Value=$TABLE \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsdynamodb-$TABLE-ReadThrottleEvents" \
  --metric-name ReadThrottleEvents \
  --namespace AWS/DynamoDB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、プロビジョニングされた読み取り容量ユニットを超えるDynamoDBへのリクエストの合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TableName,Value=$TABLE \
  --profile $PROFILE \
  --region $AWS_REGION
