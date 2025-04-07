# Android

<!-- INDEX_START -->

- [Install Android SDK](#install-android-sdk)
- [Build](#build)
  - [Build with Gradle](#build-with-gradle)
  - [Build with Fastlane](#build-with-fastlane)
- [Signing](#signing)
  - [apksigner](#apksigner)
    - [Signing with apksigner](#signing-with-apksigner)
    - [Verify with apksigner](#verify-with-apksigner)
  - [jarsigner](#jarsigner)
    - [Signing with jarsigner](#signing-with-jarsigner)
    - [Verify with jarsigner](#verify-with-jarsigner)
  - [Fastlane Signing](#fastlane-signing)

<!-- INDEX_END -->

## Install Android SDK

On Ubuntu:

```shell
apt-get install -y android-sdk google-android-build-tools-34.0.0-installer
```

```shell
export ANDROID_HOME="/usr/lib/android-sdk"
```

On Mac, it's easier using [DevOps-Bash-tools](devops-bash-tools.md) to download and install Android SDK
and command line tools:

```shell
install_android_sdk.sh
```

```shell
install_android_commandlinetools.sh
```

Set your shell environment variables:

```shell
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
```

Accept all the licenses so that Gradle builds don't error out:

```shell
yes | sdkmanager --licenses
```

```shell
sdkmanager --list
```

Install build-tools version 34.0.0:

```shell
sdkmanager "build-tools;34.0.0"
```

Add to PATH:

```shell
export PATH="$PATH:$ANDROID_HOME/build-tools/34.0.0"
```

## Build

### Build with Gradle

See [gradle](gradle.md) page.

```shell
./gradlew clean assembleRelease \
        -Dorg.gradle.jvmargs="\
            -Xmx4G \
            -Dkotlin.daemon.jvm.options=-Xmx2G \
            -XX:+HeapDumpOnOutOfMemoryError \
            -XX:+UseParallelGC \
            -Dfile.encoding=UTF-8 \
        " \
        --build-cache \
        --stacktrace \
        --info
```

results in an `.apk` artifact such as:

```text
app/build/outputs/apk/release/app-release.apk
```

### Build with Fastlane

Recommended to use [Fastlane](fastlane.md) which has a gradle action but can also handle signing and other things.

## Signing

### apksigner

#### Signing with apksigner

Newer recommended command.

```shell
apksigner \
    sign \
    --ks "$JKS" \
    --ks-pass  "pass:$JKS_KEYSTORE_PASSWORD" \
    --key-pass "pass:$JKS_KEY_PASSWORD" \
    --ks-key-alias "$JKS_KEY_ALIAS" \
    --v1-signing-enabled true \
    --v2-signing-enabled true \
    --verbose \
    "$APK"
```

#### Verify with apksigner

This actually exits non-zero if it fails to verify, unlike `jarsigner` which only exits non-zero if there is an error.
This makes this the better choice for scripting and [CI/CD](cicd.md).

```shell
apksigner verify --verbose "$APK"
```

```text
Verifies
Verified using v1 scheme (JAR signing): false
Verified using v2 scheme (APK Signature Scheme v2): true
Verified using v3 scheme (APK Signature Scheme v3): true
Verified using v3.1 scheme (APK Signature Scheme v3.1): false
Verified using v4 scheme (APK Signature Scheme v4): false
Verified for SourceStamp: false
Number of signers: 1
```

Fails to verify is signed with the older jarsigner:

```text
DOES NOT VERIFY
ERROR: Target SDK version 34 requires a minimum of signature scheme v2; the APK is not signed with this or a later signature scheme
```

### jarsigner

#### Signing with jarsigner

Older method, if you sign with `jarsigner`, you won't be able to verify with `apksigner` in your [CI/CD](cicd.md)
pipelines.

```shell
jarsigner \
    -keystore "$JKS" \
    -storepass "$JKS_KEYSTORE_PASSWORD" \
    -keypass "$JKS_KEY_PASSWORD" \
    -sigalg SHA256withRSA \
    -digestalg SHA-256 \
    -verbose \
    "$APK" \
    "$JKS_KEY_ALIAS"
```

#### Verify with jarsigner

Does not exit non-zero if jar is unsigned and fails to verify.

It only exits non-zero if there is an error.

Use newer `apksigner` command instead.

```shell
jarsigner -verify "$$APK"
```

```text
jar verified.
```

or:

```text
  s = signature was verified
  m = entry is listed in manifest
  k = at least one certificate was found in keystore

no manifest.

jar is unsigned.
```

### Fastlane Signing

[Fastlane](fastlane.md) can also do the signing, see this
[fastlane/Fastfile](https://github.com/HariSekhon/Templates/blob/master/fastlane/Fastfile) template.

Ensure the following environment variables are set:

- `JKS`
- `JKS_KEYSTORE_PASSWORD`
- `JKS_KEY_ALIAS`
- `JKS_KEY_PASSWORD`

and then set the following `properties` in the `gradle`
action in the `fastlane/Fastfile`:

```groovy
    gradle(
      # don't waste the cache with a clean, 1min30sec => 5min30sec
      #task: 'clean bundleRelease',
      task: "assembleRelease",
      flags: "-Dorg.gradle.jvmargs=\"-Xmx4G -Dkotlin.daemon.jvm.options=-Xmx2G -XX:+HeapDumpOnOutOfMemoryError -XX:+UseParallelGC -Dfile.encoding=UTF-8\" --build-cache --no-daemon --stacktrace --info",
      properties: {
        "android.injected.signing.store.file" => ENV["JKS"],
        "android.injected.signing.store.password" => ENV["JKS_KEYSTORE_PASSWORD"],
        "android.injected.signing.key.alias" => ENV["JKS_KEY_ALIAS"],
        "android.injected.signing.key.password" => ENV["JKS_KEY_PASSWORD"],
        "android.injected.signing.v2.signing.enabled" => "true",
        "android.injected.signing.v1.signing.enabled" => "true"
      }
```

<!--
Fastlane seems to use apksigner under the hood, does not seem to verify with `jarsigner`.
-->
