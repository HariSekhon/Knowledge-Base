# Bitbucket

A legacy Git repo hosting provider with the worst [CI/CD](cicd.md) of the major 4 Git hosting providers.

<!-- INDEX_START -->

- [SSH Keys](#ssh-keys)
- [App Passwords](#app-passwords)
- [API Tokens](#api-tokens)
- [Git Clone over HTTPS using App Password or API Token](#git-clone-over-https-using-app-password-or-api-token)
  - [Credential Helper](#credential-helper)

<!-- INDEX_END -->

## SSH Keys

<https://bitbucket.org/account/settings/ssh-keys/>

## App Passwords

Deprecated in favour of API Tokens.

<https://bitbucket.org/account/settings/app-passwords/>

## API Tokens

Create an API token here:

<https://id.atlassian.com/manage-profile/security/api-tokens>

and then copy, save it and export it:

```shell
export BITBUCKET_TOKEN=...
```

## Git Clone over HTTPS using App Password or API Token

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

You may need to put your username in the Bitbucket URL if using App Passwords in order to get past the 403 error:

```shell
https://harisekhon@bitbucket.org/...
```

in order to get this to work as the behaviour even when trying the credential helper with the username seems to not work:

```properties
[credential "https://bitbucket.org"]
    helper = "!f() { sleep 1; echo \"username=${BITBUCKET_USER}\"; echo \"password=${BITBUCKET_TOKEN}\"; }; f"
```
