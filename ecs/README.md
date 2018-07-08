# ecs

## ClusterName

### `cluster.sh`
Set `CPUUtilization`,`MemoryUtilization` for `AWS/ECS`.
```
sh cluster.sh <profile> arn:aws:sns:ap-northeast-1:123456789:alarm-sns-basic <ClusterName>
```
-   `$1`: Use a specific profile from your credential file.
-   `$2`: Action ARN
-   `$3`: `ClusterName` value of dimensions. Used for Alarm Name.
-   `-c`: (Option) Threshold for `CPUUtilization`
-   `-m`: (Option) Threshold for `MemoryUtilization`

## ClusterName, ServiceName

### `service.sh`
Set `CPUUtilization`,`MemoryUtilization` for `AWS/ECS`.
```
sh service.sh <profile> arn:aws:sns:ap-northeast-1:123456789:alarm-sns-basic <ClusterName> <ServiceName>
```
-   `$1`: Use a specific profile from your credential file.
-   `$2`: Action ARN
-   `$3`: `ClusterName` value of dimensions. Used for Alarm Name.
-   `$4`: `ServiceName` value of dimensions. Used for Alarm Name.
-   `-c`: (Option) Threshold for `CPUUtilization`
-   `-m`: (Option) Threshold for `MemoryUtilization`
