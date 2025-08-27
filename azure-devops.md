# Azure DevOps

Suite of DevOps related tools including repository management, [CI/CD](cicd.md) using a yaml config file etc.

<!-- INDEX_START -->

- [Azure DevOps Pipelines](#azure-devops-pipelines)
- [Azure DevOps Profile](#azure-devops-profile)
- [SSH Keys](#ssh-keys)
- [API Tokens](#api-tokens)
- [Git Cloning over HTTPS using API Token](#git-cloning-over-https-using-api-token)
  - [Credential Helper](#credential-helper)
- [Azure DevOps CLI](#azure-devops-cli)

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

## Git Cloning over HTTPS using API Token

Cloning with HTTPS then becomes:

```shell
git clone "https://$AZURE_DEVOPS_TOKEN@dev.azure.com/$USER/$PROJECT/_git/$REPO"
```

or better using a credential helper...

### Credential Helper

Taken from my [.gitconfig](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/.gitconfig):

```properties
[credential "https://dev.azure.com"]
helper = "!f() { sleep 1; echo \"username=${AZURE_DEVOPS_USER}\"; echo \"password=${AZURE_DEVOPS_TOKEN}\"; }; f"
```

```shell
git clone "https://dev.azure.com/$USER/$PROJECT/_git/$REPO"
```

## Azure DevOps CLI

```shell
az devops configure --defaults organization=https://dev.azure.com/harisekhon
```

```text
Preview version of extension is disabled by default for extension installation, enabled for modules without stable versions.
Please run 'az config set extension.dynamic_install_allow_preview=true or false' to config it specifically.
The command requires the extension azure-devops. Do you want to install it now? The command will continue to run after the extension is installed. (Y/n):
Run 'az config set extension.use_dynamic_install=yes_without_prompt' to allow installing extensions without prompt.
```

```shell
az devops login
```

```text
Token:
```

```shell
az devops user show
```
