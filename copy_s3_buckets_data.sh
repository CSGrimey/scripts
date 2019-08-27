#!/bin/bash

#Usage: bash copyS3Buckets.sh identity arn:aws:iam::1234:role/someRole fromBucketName/ toBucketName/

export AWS_PROFILE=$1
export AWS_ROLE_ARN=$2

aws configure set default.s3.max_concurrent_requests 1000
aws configure set default.s3.max_queue_size 100000

# Set some environment variables (you need aws cli and jq):
$(aws sts assume-role --profile "$AWS_PROFILE" --role-arn "$AWS_ROLE_ARN" --role-session-name "my-test-session" | jq -r '"export AWS_ACCESS_KEY_ID=" + .Credentials.AccessKeyId + " AWS_SECRET_ACCESS_KEY=" + .Credentials.SecretAccessKey + " AWS_SESSION_TOKEN=" + .Credentials.SessionToken')

aws s3 sync s3://$3 s3://$4
