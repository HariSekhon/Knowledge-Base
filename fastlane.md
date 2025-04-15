# Fastlane - Mobile Builds

<https://fastlane.tools/>

Open source mobile build automation tool for iOS and Android.

<!-- INDEX_START -->

- [Summary](#summary)
- [Install](#install)
  - [Install Fastlane with Homebrew](#install-fastlane-with-homebrew)
  - [Install Fastlane with Bundler](#install-fastlane-with-bundler)
- [Environment Variables](#environment-variables)
- [Fastlane Template](#fastlane-template)
- [Examples](#examples)
- [Instantiate New Fastfile Config](#instantiate-new-fastfile-config)
- [Lanes](#lanes)
- [Build](#build)
- [Actions](#actions)
- [Plugins](#plugins)
- [DotEnv Support](#dotenv-support)
- [Code Signing](#code-signing)
  - [Code Signing on Android](#code-signing-on-android)
- [Match](#match)
  - [Initialize Matchfile config](#initialize-matchfile-config)
  - [Authenticating CI/CD to Matchfiles repo](#authenticating-cicd-to-matchfiles-repo)
    - [HTTPS Authorization Token](#https-authorization-token)
    - [SSH Authorization via Deploy Key](#ssh-authorization-via-deploy-key)
  - [Populate Matchfiles Repo](#populate-matchfiles-repo)
    - [Generate Public Certificate from .p12](#generate-public-certificate-from-p12)
    - [Upload SSL cert, p12 and mobileprovision profile to Git branch](#upload-ssl-cert-p12-and-mobileprovision-profile-to-git-branch)
    - [Import All MobileProfiles](#import-all-mobileprofiles)
  - [Configure Fastfile to use Match](#configure-fastfile-to-use-match)
- [Tests](#tests)
  - [Scan - Run Xcode Tests](#scan---run-xcode-tests)
  - [Android Tests using Gradle](#android-tests-using-gradle)
- [Screenshots](#screenshots)
  - [iOS Screenshots](#ios-screenshots)
  - [Android Screenshots](#android-screenshots)
- [Upload Artifacts](#upload-artifacts)
  - [iOS](#ios)
    - [Upload to Apple TestFlight](#upload-to-apple-testflight)
    - [Upload to App Store](#upload-to-app-store)
  - [Android](#android)
    - [Upload to Google Play Store](#upload-to-google-play-store)
  - [Firebase App Distribution](#firebase-app-distribution)
- [Notifications](#notifications)
- [Generating Lane Documentation](#generating-lane-documentation)
- [Troubleshooting](#troubleshooting)
  - [Verbose Mode](#verbose-mode)
- [Other Resources](#other-resources)

<!-- INDEX_END -->

## Summary

Useful for both local builds and [CI/CD](cicd.md).

Integrates seamlessly with the App Store natively and Firebase App Distribution (via
[plugin](#fastlane-app-distribution-to-firebase)).

Ruby-based declarative `fastlane/Fastfile` with many built-in constructs to do common tasks with a simple keyword.

Is reminiscent of many other build systems, eg. Fastlane _lanes_ are equivalent of `Makefile` build targets.

Read the Mobile Builds pages for iOS and Android before moving to Fastlane as you will need to install things like
Xcode for iOS.

<https://docs.fastlane.tools/getting-started/ios/setup/>

<https://docs.fastlane.tools/getting-started/android/setup/>

## Install

### Install Fastlane with Homebrew

```shell
brew install fastlane
```

Upgrade fastlane using the standard brew command:

```shell
brew upgrade fastlane
```

Check version:

```shell
fastlane -v
```

### Install Fastlane with Bundler

```shell
gem install bundler
```

Create a `Gemfile`:

```ruby
source "https://rubygems.org"

gem "fastlane"
```

Run bundler to install the gems from the `Gemfile`, in this case Fastlane:

```shell
bundle update
```

Commit the `Gemfile` and also the `Gemfile.lock` to pin the versions:

```shell
git add Gemfile Gemfile.lock
git commit -m "added Gemfile and Gemfile.lock" Gemfile Gemfile.lock
```

Execute fastlane through bundler:

```shell
bundle exec fastlane [lane]
```

Update fastlane:

```shell
bundle update fastlane
```

Check new version:

```shell
fastlane -v
```

or

```shell
bundle exec fastlane -v
```

## Environment Variables

Fastlane recommends settings these:

```shell
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
```

For [CI/CD](cicd.md):

```shell
export FASTLANE_SKIP_UPDATE_CHECK=1
```

## Fastlane Template

<https://github.com/HariSekhon/Templates/blob/master/fastlane/Fastfile>

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=Templates&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/Templates)

## Examples

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=fastlane&repo=examples&theme=tokyonight&description_lines_count=1)](https://github.com/fastlane/examples)

## Instantiate New Fastfile Config

<https://docs.fastlane.tools/actions/create_app_online/>

If you want to do it the hard way from scratch instead of using the above template...

```shell
fastlane init
```

This will generate a skeleton `fastlane/Fastfile`, `fastlane/Appfile`, `Gemfile`, `Gemfile.lock` for you.

For publishing to App Store you need to populate the developer / company name:

```shell
PRODUCE_COMPANY_NAME="YOUR COMPANY NAME" fastlane init
```

To have `Fastfile` configuration written in Swift:

```shell
fastlane init swift
```

## Lanes

Fastlane's *'lanes'* are analogous to `Makefile` *'targets'* - specifying one as an argument chooses which Fastlane code block to execute.

List the configured lanes in your project's `fastlane/Fastfile`:

```shell
fastlane lanes
```

Build a specific lane:

```shell
fastlane "$lane"
```

## Build

A simple iOS example of defining a lane in your `fastlane/Fastfile`:

```ruby
lane :build_and_deploy do
  match(type: "appstore")       # Fetch code-signing certificates
  build_app(scheme: "MyApp")    # Build the app
  pilot                         # Upload the .ipa artifact to Apple TestFlight
end
```

Run the lane via the command:

```shell
fastlane build_and_deploy
```

Since that lane's code block contains `build_app()` it'll run `xcodebuild` on [iOS](ios.md)
and use `xcbeautify` if available, else `xcpretty`.

See the [xcodebuild-formatters](https://docs.fastlane.tools/best-practices/xcodebuild-formatters/) fastlane doc.

eg.

```shell
set -o pipefail && xcodebuild -workspace "$APP".xcworkspace -scheme "$SCHEME" -configuration "$CONFIGURATION" -destination 'generic/platform=iOS' -archivePath ./build/"$APP".xcarchive archive | tee /Users/"$USER"/Library/Logs/gym/"$APP-$SCHEME".log | xcpretty
```

or

```shell
set -o pipefail && xcodebuild -workspace "$APP".xcworkspace -scheme "$SCHEME" -configuration "$CONFIGURATION" -destination 'generic/platform=iOS' -archivePath ./build/"$APP".xcarchive archive | tee /Users/"$USER"/Library/Logs/gym/"$APP-$SCHEME".log | xcbeautify
```

## Actions

Actions are steps to execute,
usually built-in functions or functions provided by plugins to make it easier to build apps.

- `build_app()` / `gym()` runs `xcodebuild` on [iOS](ios.md)
- `gradle()` is used to build [Android](android.md) apps

List all available actions on command line:

```shell
fastlane actions
```

Get usage details on any step action:

```shell
fastlane action "$action_name"
```

Run an action the command line to test it without adding it to your Fastfile:

```shell
fastlane run notification message:"My Text" title:"The Title"
```

This causes a Desktop pop-up notification.

## Plugins

<https://docs.fastlane.tools/plugins/available-plugins/>

<https://docs.fastlane.tools/plugins/using-plugins/>

<https://docs.fastlane.tools/plugins/plugins-troubleshooting/>

Find a plugin:

```shell
fastlane search_plugins "$query"
```

Add plugin to project:

```shell
fastlane add_plugin "$plugin_name"
```

This adds it to `fastlane/Pluginfile` which is a Gemfile that is referenced from the top level `Gemfile` because
fastlane adds this to the `Gemfile`:

```ruby
plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
```

Install plugin dependencies:

```shell
fastlane install_plugins
```

Update all plugin versions:

```shell
fastlane update_plugins
```

Remove plugin by editing the Pluginfile:

```shell
"$EDITOR" fastlane/Pluginfile
```

and removing line that looks like:

```text
gem "fastlane-plugin-[plugin_name]"
```

## DotEnv Support

Add this line to your `Gemfile`:

```ruby
gem "dotenv"
```

```shell
bundle update
```

```shell
git add Gemfile Gemfile.lock
git commit -m "added dotenv to Gemfile and Gemfile.lock" Gemfile Gemfile.lock
```

Add `.env` to `.gitignore`.

## Code Signing

<https://codesigning.guide/>

### Code Signing on Android

For Android builds using Gradle, add these properties to the `gradle()` action:

```ruby
properties: {
  "android.injected.signing.store.file" => ENV["JKS"],
  "android.injected.signing.store.password" => ENV["JKS_KEYSTORE_PASSWORD"],
  "android.injected.signing.key.alias" => ENV["JKS_KEY_ALIAS"],
  "android.injected.signing.key.password" => ENV["JKS_KEY_PASSWORD"],
  # Optional: Explicitly set signing algorithms (if needed)
  "android.injected.signing.v2.signing.enabled" => "true",
  "android.injected.signing.v1.signing.enabled" => "true"   # not working according to apksigner verification
}
```

Here I am importing the secrets from environment variables, eg.
using an uncommitted `.env` or pulling from a secrets manager using a `.envrc` (see [Direnv](direnv.md)).

For a full example see:

[:octocat: HariSekhon/Templates - fastlane/Fastfile](https://github.com/HariSekhon/Templates/blob/master/fastlane/Fastfile)

## Match

<https://docs.fastlane.tools/actions/match/>

Manages iOS code-signing credentials securely in a Git repo.

Sync your SSL signing certificates and Mobile Provisioning Profiles across devs or CI/CD builds using a separate
Git repo, AWS S3 / GCP GCS bucket.

**You need to have Apple Developer Portal credentials for Fastlane to verify the SSL certs when syncing them**

### Initialize Matchfile config

Initialize a skeleton `fastlane/Matchfile` - run this and answer the prompts:

```shell
fastlane match init
```

`fastlane/Matchfile` looks like this:

```ruby
git_url("git@github.com:OWNER/REPO")

storage_mode("git")

type("development")
```

Commit it:

```shell
git add fastlane/Matchfile &&
git commit -m "added Matchfile" fastlane/Matchfile
```

### Authenticating CI/CD to Matchfiles repo

#### HTTPS Authorization Token

If you specified your repo like this you need to use an HTTPS token:

```text
https://github.com/OWNER/REPO
```

For GitHub, generate one here:

<https://github.com/settings/tokens>

Then base64 encode it:

```shell
base64 <<< "$GITHUB_TOKEN"
```

and export it:

```shell
export MATCH_GIT_BASIC_AUTHORIZATION="<base64_encoded_access_token>"
```

#### SSH Authorization via Deploy Key

Set up your [CI/CD](cicd.md) credentials to use an
[SSH Deploy Key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/managing-deploy-keys)
specifically created for Fastlane to access the Matchfiles git repo.

```shell
ssh-keygen -f ~/.ssh/fastlane-ssh-key
```

Copy `~/.ssh/fastlane-ssh-key.pub` to <https://github.com/OWNER/REPO/settings/keys>.

You can put the path to the SSH key in the environment variable for Fastlane to automatically pick it up:

```shell
export MATCH_GIT_PRIVATE_KEY="$HOME/.ssh/fastlane-ssh-key"
```

Alternatively create a machine account access token and put it in the environment variable:

```shell
export MATCH_PASSWORD="ghp_a12b34cde5fabcdefabcd6efa78bcd9ef0ab"
```

### Populate Matchfiles Repo

Generate a secure password:

```shell
pwgen -s 20 1
```

export it for Match to pick it up:

```shell
export MATCH_PASSWORD="..."
```

Set which branch you want to populate for that environment:

```shell
export MATCH_GIT_BRANCH='dev'
```

#### Generate Public Certificate from .p12

Since I was only given the `.p12` private key without the `.cer` public cert, I regenerated it like this:

```shell
openssl pkcs12 -in "$NAME.p12" -clcerts -nokeys -out /dev/stdout -passin env:CERT_PASSWORD |
sed -n '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/p' > "$NAME.cer"
```

If you get this error:

```text
error:0308010C:digital envelope routines:inner_evp_generic_fetch:unsupported
```

Add the `-legacy` switch to the `openssl` command.

#### Upload SSL cert, p12 and mobileprovision profile to Git branch

This command only takes one mobileprovision profile at a time so you may have to run it multiple times.

This will upload to Git, you may want to override your email address if this is for work:

```shell
export GIT_AUTHOR_EMAIL=hari.sekhon@domain.com
export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
```

It'll prompt you for your `.cer`, then `.p12`, then `.mobileprovision` file:

```shell
fastlane match import \
        --type development \
        --profile "$HOME/Library/MobileDevice/Provisioning Profiles/$NAME.mobileprovision"
```

Upload prod cert with appstore type to differentiate it later (this seems fairly arbitrary):

```shell
export MATCH_GIT_BRANCH='prod'
```

```shell
fastlane match import \
        --type appstore \
        --profile "$HOME/Library/MobileDevice/Provisioning Profiles/$NAME.mobileprovision"
```

#### Import All MobileProfiles

Since the devs dumped a bunch of `*.mobileprovision` profiles on me without a clear naming convention,
I just imported all of them - this will prompt for the `.cer`, then `.p12`, then `.mobileprovision` profile on each
iteration and I can't find non-interactive switches for these so I just used a here doc (EOF) to automate it to be
non-interactive:

```shell
export MATCH_GIT_BRANCH='dev'
```

```shell
NAME=My_Dev_Cert
```

```shell
for mobileprovision_file in ~/Library/MobileDevice/Provisioning\ Profiles/*.mobileprovision; do
    fastlane match import \
        --type development \
        --skip_certificate_matching <<-EOF || break
$NAME.cer
$NAME.p12
$mobileprovision_file
EOF
done
```

```shell
export MATCH_GIT_BRANCH='prod'
```

```shell
NAME=My_Prod_Cert
```

```shell
for mobileprovision_file in ~/Library/MobileDevice/Provisioning\ Profiles/*.mobileprovision; do
    fastlane match import \
        --type appstore \
        --skip_certificate_matching <<-EOF || break
$NAME.cer
$NAME.p12
$mobileprovision_file
EOF
done
```

Don't worry that the command outputs this, these are just the defaults:

```text
+-------------------------------------------------------------------+
|            Detected Values from './fastlane/Matchfile'            |
+--------------+----------------------------------------------------+
| git_url      | git@github.com:OWNER/REPO |
| storage_mode | git                                                |
| type         | development                                        |
+--------------+----------------------------------------------------+
```

The `--type` is still respected and it creates under `certs/distribution/...` and `profiles/appstore/...` in the repo.

### Configure Fastfile to use Match

Add this to your `fastlane/Fastfile` dev lane:

```ruby
ENV['MATCH_GIT_BRANCH'] = 'dev'
#match(type: 'development')
match  # it'll default to development type from Matchfile - it's the branch that's important here
```

Add this to your `fastlane/Fastfile` staging lane:

```ruby
ENV['MATCH_GIT_BRANCH'] = 'staging'
match
```

Add this to your `fastlane/Fastfile` prod lane:

```ruby
ENV['MATCH_GIT_BRANCH'] = 'prod'
match(type: 'appstore')
```

## Tests

### Scan - Run Xcode Tests

<https://docs.fastlane.tools/actions/scan/>

```ruby
desc "Run all the tests"
lane :run_unit_tests do
  scan(
    scheme: "SomeApp",
    clean: true,
    devices: ["iPhone 13 Pro"],
    slack_url:  "https://hooks.slack.com/services/web_hook_id"
  )
end
```

```shell
fastlane run_unit_tests
```

### Android Tests using Gradle

```shell
gradle(task: "test")
```

## Screenshots

<https://docs.fastlane.tools/getting-started/ios/screenshots/>

Automate taking app screenshots for the App Store or Play Store.

Fastlane also helps manage App Store or Play Store metadata.

### iOS Screenshots

<https://docs.fastlane.tools/actions/snapshot/>

### Android Screenshots

<https://docs.fastlane.tools/actions/screengrab/>

## Upload Artifacts

Upload the built `.ipa` or `.apk` artifacts for [iOS](ios.md) or [Android](android.md) respectively.

- iOS: `fastlane pilot` for TestFlight or `fastlane deliver` for App Store Connect
- Android: `fastlane supply` for Google Play Store
- Firebase App Distribution - can store either iOS or Android artifacts

### iOS

#### Upload to Apple TestFlight

<https://docs.fastlane.tools/getting-started/ios/beta-deployment/>

<https://docs.fastlane.tools/actions/upload_to_testflight/>

#### Upload to App Store

<https://docs.fastlane.tools/getting-started/ios/appstore-deployment/>

<https://docs.fastlane.tools/actions/upload_to_app_store/>

### Android

#### Upload to Google Play Store

<https://docs.fastlane.tools/getting-started/android/beta-deployment/>

<https://docs.fastlane.tools/getting-started/android/setup/#setting-up-supply>

<https://docs.fastlane.tools/actions/upload_to_play_store/>

<https://docs.fastlane.tools/getting-started/android/release-deployment/>

Create a Google Service Account:

```shell
gcloud iam service-accounts create fastlane-upload \
    --description="Service account for Fastlane APK upload" \
    --display-name="Fastlane Upload"
```

Create a json credential key:

```shell
gcloud iam service-accounts keys create \
    ~/.gcloud/"fastlane-upload-key-$CLOUDSDK_CORE_PROJECT.json" \
    --iam-account="fastlane-upload@$CLOUDSDK_CORE_PROJECT.iam.gserviceaccount.com"

```

```shell
gcloud projects add-iam-policy-binding "$GOOGLE_PLAY_CLOUDSDK_CORE_PROJECT" \
    --member="serviceAccount:fastlane-upload@$CLOUDSDK_CORE_PROJECT.iam.gserviceaccount.com" \
    --role="roles/viewer"
```

**Go to [Google Play Store](https://play.google.com/console/developers) and assign `Release Manager` to the fastlane-upload service account.**

Validate it has permissions:

```shell
fastlane run validate_play_store_json_key json_key:"$HOME/.gcloud/fastlane-upload-key-$CLOUDSDK_CORE_PROJECT.json"
```

Configure `fastlane/AppFile`:

```text
json_key_file("/path/to/your/fastlane-upload-key.json")
package_name("com.harisekhon.app")
```

Configure `fastlane/Fastfile` to add this to your lane:

```ruby
upload_to_play_store(track: 'beta')
```

See parameters for the `upload_to_play_store()` action:

```shell
fastlane action upload_to_play_store
```

### Firebase App Distribution

Using plugin:

[:octocat: firebase/fastlane-plugin-firebase_app_distribution](https://github.com/firebase/fastlane-plugin-firebase_app_distribution)

<https://firebase.google.com/docs/app-distribution/ios/distribute-fastlane>

```shell
fastlane add_plugin firebase_app_distribution
```

```shell
git add Gemfile Gemfile.lock fastlane/Pluginfile &&
git commit -m "added Fastlane Firebase plugin" Gemfile Gemfile.lock fastlane/Pluginfile
```

Then in your `fastlane/Fastfile` call it inside a lane:

```ruby
release = firebase_app_distribution(
  # for iOS
  app: "1:123456789012:ios:1a2b3cd45e67890fa12b34",

  # for Android
  #app: "1:123456789012:android:1a2b3cd45e67890fa12b34",

  testers: "hari@domain.com",
  release_notes: "Fastlane Dev Release",
  upload_timeout: 900
)

```

## Notifications

Fastlane can send notifications to Slack, email etc for completed builds.

## Generating Lane Documentation

Running fastlane automatically (re)generates `fastlane/README.md` documenting your lanes and their descriptions
taken from the `desc` statement just before the lane definition in `fastlane/Fastfile`.

If you want to just update the `fastlane/README.md` without executing the fastlane actions:

```shell
fastlane docs
```

## Troubleshooting

### Verbose Mode

```text
fastlane "$lane" --verbose
```

## Other Resources

<https://www.kodeco.com/233168-fastlane-tutorial-getting-started>

<https://www.kodeco.com/26869030-fastlane-tutorial-for-android-getting-started>
