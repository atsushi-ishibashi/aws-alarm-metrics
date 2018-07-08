#!/bin/bash

CMDNAME=`basename $0`

IA_THRESHOLD=500

while getopts i: OPT
do
  case $OPT in
    "i" ) IA_THRESHOLD="$OPTARG" ;;
      * ) echo "Usage: $CMDNAME [-i VALUE]" 1>&2
          exit 1 ;;
  esac
done

shift `expr $OPTIND - 1`

PROFILE=$1
ACTION=$2
FUNCTION=$3

aws cloudwatch put-metric-alarm \
  --alarm-name "awslambda-$FUNCTION-Errors" \
  --metric-name Errors \
  --namespace AWS/Lambda \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、関数エラーが原因で失敗した呼び出しの数の合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=FunctionName,Value=$FUNCTION \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awslambda-$FUNCTION-Throttles" \
  --metric-name Throttles \
  --namespace AWS/Lambda \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold 1.0 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、同時オペレーションを超える呼び出しレートのために調整されたLambdaの呼び出し試行の回数の合計が1以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=FunctionName,Value=$FUNCTION \
  --profile $PROFILE \
  --region $AWS_REGION

aws cloudwatch put-metric-alarm \
  --alarm-name "awslambda-$FUNCTION-IteratorAge" \
  --metric-name IteratorAge \
  --namespace AWS/Lambda \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Average \
  --threshold $IA_THRESHOLD \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、ストリームベースで呼び出されるLambdaの処理遅延の平均が${IA_THRESHOLD}ms以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=FunctionName,Value=$FUNCTION \
  --profile $PROFILE \
  --region $AWS_REGION
