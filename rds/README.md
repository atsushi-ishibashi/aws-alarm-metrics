# rds

## Per-Database Metrics

### `aurora-mysql.sh`
Set `CPUUtilization`,`FreeableMemory`,`AuroraReplicaLag`,`Deadlocks`,`BlockedTransactions`,`LoginFailures`,
`SelectLatency`,`InsertLatency`,`CommitLatency`,`UpdateLatency`,`DeleteLatency`,`DDLLatency`,`DMLLatency` for `AWS/RDS`
```
sh aurora-mysql.sh <profile> arn:aws:sns:ap-northeast-1:123456789:alarm-sns-basic <DBInstanceIdentifier>
```
-   `$1`: Use a specific profile from your credential file.
-   `$2`: Action ARN
-   `$3`: `DBInstanceIdentifier` value of dimensions. Used for Alarm Name.
-   `-s`: (Option) Threshold for `SelectLatency`
-   `-i`: (Option) Threshold for `InsertLatency`
-   `-c`: (Option) Threshold for `CommitLatency`
-   `-u`: (Option) Threshold for `UpdateLatency`
-   `-d`: (Option) Threshold for `DeleteLatency`
