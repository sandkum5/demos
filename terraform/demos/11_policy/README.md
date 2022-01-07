# Steps to test policy

Pre-requisites:
- jq
- conftest

1. terraform init
2. terraform plan -out=tfplan.binary
3. terraform show -json tfplan.binary | jq > tfplan.json
4. conftest test tfplan.json

```terraform
Sample Output:

% conftest test tfplan-2.json
FAIL - tfplan-2.json - main - there should be 2 total intersight_ntp_policy
1 test, 0 passed, 0 warnings, 1 failure, 0 exceptions
%

% conftest test tfplan-2.json
1 test, 1 passed, 0 warnings, 0 failures, 0 exceptions
%
```
