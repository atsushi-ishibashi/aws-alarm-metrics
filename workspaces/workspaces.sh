#!/bin/bash

PROFILE=$1
ACTION=$2
WORKSPACEID=$3

aws cloudwatch put-metric-alarm \
  --alarm-name "awsworkspaces-$WORKSPACEID-ConnectionFailure" \
  --metric-name ConnectionFailure \
  --namespace AWS/WorkSpaces \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、失敗した接続の数の合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=WorkspaceId,Value=$WORKSPACEID \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsworkspaces-$WORKSPACEID-Unhealthy" \
  --metric-name Unhealthy \
  --namespace AWS/WorkSpaces \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、正常でない状態を返したWorkSpaceの数の合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=WorkspaceId,Value=$WORKSPACEID \
  --profile $PROFILE \
  --region $AWS_REGION
