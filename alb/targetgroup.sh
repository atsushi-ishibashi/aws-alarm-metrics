#!/bin/bash

CMDNAME=`basename $0`

RT_THRESHOLD=0.5

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
VAL1=$(echo $3 | cut -d / -f1)
VAL2=$(echo $3 | cut -d / -f2)
VAL3=$(echo $3 | cut -d / -f3)

aws cloudwatch put-metric-alarm \
  --alarm-name "awsapplicationelb-$VAL1-$VAL2-$VAL3-UnHealthyHostCount" \
  --metric-name UnHealthyHostCount \
  --namespace AWS/ApplicationELB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold 1 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、異常と見なされるターゲット数の合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TargetGroup,Value=$3 Name=LoadBalancer,Value=$4 \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsapplicationelb-$VAL1-$VAL2-$VAL3-TargetResponseTime" \
  --metric-name TargetResponseTime \
  --namespace AWS/ApplicationELB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $RT_THRESHOLD \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、ターゲットの平均応答時間が${RT_THRESHOLD}s以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TargetGroup,Value=$3 Name=LoadBalancer,Value=$4 \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsapplicationelb-$VAL1-$VAL2-$VAL3-HTTPCode_Target_5XX_Count" \
  --metric-name HTTPCode_Target_5XX_Count \
  --namespace AWS/ApplicationELB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、ターゲットによって生成されたHTTP5XXの数の合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TargetGroup,Value=$3 Name=LoadBalancer,Value=$4 \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsapplicationelb-$VAL1-$VAL2-$VAL3-TargetTLSNegotiationErrorCount" \
  --metric-name TargetTLSNegotiationErrorCount \
  --namespace AWS/ApplicationELB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、ロードバランサ開始でターゲットとセッションが確立しなかったTLS接続の数の合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TargetGroup,Value=$3 Name=LoadBalancer,Value=$4 \
  --profile $PROFILE \
  --region $AWS_REGION
