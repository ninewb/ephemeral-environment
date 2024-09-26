[![Launch Ephemeral Environment](https://github.com/ninewb/ephemeral-environment/actions/workflows/github-actions-ephem-launch.yaml/badge.svg)](https://github.com/ninewb/ephemeral-environment/actions/workflows/github-actions-ephem-launch.yaml)

# ephemeral-environment
Infrastructure as code to stand up a lightweight environment for development purposes.

Codebase can be used to provision an compute environment in Microsoft Azure.

## Action Repository Secrets

| Variable          | Required | Description                                            | Example                                |
| :---------------- | :------: | :----------------------------------------------------- | :------------------------------------- |
| AZURE_CREDENTIALS |   True   |  |  |
| CLIENT_ID         |   True   | |  |
| CLIENT_SECRET     |   True   | |  |
| SSH_PRIVATE_KEY   |   True   | |  |
| SSH_PUBLIC_KEY    |   True   | |  |
| SUBCRIPTION_ID    |   True   | |  |
| TENANT_ID         |   True   | |  |
| TF_API_TOKEN      |   True   | |  |
| VM_USERID         |   True   | |  |


## Action Repository Variables

| Variable       | Required | Description                                            | Example                                |
| :------------- | :------: | :----------------------------------------------------- | :------------------------------------- |
| VM_CIDRS       |   True   | List of CIDRS used for access to environment resources | [ \"10.10.0.0/16\", \"11.11.0.0/24\" ] |
