#!/bin/bash

CMDNAME=`basename $0`

CPU_THRESHOLD=80.0
MEM_THRESHOLD=80.0

while getopts c:m: OPT
do
  case $OPT in
    "c" ) CPU_THRESHOLD="$OPTARG" ;;
    "m" ) MEM_THRESHOLD="$OPTARG" ;;
      * ) echo "Usage: $CMDNAME [-c VALUE] [-m VALUE]" 1>&2
          exit 1 ;;
  esac
done

shift `expr $OPTIND - 1`

PROFILE=$1
ACTION=$2
CLUSTER=$3

aws cloudwatch put-metric-alarm \
  --alarm-name "awsecs-$CLUSTER-CPUUtilization" \
  --metric-name CPUUtilization \
  --namespace AWS/ECS \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $CPU_THRESHOLD \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、クラスターのCPU使用率の平均が${CPU_THRESHOLD}%以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=ClusterName,Value=$CLUSTER \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsecs-$CLUSTER-MemoryUtilization" \
  --metric-name MemoryUtilization \
  --namespace AWS/ECS \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $MEM_THRESHOLD \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、クラスターのメモリ使用率の平均が${MEM_THRESHOLD}%以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=ClusterName,Value=$CLUSTER \
  --profile $PROFILE \
  --region $AWS_REGION
