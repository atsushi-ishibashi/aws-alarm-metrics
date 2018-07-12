#!/bin/bash

CMDNAME=`basename $0`

BLOCK_THRESHOLD=10.0

while getopts b: OPT
do
  case $OPT in
    "b" ) BLOCK_THRESHOLD="$OPTARG" ;;
      * ) echo "Usage: $CMDNAME [-b VALUE]" 1>&2
          exit 1 ;;
  esac
done

shift `expr $OPTIND - 1`

PROFILE=$1
ACTION=$2
WEBACL=$3
REGION=$4
RULE=$5

aws cloudwatch put-metric-alarm \
  --alarm-name "waf-$WEBACL-$REGION-$RULE-BlockedRequests" \
  --metric-name BlockedRequests \
  --namespace WAF \
  --period 60 \
  --evaluation-periods 1 \
  --statistic Sum \
  --threshold $BLOCK_THRESHOLD \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-description "1分間における、ブロックされたリクエストの合計が${BLOCK_THRESHOLD}以上" \
  --ok-actions $ACTION \
  --alarm-actions $ACTION \
  --dimensions Name=WebACL,Value=$WEBACL Name=Region,Value=$REGION Name=Rule,Value=$RULE \
  --profile $PROFILE \
  --region $AWS_REGION
