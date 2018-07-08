#!/bin/bash

PROFILE=$1
ACTION=$2
DESTINATION=$3
FILTER=$4
LOG_GROUP=$5

aws cloudwatch put-metric-alarm \
  --alarm-name "awslogs-$DESTINATION-$FILTER-$LOG_GROUP-DeliveryErrors" \
  --metric-name DeliveryErrors \
  --namespace AWS/Logs \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、転送時にCloudWatchLogsがエラーを受け取ったログイベント数の合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=DestinationType,Value=$DESTINATION Name=FilterName,Value=$FILTER Name=LogGroupName,Value=$LOG_GROUP \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awslogs-$DESTINATION-$FILTER-$LOG_GROUP-DeliveryThrottling" \
  --metric-name DeliveryThrottling \
  --namespace AWS/SQS \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、転送時にCloudWatchLogsがスロットルされたログイベント数の合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=DestinationType,Value=$DESTINATION Name=FilterName,Value=$FILTER Name=LogGroupName,Value=$LOG_GROUP \
  --profile $PROFILE \
  --region $AWS_REGION
