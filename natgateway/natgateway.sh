#!/bin/bash

PROFILE=$1
ACTION=$2
NAT_GATEWAY_ID=$3

aws cloudwatch put-metric-alarm \
  --alarm-name "awsnatgateway-$NAT_GATEWAY_ID-ErrorPortAllocation" \
  --metric-name ErrorPortAllocation \
  --namespace AWS/NATGateway \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、NATゲートウェイが送信元ポートを割り当てられなかった回数の合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=NatGatewayId,Value=$NAT_GATEWAY_ID \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsnatgateway-$NAT_GATEWAY_ID-PacketsDropCount" \
  --metric-name PacketsDropCount \
  --namespace AWS/NATGateway \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、NATゲートウェイによって破棄されたパケットの数の合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=NatGatewayId,Value=$NAT_GATEWAY_ID \
  --profile $PROFILE \
  --region $AWS_REGION
