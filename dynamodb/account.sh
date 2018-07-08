#!/bin/bash

PROFILE=$1
ACTION=$2

aws cloudwatch put-metric-alarm \
  --alarm-name "awsdynamodb-UserErrors" \
  --metric-name UserErrors \
  --namespace AWS/DynamoDB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、HTTP400を生成するDynamoDBへのリクエストの合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --profile $PROFILE \
  --region $AWS_REGION
