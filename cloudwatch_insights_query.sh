#!/bin/bash

#Example usage = ./cloudwatch_insights_query.sh my-aws-profile "/my/loggroup.json" `date -v-300M "+%s"` `date "+%s"` "fields @message | filter @message like /mickey/" 5

PROFILE=$1
LOG_GROUP_NAME=$2
START_TIME=$3
END_TIME=$4
QUERY_STRING=$5
LIMIT=$6

echo "Query = $QUERY_STRING"

QUERY_ID_JSON=$(aws logs start-query \
 --profile $PROFILE \
 --log-group-name $LOG_GROUP_NAME \
 --start-time $START_TIME \
 --end-time $END_TIME \
 --query-string "$QUERY_STRING" \
 --limit $LIMIT)

QUERY_ID=$(echo $QUERY_ID_JSON | jq -r '.queryId')
echo "Query result Id = $QUERY_ID"

QUERY_STATUS=""

while [ "$QUERY_STATUS" != "Complete" ]
  do
    QUERY_RESULT=$(aws --profile $PROFILE logs get-query-results --query-id $QUERY_ID)
    QUERY_STATUS=$(echo $QUERY_RESULT | jq -r '.status')
    echo $QUERY_STATUS
    sleep 5
done

aws --profile $PROFILE logs get-query-results --query-id $QUERY_ID | jq
