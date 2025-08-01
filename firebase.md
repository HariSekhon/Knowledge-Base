# Firebase

<!-- INDEX_START -->

- [Fastlane App Distribution to Firebase](#fastlane-app-distribution-to-firebase)
- [Firebase CLI](#firebase-cli)
  - [Firebase Login](#firebase-login)
  - [Firebase Google Application Credentials](#firebase-google-application-credentials)
    - [AdminSDK](#adminsdk)
    - [Dedicated Role with Restricted Permissions](#dedicated-role-with-restricted-permissions)
    - [Configure and test Google Application Credentials](#configure-and-test-google-application-credentials)
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

#### AdminSDK

You can generate this at the top left `Project Settings` -> `Service Accounts` -> `Generate new private key` for the
`firebase-adminsdk-xxxxx@$PROJECT_ID.iam.gserviceaccount.com`.

#### Dedicated Role with Restricted Permissions

If you don't want to use the default adminsdk key, create a new service account by clicking
`Manage service account permissions` at the top right of the above `Service Accounts` page,
then create a new service account and grant it only `Firebase App Distribution Admin`.
Then on the service account page -> `Keys` -> `Add key` and download it.

#### Configure and test Google Application Credentials

```shell
export GOOGLE_APPLICATION_CREDENTIALS="path/to/your-file.json"
```

`firebase login:list` will still show:

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

Unfortunately `projects:list` returns zero even when outputting `No projects found.` imply the credential is invalid or
doesn't have the right permissions.

To test this properly in scripts or [CI/CD](cicd.md):

```shell
num_projects="$(firebase projects:list --json | jq '.result | length')"
if [ "$num_projects" -eq 0 ]; then
    exit 1
fi
```

See also from [DevOps-Bash-tools](devops-bash-tools.md):

```shell
firebase_foreach_project.sh
```

### Configure Default Project

Specifying `--project` for every `firebase` command is tedious.

```text
--project "<project_id>"
```

See the Project ID column from `firebase projects:list`.

Instead, create `.firebaserc`:

```json
{
  "projects": {
    "default": "myproject-dev-id",
    "dev": "myproject-dev-id",
    "staging": "myproject-staging-id",
    "prod": "myproject-production-id",
  }
}
```

You can also use these shorter names:

```text
--project "dev"
```

instead of

```text
--project "myprofile-dev-id"
```

<!-- doesn't seem to work

You can also set:

```shell
export GOOGLE_PROJECT="myproject-dev-id"
```

-->

### List Apps

To get the Firebase App ID that you need to push artifact releases to:

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
