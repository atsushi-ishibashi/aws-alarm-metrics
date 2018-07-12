# waf

## Region, Rule, WebACL

### `rule.sh`
Set `BlockedRequests` for `WAF`.
```
sh rule.sh <profile> arn:aws:sns:ap-northeast-1:123456789:alarm-sns-basic <WebACL> <Region> <Rule>
```
-   `$1`: Use a specific profile from your credential file.
-   `$2`: Action ARN
-   `$3`: `WebACL` value of dimensions. Used for Alarm Name.
-   `$4`: `Region` value of dimensions. Used for Alarm Name.
-   `$5`: `Rule` value of dimensions. Used for Alarm Name.
-   `-b`: (Option) Threshold for `BlockedRequests`
