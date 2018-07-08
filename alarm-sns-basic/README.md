# alarm-sns-basic

CloudwatchAlarm -> SNS -> Lambda

## Overview

Receive alarm messages via SNS Topic and notify to Slack.

When the function receive _ALARM_, it will send the below message

    *:exclamation:ALARM: <AlarmDescription>*
    <AlarmName>
    <NewStateReason> @<StateChangeTime>

In the case of *OK*, it will send the below message only when the old state is _ALARM_

    *:white_check_mark:OK: <AlarmDescription>*
    <AlarmName>
    <NewStateReason> @<StateChangeTime>

### Build & Deploy
```
$ make build
$ make deploy function=<function-name> profile=<profile> region=<region>
```

### requirements

#### environment variables

-   `SLACK_URL`
