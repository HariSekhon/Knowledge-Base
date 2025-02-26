# Firebase

<!-- INDEX_START -->

- [Fastlane App Distribution to Firebase](#fastlane-app-distribution-to-firebase)
- [Firebase CLI](#firebase-cli)
  - [Firebase Login](#firebase-login)
  - [Firebase Google Application Credentials](#firebase-google-application-credentials)
  - [List Projects](#list-projects)
  - [Configure Default Project](#configure-default-project)
  - [List Apps](#list-apps)
  - [Firebase App Distribution Upload](#firebase-app-distribution-upload)

<!-- INDEX_END -->

## Fastlane App Distribution to Firebase

See [Fastlane](fastlane.md) doc and this doc:

<https://firebase.google.com/docs/app-distribution/ios/distribute-fastlane>

## Firebase CLI

<https://firebase.google.com/docs/cli>

On Mac:

```shell
brew install firebase-cli
```

Or using npm:

```shell
npm install -g firebase-tools
```

Or using autoinstall script:

```shell
curl -sL https://firebase.tools | bash
```

Or from [DevOps-Bash-tools](devops-bash-tools.md):

```shell
install_firebase_cli.sh
```

Or download and `chmod +x` it manually from:

<https://firebase.tools/bin/macos/latest>

<https://firebase.tools/bin/linux/latest>

(these redirect to the latest release from <https://github.com/firebase/firebase-tools/releases/>)

### Firebase Login

Interactive web browser redirect to log in as your user.

```shell
firebase login
```

```shell
firebase login:list
```

```text
Logged in as hari@domain.com
```

### Firebase Google Application Credentials

```shell
export GOOGLE_APPLICATION_CREDENTIALS="path/to/your-file.json"
```

`firebase login` will still show:

```text
 ⚠  No authorized accounts, run "firebase login"
```

but commands will work. List projects to prove it.

### List Projects

```shell
firebase projects:list
```

```shell
firebase projects:list --json
```

See also from [DevOps-Bash-tools](devops-bash-tools.md):

```shell
firebase_foreach_project.sh
```

### Configure Default Project

To avoid having to specify the `--project` arg to `firebase apps:list` each time...

Requires both the `.firebaserc` file and the `GOOGLE_PROJECT` environment variable to be set:

`.firebaserc`:

```json
{
  "projects": {
    "default": "myproject",
    "myenv": "myproject"
  }
}
```

```shell
export GOOGLE_PROJECT="myproject"
```

### List Apps

```shell
firebase apps:list --project "myproject"
```

or if you've set up the project config defaults above:

```shell
firebase apps:list
```

```shell
firebase apps:list --json
```

### Firebase App Distribution Upload

Tester emails are comma separated.

```shell
firebase appdistribution:distribute \
        --testers "$TESTER_EMAILS" \
        --app "$FIREBASE_APP_ID" \
        build/"$APP-$ENV".ipa
```
