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

<https://developer.atlassian.com/cloud/bitbucket/changelog/#CHANGE-3222>

<https://bitbucket.org/account/settings/app-passwords/>

## API Tokens

Create an API token here:

<https://id.atlassian.com/manage-profile/security/api-tokens>

and then copy, save it and export it:

```shell
export BITBUCKET_TOKEN=...
```

<https://support.atlassian.com/bitbucket-cloud/docs/using-api-tokens/>

## Git Clone over HTTPS using App Password or API Token

Cloning with HTTPS then becomes:

```shell
git clone "https://$BITBUCKET_USER:$BITBUCKET_TOKEN@bitbucket.org/$ORG/$REPO.git"
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

If you get a 401 or 403 authentication or authorization error...

Check which credential helper you're using:

```shell
git config --list --show-origin | grep credential.helper
file:/opt/homebrew/etc/gitconfig        credential.helper=osxkeychain
```

But the URL specific helper should take precedence:

```shell
git config --get-urlmatch credential.helper https://bitbucket.org
```

Output, we see our function:

```text
!f() { sleep 1; echo "password=${BITBUCKET_TOKEN}"; }; f
```

Check what Git credentials are actually being used:

```shell
printf 'protocol=https\nhost=bitbucket.org\n\n' | git credential fill
```

General Git debug output:

```shell
export GIT_CURL_VERBOSE=1
```

Or in this case this was more useful:

```shell
GIT_TRACE=1 GIT_TRACE_CREDENTIALS=1 git push bitbucket main
```

Output:

```text
21:10:50.086154 git.c:476               trace: built-in: git push bitbucket main
...
21:10:50.473456 run-command.c:673       trace: run_command: 'git credential-osxkeychain get'
21:10:50.474767 run-command.c:765       trace: start_command: /bin/sh -c 'git credential-osxkeychain get' 'git credential-osxkeychain get'
21:10:50.490893 git.c:775               trace: exec: git-credential-osxkeychain get
21:10:50.491732 run-command.c:673       trace: run_command: git-credential-osxkeychain get
```

This is the problem, it's still using the osxkeychain with an old credential instead of the credential helper.

The trace shows that the credential helper doesn't call the function unless you put the username in the URL,
even though the credential helper URL doesn't contain the username as a specific requirement match.

So if you are getting the 403 error, change the URL to this:

```shell
https://$BITBUCKET_USER@bitbucket.org/...
```

You should then see an output like this:

```text
...
21:19:29.447332 run-command.c:673       trace: run_command: 'git credential-osxkeychain get'
21:19:29.448723 run-command.c:765       trace: start_command: /bin/sh -c 'git credential-osxkeychain get' 'git credential-osxkeychain get'
21:19:29.466320 git.c:775               trace: exec: git-credential-osxkeychain get
21:19:29.467065 run-command.c:673       trace: run_command: git-credential-osxkeychain get
21:19:29.467099 run-command.c:765       trace: start_command: /opt/homebrew/opt/git/libexec/git-core/git-credential-osxkeychain get
21:19:29.759814 run-command.c:673       trace: run_command: 'git credential-osxkeychain store'
21:19:29.759936 run-command.c:765       trace: start_command: /bin/sh -c 'git credential-osxkeychain store' 'git credential-osxkeychain store'
21:19:29.778023 git.c:775               trace: exec: git-credential-osxkeychain store
21:19:29.778740 run-command.c:673       trace: run_command: git-credential-osxkeychain store
21:19:29.778756 run-command.c:765       trace: start_command: /opt/homebrew/opt/git/libexec/git-core/git-credential-osxkeychain store
21:19:29.783479 run-command.c:673       trace: run_command: 'f() { sleep 1; echo "password=${BITBUCKET_TOKEN}"; }; f store'
21:19:29.783549 run-command.c:765       trace: start_command: /bin/sh -c 'f() { sleep 1; echo "password=${BITBUCKET_TOKEN}"; }; f store' 'f() { sleep 1; echo "password=${BITBUCKET_TOKEN}"; }; f store'
...
```

Notice the last two lines which show it's now using the function after adding the username into the URL.

Putting the username in credential helper doesn't work as the helper doesn't get called at all judging by the traces,
so this doesn't work on Bitbucket even though it does on other sites like GitHub, GitLab and Azure DevOps:

```properties
[credential "https://bitbucket.org"]
    helper = "!f() { sleep 1; echo \"username=${BITBUCKET_USER}\"; echo \"password=${BITBUCKET_TOKEN}\"; }; f"
```
