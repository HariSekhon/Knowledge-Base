# Bitbucket

A legacy Git repo hosting provider with the worst [CI/CD](cicd.md) of the major 4 Git hosting providers.

<!-- INDEX_START -->

- [SSH Keys](#ssh-keys)
- [API Tokens](#api-tokens)
- [Git Clone over HTTPS using API Token](#git-clone-over-https-using-api-token)
  - [Credential Helper](#credential-helper)

<!-- INDEX_END -->

## SSH Keys

<https://bitbucket.org/account/settings/ssh-keys/>

## API Tokens

Create an API token here:

<https://id.atlassian.com/manage-profile/security/api-tokens>

and then copy, save it and export it:

```shell
export BITBUCKET_TOKEN=...
```

## Git Clone over HTTPS using API Token

Cloning with HTTPS then becomes:

```shell
git clone "https://$BITBUCKET_TOKEN@bitbucket.org/$ORG/$REPO.git"
```

or better using a credential helper...

### Credential Helper

Taken from my [.gitconfig](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/.gitconfig):

```properties
[credential "https://bitbucket.org"]
    helper = "!f() { sleep 1; echo \"password=${BITBUCKET_TOKEN}\"; }; f"
```

```shell
git clone "https://bitbucket.org/$ORG/$REPO.git"
```

If you get a 401 or 403 authentication or authorization error, you can check Git debug output by setting:

```shell
export GIT_CURL_VERBOSE=1
```
