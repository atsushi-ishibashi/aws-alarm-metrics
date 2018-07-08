# elasticache

## Cache Cluster ID

### `redis.sh`
Set `CPUUtilization`,`EngineCPUUtilization`,`SwapUsage`,`ReplicationLag`,`Evictions`,`CurrConnections` for `AWS/ElastiCache`
```
sh redis.sh -c 45.0 <profile> arn:aws:sns:ap-northeast-1:123456789:alarm-sns-basic <CacheClusterId>
```
-   `-c`: (Option) Threshold for `CPUUtilization`
-   `-r`: (Option) Threshold for `CurrConnections`
-   `$1`: Use a specific profile from your credential file.
-   `$2`: Action ARN
-   `$3`: `CacheClusterId` value of dimensions. Used for Alarm Name.
