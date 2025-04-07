
## Android

### Install Android SDK

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
