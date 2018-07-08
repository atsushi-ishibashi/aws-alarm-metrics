# lambda

## By Function Name

### `function.sh`
Set `Errors`,`Throttles`,`IteratorAge` for `AWS/Lambda`.
```
sh function.sh <profile> arn:aws:sns:ap-northeast-1:123456789:alarm-sns-basic <FunctionName>
```
-   `$1`: Use a specific profile from your credential file.
-   `$2`: Action ARN
-   `$3`: `FunctionName` value of dimensions. Used for Alarm Name.

## Across All Functions

### `all.sh`
Set `ConcurrentExecutions` for `AWS/Lambda`.
```
sh all.sh <profile> arn:aws:sns:ap-northeast-1:123456789:alarm-sns-basic
```
-   `$1`: Use a specific profile from your credential file.
-   `$2`: Action ARN
-   `-e`: (Option) Threshold for `ConcurrentExecutions`
