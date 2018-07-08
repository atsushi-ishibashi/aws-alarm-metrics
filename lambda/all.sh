#!/bin/bash

CMDNAME=`basename $0`

CE_THRESHOLD=80

while getopts e: OPT
do
  case $OPT in
    "e" ) CE_THRESHOLD="$OPTARG" ;;
      * ) echo "Usage: $CMDNAME [-e VALUE]" 1>&2
          exit 1 ;;
  esac
done

shift `expr $OPTIND - 1`

PROFILE=$1
ACTION=$2

aws cloudwatch put-metric-alarm \
  --alarm-name "awslambda-ConcurrentExecutions" \
  --metric-name ConcurrentExecutions \
  --namespace AWS/Lambda \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Maximum \
  --threshold $CE_THRESHOLD \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、アカウント内で同時実行されたLambda関数の数の最大が${CE_THRESHOLD}以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --profile $PROFILE \
  --region $AWS_REGION
