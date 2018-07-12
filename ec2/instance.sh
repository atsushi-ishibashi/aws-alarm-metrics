#!/bin/bash

CMDNAME=`basename $0`

CPU_THRESHOLD=80.0

while getopts c: OPT
do
  case $OPT in
    "c" ) CPU_THRESHOLD="$OPTARG" ;;
      * ) echo "Usage: $CMDNAME [-c VALUE]" 1>&2
          exit 1 ;;
  esac
done

shift `expr $OPTIND - 1`

PROFILE=$1
ACTION=$2
INSTANCE_ID=$3
INSTANCE_NAME=$4
ALARM_NAME=INSTANCE_ID

if [ ! $INSTANCE_NAME = "" ]; then
  ALARM_NAME="$INSTANCE_NAME($INSTANCE_ID)"
fi

aws cloudwatch put-metric-alarm \
  --alarm-name "awsec2-$ALARM_NAME-CPUUtilization" \
  --metric-name CPUUtilization \
  --namespace AWS/EC2 \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $CPU_THRESHOLD \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、CPU使用率の平均が${CPU_THRESHOLD}以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=InstanceId,Value=$INSTANCE_ID \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsec2-$ALARM_NAME-StatusCheckFailed_Instance" \
  --metric-name StatusCheckFailed_Instance \
  --namespace AWS/EC2 \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "最近1分間においてインスタンスステータスチェックに失敗" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=InstanceId,Value=$INSTANCE_ID \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsec2-$ALARM_NAME-StatusCheckFailed_System" \
  --metric-name StatusCheckFailed_System \
  --namespace AWS/EC2 \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "最近1分間においてシステムステータスチェックに失敗" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=InstanceId,Value=$INSTANCE_ID \
  --profile $PROFILE \
  --region $AWS_REGION
