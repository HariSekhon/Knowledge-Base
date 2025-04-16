# iXGuard

<https://www.guardsquare.com/ixguard>

Proprietary mobile iOS code obfuscation tool to make it difficult to disassemble your `.ipa`.

This protects against intellectual property theft and credential harvesting of things like API keys that may be embedded
in applications.

<!-- INDEX_START -->

- [Install](#install)
- [Documentation](#documentation)
- [Usage](#usage)
  - [Sample Config](#sample-config)
  - [Build IPA with BitCode](#build-ipa-with-bitcode)
  - [Optional: Check BitCode is present](#optional-check-bitcode-is-present)
    - [Check xcarchive was generated with BitCode](#check-xcarchive-was-generated-with-bitcode)
    - [Check IPA was generated with BitCode](#check-ipa-was-generated-with-bitcode)
  - [Run iXGuard to generate new Hardened Code](#run-ixguard-to-generate-new-hardened-code)
    - [Run iXGuard to generate Hardened xcarchive](#run-ixguard-to-generate-hardened-xcarchive)
    - [Run iXGuard to generate Hardened IPA](#run-ixguard-to-generate-hardened-ipa)
- [Log & Stats](#log--stats)
  - [iXGuard Log](#ixguard-log)
  - [iXGuard Stats](#ixguard-stats)
  - [Fastlane Stats](#fastlane-stats)
- [Check](#check)
- [CI/CD Install](#cicd-install)

<!-- INDEX_END -->

## Install

Get the installer from iXGuard and then run the `.pkg` to install to the `/` root filesystem:

```shell
sudo installer -pkg "iXGuard_4_12_4_stable_arm_64.pkg" -target /
```

## Documentation

Unfortunately the documentation is not public but installed
and loaded locally using a local python webapp when you install the iXguard.pkg.

The installer runs this command in the foreground in a new terminal:

```shell
ixguard-docs
```

This is just a shell script `/Library/iXGuard/scripts/ixguard-docs` that calls:

```shell
#!/usr/bin/env sh
SCRIPT_PATH=`readlink -f "${BASH_SOURCE:-$0}"`
SCRIPT_DIR=`dirname $SCRIPT_PATH`
xcrun python3 $SCRIPT_DIR/../python/server.py &> /dev/null
```

This is equivalent to this, because `server.py` does not have a shebang header line:

```shell
python3 /Library/iXGuard/python/server.py
```

Then you can open the docs at this link (should open automatically in default browser):

<http://127.0.0.1:8998/index.html>

This self-hosted doc site is made using [MKDocs Material](mkdocs.md#material) theme.

## Usage

### Sample Config

[HariSekhon/Templates - ixguard.yaml](https://github.com/HariSekhon/Templates/blob/master/ixguard.yaml):

```yaml
license:
  - "./ixguard-license.txt"
debug:
  verbosity: info
  autoconfigure: false
protection:
  enabled: true
  names:
    enabled: false
  arithmetic-operations:
    enabled: true
  control-flow:
    enabled: true
  data:
    enabled: true
  code-integrity:
    enabled: false
  environment-integrity:
    enabled: false
  resources:
    enabled: false
export:
  embed-bitcode: false
```

### Build IPA with BitCode

This is neccessary to build an IPA with both bitcode and machine code that iXGuard can later run on.

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

If you get this error message, it's caused by

```shell
xcodebuild -exportArchive
```

breaks with:

```text
error: exportArchive: Rsync failed
```

Then you need to skip creating the archive and instead run ixguard on the `.xcarchive` instead.

```shell
ixguard --config ixguard.yaml --local --force -o ./build/MyApp-Guarded.xcarchive  ./build/MyApp.xcarchive
```

And then run the `xcodebuild -exportArchive` afterwards.

### Optional: Check BitCode is present

#### Check xcarchive was generated with BitCode

```shell
NAME=MyApp
```

```shell
otool -l "$NAME.xcarchive//Products/Applications/$NAME.app/$NAME" | grep -A2 __LLVM
```

or

#### Check IPA was generated with BitCode

```shell
NAME=MyApp
```

```shell
unzip "$NAME.ipa"
```

```shell
otool -l "Payload/$NAME.app/$NAME" | grep -A2 __LLVM
```

If the output shows a `__LLVM` section, like this, then bitcode is included:

```text
sectname __LLVM
segname  __TEXT
```

The IPA file size will also be larger than it would otherwise.

### Run iXGuard to generate new Hardened Code

#### Run iXGuard to generate Hardened xcarchive

```shell
NAME=MyApp
```

```shell
ixguard --config ixguard.yaml --local --force -o "./build/$NAME-Guarded.xcarchive"  "./build/$NAME.xcarchive"
```

And then run the `xcodebuild -exportArchive` afterwards.

See the [Fastlane](fastlane.md) template.

or

#### Run iXGuard to generate Hardened IPA

```shell
IPA="MyApp.ipa"
```

Create a variable name for the new output IPA to be the same as the original except with `-hardened.ipa` suffix, eg.
-> `MyApp-hardened.ipa`:

```shell
HARDENED_IPA="${IPA_PATH%.ipa}-hardened.ipa"
```

Run `ixguard` on the `.ipa` archive to generate a new hardened ipa:

```shell
ixguard --config "$IXGUARD_CONFIG" --local -o "$HARDENED_IPA" "$IPA_PATH"
```

This takes several minutes to run and generates `MyApp-hardened.ipa`.

The `--local` switch skips checking for updates and prevents the build breaking with this error if your wifi is down:

```text
Generating usage statistics failed: Network error.
Failed to check for updates due to a network issue. Use the -local flag to run ixguard without checking for updates.
```

## Log & Stats

### iXGuard Log

An `ixguard.log` file will be created at the root of the git repo containing logs and a statistics block like this:

### iXGuard Stats

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

### Fastlane Stats

iXGuard will more than double your build time:

```text
[01:36:09]: 🎉 Built with ixGuard toolchain and exported hardened IPA successfully!

+------------------------------------------------------------------------------------+
|                                  fastlane summary                                  |
+------+---------------------------------------------------------------+-------------+
| Step | Action                                                        | Time (in s) |
+------+---------------------------------------------------------------+-------------+
| 1    | opt_out_usage                                                 | 0           |
| 2    | default_platform                                              | 0           |
| 3    | setup_ci                                                      | 0           |
| 4    | get_build_number                                              | 0           |
| 5    | git_branch                                                    | 0           |
| 6    | last_git_tag                                                  | 0           |
| 7    | ensure_git_branch                                             | 0           |
| 8    | build_app                                                     | 546         |
| 9    | cd .. && ixguard --config ixguard.yaml --local --force -o "./ | 725         |
| 10   | build_app                                                     | 75          |
+------+---------------------------------------------------------------+-------------+

[01:36:09]: fastlane.tools just saved you 22 minutes! 🎉
```

## Check

Check your resulting `.ipa` using [Mac Binary Debugging](binaries-debugging.md#mac) tools like:

[:octocat: gdbinit/MachOView](https://github.com/gdbinit/MachOView)

## CI/CD Install

<https://www.guardsquare.com/blog/continuously-protecting-your-ios-project-in-a-cloud-based-ci>

```shell
curl https://downloads.guardsquare.com/cli/latest_macos_amd64 -sL |
tar -x &&
sudo mv -i guardsquare /usr/local/bin/
```

You need an SSH key which has been uploaded to the iXGuard portal to authenticate this download:

```shell
guardsquare --ssh-agent download ixguard -o ixguard.pkg
```

```shell
sudo installer -pkg ixguard.pkg
```

Then put your license file and `ixguard.yml` config to your CI/CD, the former via secret injection,
the latter can be committed to [Git](git.md).
