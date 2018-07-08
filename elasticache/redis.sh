#!/bin/bash

CMDNAME=`basename $0`

CPU_THRESHOLD=45.0
ECPU_THRESHOLD=90.0
CURR_THRESHOLD=10

while getopts c:r: OPT
do
  case $OPT in
    "c" ) CPU_THRESHOLD="$OPTARG" ;;
    "r" ) CURR_THRESHOLD="$OPTARG" ;;
      * ) echo "Usage: $CMDNAME [-c VALUE] [-r VALUE]" 1>&2
          exit 1 ;;
  esac
done

shift `expr $OPTIND - 1`

PROFILE=$1
ACTION=$2
CLUSTERID=$3

aws cloudwatch put-metric-alarm \
  --alarm-name "awselasticache-$CLUSTERID-CPUUtilization" \
  --metric-name CPUUtilization \
  --namespace AWS/ElastiCache \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $CPU_THRESHOLD \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、RedisホストレベルのCPU使用率の平均が${CPU_THRESHOLD}%以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=CacheClusterId,Value=$CLUSTERID \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awselasticache-$CLUSTERID-EngineCPUUtilization" \
  --metric-name EngineCPUUtilization \
  --namespace AWS/ElastiCache \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $ECPU_THRESHOLD \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、RedisプロセスCPU使用率の平均が${ECPU_THRESHOLD}%以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=CacheClusterId,Value=$CLUSTERID \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awselasticache-$CLUSTERID-SwapUsage" \
  --metric-name SwapUsage \
  --namespace AWS/ElastiCache \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold 52428800 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、Redisホストで使用されるスワップの量の平均が50MB以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=CacheClusterId,Value=$CLUSTERID \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awselasticache-$CLUSTERID-ReplicationLag" \
  --metric-name ReplicationLag \
  --namespace AWS/ElastiCache \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、ReplicationLagの平均が1.0s以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=CacheClusterId,Value=$CLUSTERID \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awselasticache-$CLUSTERID-Evictions" \
  --metric-name Evictions \
  --namespace AWS/ElastiCache \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、maxmemoryの制限のため排除されたキーの数の合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=CacheClusterId,Value=$CLUSTERID \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awselasticache-$CLUSTERID-CurrConnections" \
  --metric-name CurrConnections \
  --namespace AWS/ElastiCache \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Maximum \
  --threshold $CURR_THRESHOLD \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、クライアントの接続数の最大が${CURR_THRESHOLD}以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=CacheClusterId,Value=$CLUSTERID \
  --profile $PROFILE \
  --region $AWS_REGION
