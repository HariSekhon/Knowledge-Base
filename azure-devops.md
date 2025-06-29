# Azure DevOps

Suite of DevOps related tools including repository management, [CI/CD](cicd.md) using a yaml config file etc.

<!-- INDEX_START -->

- [Azure DevOps Pipelines](#azure-devops-pipelines)
- [Azure DevOps Profile](#azure-devops-profile)
- [SSH Keys](#ssh-keys)
- [API Tokens](#api-tokens)

<!-- INDEX_END -->

## Azure DevOps Pipelines

Azure DevOps Pipelines is the CI/CD in the Azure DevOps suite.

It is the Azure equivalent to [GitHub Actions](github-actions.md), [GitLab CI](gitlab-ci.md) and [Bitbucket Pipelines](bitbucket.md).

You can see a summary of keys points and comparisons to the other CI/CD systems on the [CI/CD](cicd.md) page.

## Azure DevOps Profile

You can check your Azure DevOps profile here:

<https://aex.dev.azure.com/me>

## SSH Keys

Use an SSH Key to do an SSH-based [git](git.md) push/pull.

Add your SSH key at the top right of the screen -> `User Settings` -> `SSH Public Keys` which should take you to a URL
like this ending in `/_userSettings/keys`:

```text
https://dev.azure.com/<YOUR_USERNAME>/_usersSettings/keys
```

eg.

<https://dev.azure.com/harisekhon/_usersSettings/keys>

## API Tokens

Use API tokens to interact programmatically with Azure DevOps
or to do HTTPS [git](git.md) push/pull to bypass egress firewall restrictions.

Create an API token at the top right of the screen -> `User Settings` -> `Personal access tokens` which should take you
to a URL like this ending in `/_userSettings/tokens`:

```text
https://dev.azure.com/<YOUR_USERNAME>/_usersSettings/tokens
```

<https://dev.azure.com/harisekhon/_usersSettings/tokens>
