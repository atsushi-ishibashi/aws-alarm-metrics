#!/bin/bash

CMDNAME=`basename $0`

CPU_THRESHOLD=80
REPLICA_LAG=50
FREERAM=2147483648

SELECT_LATENCY=1
INSERT_LATENCY=1
COMMIT_LATENCY=1
DELETE_LATENCY=1
UPDATE_LATENCY=1
DDL_LATENCY=1
DML_LATENCY=1

while getopts c: OPT
do
  case $OPT in
    "s" ) SELECT_LATENCY="$OPTARG" ;;
    "i" ) INSERT_LATENCY="$OPTARG" ;;
    "c" ) COMMIT_LATENCY="$OPTARG" ;;
    "d" ) DELETE_LATENCY="$OPTARG" ;;
    "u" ) UPDATE_LATENCY="$OPTARG" ;;
      * ) echo "Usage: $CMDNAME [-s VALUE] [-i VALUE] [-c VALUE] [-d VALUE] [-u VALUE]" 1>&2
          exit 1 ;;
  esac
done

shift `expr $OPTIND - 1`

PROFILE=$1
ACTION=$2
INSTANCEID=$3


aws cloudwatch put-metric-alarm \
  --alarm-name "awsrds-$INSTANCEID-CPUUtilization" \
  --metric-name CPUUtilization \
  --namespace AWS/RDS \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $CPU_THRESHOLD \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、AuroraのCPU使用率の平均が${CPU_THRESHOLD}%以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=DBInstanceIdentifier,Value=$INSTANCEID \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsrds-$INSTANCEID-FreeableMemory" \
  --metric-name FreeableMemory \
  --namespace AWS/RDS \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $FREERAM \
  --comparison-operator LessThanOrEqualToThreshold \
  --alarm-description "1分間における、Auroraの使用可能なRAM容量の平均が2GB以下" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=DBInstanceIdentifier,Value=$INSTANCEID \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsrds-$INSTANCEID-AuroraReplicaLag" \
  --metric-name AuroraReplicaLag \
  --namespace AWS/RDS \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $REPLICA_LAG \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、AuroraのReplicaLagの平均が${REPLICA_LAG}ms以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=DBInstanceIdentifier,Value=$INSTANCEID \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsrds-$INSTANCEID-Deadlocks" \
  --metric-name Deadlocks \
  --namespace AWS/RDS \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、Auroraのデッドロック回数の合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=DBInstanceIdentifier,Value=$INSTANCEID \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsrds-$INSTANCEID-BlockedTransactions" \
  --metric-name BlockedTransactions \
  --namespace AWS/RDS \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、Auroraのブロックされたトランザクション回数の合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=DBInstanceIdentifier,Value=$INSTANCEID \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsrds-$INSTANCEID-LoginFailures" \
  --metric-name LoginFailures \
  --namespace AWS/RDS \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、Auroraの失敗したログイン回数の合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=DBInstanceIdentifier,Value=$INSTANCEID \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsrds-$INSTANCEID-InsertLatency" \
  --metric-name InsertLatency \
  --namespace AWS/RDS \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $INSERT_LATENCY \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、AuroraのINSERTクエリのレイテンシーの平均が${INSERT_LATENCY}ms以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=DBInstanceIdentifier,Value=$INSTANCEID \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsrds-$INSTANCEID-CommitLatency" \
  --metric-name CommitLatency \
  --namespace AWS/RDS \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $COMMIT_LATENCY \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、Auroraのコミット操作のレイテンシーの平均が${COMMIT_LATENCY}ms以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=DBInstanceIdentifier,Value=$INSTANCEID \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsrds-$INSTANCEID-SelectLatency" \
  --metric-name SelectLatency \
  --namespace AWS/RDS \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $SELECT_LATENCY \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、AuroraのSELECTクエリのレイテンシーの平均が${SELECT_LATENCY}ms以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=DBInstanceIdentifier,Value=$INSTANCEID \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsrds-$INSTANCEID-DeleteLatency" \
  --metric-name DeleteLatency \
  --namespace AWS/RDS \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $DELETE_LATENCY \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、AuroraのDELETEクエリのレイテンシーの平均が${DELETE_LATENCY}ms以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=DBInstanceIdentifier,Value=$INSTANCEID \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsrds-$INSTANCEID-UpdateLatency" \
  --metric-name UpdateLatency \
  --namespace AWS/RDS \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $UPDATE_LATENCY \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、AuroraのUPDATEクエリのレイテンシーの平均が${UPDATE_LATENCY}ms以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=DBInstanceIdentifier,Value=$INSTANCEID \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsrds-$INSTANCEID-DDLLatency" \
  --metric-name DDLLatency \
  --namespace AWS/RDS \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $DDL_LATENCY \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、AuroraのDDLリクエストのレイテンシーの平均が${DDL_LATENCY}ms以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=DBInstanceIdentifier,Value=$INSTANCEID \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsrds-$INSTANCEID-DMLLatency" \
  --metric-name DMLLatency \
  --namespace AWS/RDS \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $DML_LATENCY \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、Auroraの挿入・更新・削除のレイテンシーの平均が${DML_LATENCY}ms以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=DBInstanceIdentifier,Value=$INSTANCEID \
  --profile $PROFILE \
  --region $AWS_REGION
