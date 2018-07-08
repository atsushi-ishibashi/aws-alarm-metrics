# workspaces

## By WorkSpace ID

### `workspaces.sh`
Set `Unhealthy`,`ConnectionFailure` for `AWS/WorkSpaces`.
```
sh workspaces.sh <profile> arn:aws:sns:ap-northeast-1:123456789:alarm-sns-basic <WorkspaceId>
```
-   `$1`: Use a specific profile from your credential file.
-   `$2`: Action ARN
-   `$3`: `WorkspaceId` value of dimensions. Used for Alarm Name.
