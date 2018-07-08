#!/bin/bash

CMDNAME=`basename $0`

GET_THRESHOLD=20.0
BATCH_GET_THRESHOLD=100.0
PUT_THRESHOLD=20.0
BATCH_WRITE_THRESHOLD=100.0
UPDATE_THRESHOLD=20.0
QUERY_THRESHOLD=20.0
DELETE_THRESHOLD=20.0

while getopts g:b:p:w:u:q:d: OPT
do
  case $OPT in
    "g" ) CPU_THRESHOLD="$OPTARG" ;;
    "b" ) CPU_THRESHOLD="$OPTARG" ;;
    "p" ) CPU_THRESHOLD="$OPTARG" ;;
    "w" ) CPU_THRESHOLD="$OPTARG" ;;
    "u" ) CPU_THRESHOLD="$OPTARG" ;;
    "q" ) CPU_THRESHOLD="$OPTARG" ;;
    "d" ) CPU_THRESHOLD="$OPTARG" ;;
      * ) echo "Usage: $CMDNAME [-g VALUE] [-b VALUE] [-p VALUE] [-w VALUE] [-u VALUE] [-q VALUE] [-d VALUE]" 1>&2
          exit 1 ;;
  esac
done

shift `expr $OPTIND - 1`

PROFILE=$1
ACTION=$2
TABLE=$3

