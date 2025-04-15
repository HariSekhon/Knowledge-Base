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
  - [Easy SSL & MobileProfile Switching](#easy-ssl--mobileprofile-switching)
- [Tests](#tests)
  - [Scan - Run Xcode Tests](#scan---run-xcode-tests)
  - [Android Tests using Gradle](#android-tests-using-gradle)
- [Screenshots](#screenshots)
  - [iOS Screenshots](#ios-screenshots)
  - [Android Screenshots](#android-screenshots)
- [Upload Artifacts](#upload-artifacts)
  - [iOS - Upload to Apple TestFlight using Pilot action](#ios---upload-to-apple-testflight-using-pilot-action)
  - [Android - Upload to Google Play Store using Supply action](#android---upload-to-google-play-store-using-supply-action)
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

Initialize a skeleton `fastlane/Matchfile`:

```shell
fastlane match init
```

`fastlane/Matchfile` looks like this:

```ruby
git_url("https://github.com/<owner>/<repo>")

storage_mode("git")

type("development")
```

Commit it:

```shell
git add fastlane/Matchfile &&
git commit -m "added Matchfile" fastlane/Matchfile
```

### Easy SSL & MobileProfile Switching

Edit `fastlane/Fastfile` to add a lane to quickly switch between them:

```ruby
desc "Match certificates"
lane :match_certificates do
  match(
    type: "development",
    app_identifier: app_identifier
  )
  match(
    type: "appstore",
    app_identifier: app_identifier
  )
end
```

You can then switch between certificates and mobile profiles:

```shell
fastlane match development
```

```shell
fastlane match appstore
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

### iOS - Upload to Apple TestFlight using Pilot action

<https://docs.fastlane.tools/actions/pilot/>

### Android - Upload to Google Play Store using Supply action

<https://docs.fastlane.tools/getting-started/android/setup/#setting-up-supply>

<https://docs.fastlane.tools/actions/upload_to_play_store/>

<https://docs.fastlane.tools/getting-started/android/release-deployment/>

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
