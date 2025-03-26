# Bitbucket

A legacy Git repo hosting provider with the worst [CI/CD](cicd.md) of the major 4 Git hosting providers.

<!-- INDEX_START -->

- [SSH Keys](#ssh-keys)
- [App Passwords](#app-passwords)

<!-- INDEX_END -->

## SSH Keys

<https://bitbucket.org/account/settings/ssh-keys/>

## App Passwords

Create an app password here:

<https://bitbucket.org/account/settings/app-passwords/>

and then copy, save it and export it:

```shell
export BITBUCKET_TOKEN=...
```

Cloning with HTTPS then becomes:

```shell
git clone "https://$BITBUCKET_TOKEN@bitbucket.org/$ORG/$REPO.git"
```

Or better, using a credential helper, taken from my
[.gitconfig](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/.gitconfig):

```text
[credential "https://bitbucket.org"]
    helper = "!f() { sleep 1; echo \"password=${BITBUCKET_TOKEN}\"; }; f"
```

```shell
git clone "https://bitbucket.org/$ORG/$REPO.git"
```