aws cloudwatch put-metric-alarm \
  --alarm-name "awsdynamodb-$TABLE-GetItem-SuccessfulRequestLatency" \
  --metric-name SuccessfulRequestLatency \
  --namespace AWS/DynamoDB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $GET_THRESHOLD \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、成功したリクエストの経過時間の平均が${GET_THRESHOLD}ms以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TableName,Value=$TABLE Name=Operation,Value=GetItem \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsdynamodb-$TABLE-GetItem-ThrottledRequests" \
  --metric-name ThrottledRequests \
  --namespace AWS/DynamoDB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、プロビジョニングされたスループットの上限を超えるDynamoDBへのリクエストの合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TableName,Value=$TABLE Name=Operation,Value=GetItem \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsdynamodb-$TABLE-GetItem-SystemErrors" \
  --metric-name SystemErrors \
  --namespace AWS/DynamoDB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、HTTP500を生成するDynamoDBへのリクエストの合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TableName,Value=$TABLE Name=Operation,Value=GetItem \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsdynamodb-$TABLE-BatchGetItem-SuccessfulRequestLatency" \
  --metric-name SuccessfulRequestLatency \
  --namespace AWS/DynamoDB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $BATCH_GET_THRESHOLD \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、成功したリクエストの経過時間の平均が${BATCH_GET_THRESHOLD}ms以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TableName,Value=$TABLE Name=Operation,Value=BatchGetItem \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsdynamodb-$TABLE-BatchGetItem-ThrottledRequests" \
  --metric-name ThrottledRequests \
  --namespace AWS/DynamoDB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、プロビジョニングされたスループットの上限を超えるDynamoDBへのリクエストの合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TableName,Value=$TABLE Name=Operation,Value=BatchGetItem \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsdynamodb-$TABLE-BatchGetItem-SystemErrors" \
  --metric-name SystemErrors \
  --namespace AWS/DynamoDB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、HTTP500を生成するDynamoDBへのリクエストの合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TableName,Value=$TABLE Name=Operation,Value=BatchGetItem \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsdynamodb-$TABLE-PutItem-SuccessfulRequestLatency" \
  --metric-name SuccessfulRequestLatency \
  --namespace AWS/DynamoDB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $PUT_THRESHOLD \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、成功したリクエストの経過時間の平均が${PUT_THRESHOLD}ms以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TableName,Value=$TABLE Name=Operation,Value=PutItem \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsdynamodb-$TABLE-PutItem-ThrottledRequests" \
  --metric-name ThrottledRequests \
  --namespace AWS/DynamoDB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、プロビジョニングされたスループットの上限を超えるDynamoDBへのリクエストの合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TableName,Value=$TABLE Name=Operation,Value=PutItem \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsdynamodb-$TABLE-PutItem-SystemErrors" \
  --metric-name SystemErrors \
  --namespace AWS/DynamoDB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、HTTP500を生成するDynamoDBへのリクエストの合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TableName,Value=$TABLE Name=Operation,Value=PutItem \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsdynamodb-$TABLE-BatchWriteItem-SuccessfulRequestLatency" \
  --metric-name SuccessfulRequestLatency \
  --namespace AWS/DynamoDB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $BATCH_WRITE_THRESHOLD \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、成功したリクエストの経過時間の平均が${BATCH_WRITE_THRESHOLD}ms以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TableName,Value=$TABLE Name=Operation,Value=BatchWriteItem \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsdynamodb-$TABLE-BatchWriteItem-ThrottledRequests" \
  --metric-name ThrottledRequests \
  --namespace AWS/DynamoDB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、プロビジョニングされたスループットの上限を超えるDynamoDBへのリクエストの合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TableName,Value=$TABLE Name=Operation,Value=BatchWriteItem \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsdynamodb-$TABLE-BatchWriteItem-SystemErrors" \
  --metric-name SystemErrors \
  --namespace AWS/DynamoDB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、HTTP500を生成するDynamoDBへのリクエストの合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TableName,Value=$TABLE Name=Operation,Value=BatchWriteItem \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsdynamodb-$TABLE-UpdateItem-SuccessfulRequestLatency" \
  --metric-name SuccessfulRequestLatency \
  --namespace AWS/DynamoDB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $UPDATE_THRESHOLD \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、成功したリクエストの経過時間の平均が${UPDATE_THRESHOLD}ms以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TableName,Value=$TABLE Name=Operation,Value=UpdateItem \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsdynamodb-$TABLE-UpdateItem-ThrottledRequests" \
  --metric-name ThrottledRequests \
  --namespace AWS/DynamoDB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、プロビジョニングされたスループットの上限を超えるDynamoDBへのリクエストの合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TableName,Value=$TABLE Name=Operation,Value=UpdateItem \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsdynamodb-$TABLE-UpdateItem-SystemErrors" \
  --metric-name SystemErrors \
  --namespace AWS/DynamoDB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、HTTP500を生成するDynamoDBへのリクエストの合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TableName,Value=$TABLE Name=Operation,Value=UpdateItem \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsdynamodb-$TABLE-Query-SuccessfulRequestLatency" \
  --metric-name SuccessfulRequestLatency \
  --namespace AWS/DynamoDB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $QUERY_THRESHOLD \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、成功したリクエストの経過時間の平均が${QUERY_THRESHOLD}ms以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TableName,Value=$TABLE Name=Operation,Value=Query \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsdynamodb-$TABLE-Query-ThrottledRequests" \
  --metric-name ThrottledRequests \
  --namespace AWS/DynamoDB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、プロビジョニングされたスループットの上限を超えるDynamoDBへのリクエストの合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TableName,Value=$TABLE Name=Operation,Value=Query \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsdynamodb-$TABLE-Query-SystemErrors" \
  --metric-name SystemErrors \
  --namespace AWS/DynamoDB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、HTTP500を生成するDynamoDBへのリクエストの合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TableName,Value=$TABLE Name=Operation,Value=Query \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsdynamodb-$TABLE-DeleteItem-SuccessfulRequestLatency" \
  --metric-name SuccessfulRequestLatency \
  --namespace AWS/DynamoDB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $DELETE_THRESHOLD \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、成功したリクエストの経過時間の平均が${DELETE_THRESHOLD}ms以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TableName,Value=$TABLE Name=Operation,Value=DeleteItem \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsdynamodb-$TABLE-DeleteItem-ThrottledRequests" \
  --metric-name ThrottledRequests \
  --namespace AWS/DynamoDB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、プロビジョニングされたスループットの上限を超えるDynamoDBへのリクエストの合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TableName,Value=$TABLE Name=Operation,Value=DeleteItem \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsdynamodb-$TABLE-DeleteItem-SystemErrors" \
  --metric-name SystemErrors \
  --namespace AWS/DynamoDB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、HTTP500を生成するDynamoDBへのリクエストの合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TableName,Value=$TABLE Name=Operation,Value=DeleteItem \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsdynamodb-$TABLE-Scan-ThrottledRequests" \
  --metric-name ThrottledRequests \
  --namespace AWS/DynamoDB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、プロビジョニングされたスループットの上限を超えるDynamoDBへのリクエストの合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TableName,Value=$TABLE Name=Operation,Value=Scan \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awsdynamodb-$TABLE-Scan-SystemErrors" \
  --metric-name SystemErrors \
  --namespace AWS/DynamoDB \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、HTTP500を生成するDynamoDBへのリクエストの合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=TableName,Value=$TABLE Name=Operation,Value=Scan \
  --profile $PROFILE \
  --region $AWS_REGION
