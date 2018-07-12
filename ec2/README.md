# ec2

## Per-Instance Metrics

### `instance.sh`
Set `CPUUtilization`,`StatusCheckFailed_Instance`,`StatusCheckFailed_System` for `AWS/EC2`.
```
sh instance.sh <profile> arn:aws:sns:ap-northeast-1:123456789:alarm-sns-basic <InstanceId> <Name>
```
-   `$1`: Use a specific profile from your credential file.
-   `$2`: Action ARN
-   `$3`: `InstanceId` value of dimensions. Used for Alarm Name.
-   `$4`: (Option) `Name` value of dimensions. Used for Alarm Name.
-   `-c`: (Option) Threshold for `CPUUtilization`
