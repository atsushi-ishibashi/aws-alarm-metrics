# alarm-lambda-duration

CloudwatchAlarm -> SNS -> Lambda

## Overview

Receive alarm messages via SNS Topic and notify to Slack.

When `duration / timeout` is greater than or equal to `THRE`, it will send message to Slack.

### Build & Deploy

    $ make build THRE=0.8
    $ make deploy function=<function-name> profile=<profile> region=<region>

### requirements

#### environment variables

-   `SLACK_URL`
-   `AWS_REGION`

#### IAM Policy

`<function>` is the monitored Lambda.

    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": "lambda:GetFunction",
                "Resource": "arn:aws:lambda:<region>:<account>:function:<function>"
            }
        ]
    }

### Alarm

#### `lambda.sh`

Set `Duration` for `AWS/Lambda`.

    sh lambda.sh <profile> <ActionARN> <FunctionName>

-   `$1`: Use a specific profile from your credential file.
-   `$2`: Action ARN
-   `$3`: `FunctionName` value of dimensions. Used for Alarm Name.
-   `-d`: (Option) Threshold for `Duration`
