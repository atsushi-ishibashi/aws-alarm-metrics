#!/bin/bash

CMDNAME=`basename $0`

DUR_THRESHOLD=2000

while getopts i: OPT
do
  case $OPT in
    "d" ) DUR_THRESHOLD="$OPTARG" ;;
      * ) echo "Usage: $CMDNAME [-d VALUE]" 1>&2
          exit 1 ;;
  esac
done

shift `expr $OPTIND - 1`

PROFILE=$1
ACTION=$2
FUNCTION=$3

aws cloudwatch put-metric-alarm \
  --alarm-name "awslambda-$FUNCTION-Duration" \
  --metric-name Duration \
  --namespace AWS/Lambda \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Maximum \
  --threshold $DUR_THRESHOLD \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、Lambdaの実行時間の最大が${DUR_THRESHOLD}ms以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=FunctionName,Value=$FUNCTION \
  --profile $PROFILE \
  --region $AWS_REGION
