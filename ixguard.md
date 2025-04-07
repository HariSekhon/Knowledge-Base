# iXGuard

<https://www.guardsquare.com/ixguard>

Proprietary mobile iOS code obfuscation tool to make it difficult to disassemble your `.ipa`.

<!-- INDEX_START -->

- [Install](#install)
- [Documentation](#documentation)
- [Building using iXGuard](#building-using-ixguard)
- [Log & Stats](#log--stats)

<!-- INDEX_END -->

## Install

Get the installer from iXGuard and then run the `.pkg` to install to the `/` root filesystem:

```shell
sudo installer -pkg "iXGuard_4_12_4_stable_arm_64.pkg" -target /
```

## Documentation

Unfortunately the documentation is not public but installed
and loaded locally using a local python webapp when you install the iXguard.pkg:

<http://127.0.0.1:8998/index.html>

## Building using iXGuard

You can activate it with the `-toolchain com.guardsquare.ixguard` argument to `xcodebuild`, eg:

```shell
xcodebuild archive \
           -workspace "$APP".xcworkspace \
           -scheme SIT \
           -configuration SIT \
           -archivePath "$ARCHIVE_PATH" \
           -toolchain com.guardsquare.ixguard \
           -quiet
```

or just set this environment variable before running `xcodebuild` or [Fastlane](fastlane.md):

```shell
export TOOLCHAINS="com.guardsquare.ixguard"
```

## Log & Stats

An `ixguard.log` file will be created at the root of the git repo containing logs and a statistics block like this:

```shell
STATISTICS:
-----------

Name Obfuscation:
-----------------
  - Symbols hidden: 36228
  - Symbols obfuscated: 116398
  - Entities renamed: 16226
  - Entities skipped because they are part of the SDK: 565571
  - Entities skipped because of blacklist: 11410
  - Entities skipped because they were used in reflection: 12

Arithmetic Obfuscation:
-----------------------
  - Functions skipped because they were not whitelisted: 37888

Control Flow Obfuscation:
-------------------------
  - Dlsymified calls to this function: 0
  - Skipped due to not linked: 6
  - Skipped due to not being externally linked: 36680
  - Functions not obfuscated because they were not whitelisted: 31327
  - Function locations reordered: 38044
  - Global locations reordered: 177554

Integrity:
----------

Asset Encryption:
-----------------
  - Resources skipped because they were not whitelisted: 896
```
