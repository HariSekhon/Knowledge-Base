# iOS

Uses `xcodebuild`:

<https://developer.apple.com/documentation/xcode>

<!-- INDEX_START -->

- [Dependencies - CocoaPods](#dependencies---cocoapods)
- [Metadata](#metadata)
  - [Clean](#clean)
- [Build Destinations and Simulators](#build-destinations-and-simulators)
- [Download Simulators](#download-simulators)
  - [Downloading using XCode CLI](#downloading-using-xcode-cli)
  - [Download All Platforms](#download-all-platforms)
  - [Download iOS](#download-ios)
  - [Download watchOS](#download-watchos)
  - [Download tvOS](#download-tvos)
  - [Download visionOS](#download-visionos)
  - [Download using XCode GUI](#download-using-xcode-gui)
  - [Download using xcode-install](#download-using-xcode-install)
- [Copy Profiles to Library](#copy-profiles-to-library)
- [Load Certificate into Keychain](#load-certificate-into-keychain)
- [Open KeyChain Access](#open-keychain-access)
- [Build](#build)
- [xcpretty](#xcpretty)
- [xcbeautify](#xcbeautify)
- [AGV](#agv)
- [iXGuard](#ixguard)
- [Switching XCode versions](#switching-xcode-versions)
- [Download Alternate XCode Versions](#download-alternate-xcode-versions)
  - [XCodes](#xcodes)
- [Apple 2FA](#apple-2fa)
  - [2FA - Device Base](#2fa---device-base)
  - [2FA - Security & Control](#2fa---security--control)
  - [2FA - Fallback - SMS or Phone Call](#2fa---fallback---sms-or-phone-call)
- [Troubleshooting](#troubleshooting)
  - [security: SecKeychainItemImport: Unknown format in import](#security-seckeychainitemimport-unknown-format-in-import)
  - [security: SecItemCopyMatching: The specified item could not be found in the keychain](#security-secitemcopymatching-the-specified-item-could-not-be-found-in-the-keychain)
  - [XCodeBuild / Fastlane building hanging with no output](#xcodebuild--fastlane-building-hanging-with-no-output)
  - [No Runtimes](#no-runtimes)

<!-- INDEX_END -->

## Dependencies - CocoaPods

<https://cocoapods.org/>

<https://guides.cocoapods.org/>

CocoaPods is a dependency manager for Swift and Objective-C Cocoa projects.

It's written in [Ruby](ruby.md) and can be installed using the system ruby.

Install cocoapods:

```shell
sudo gem install cocoapods
```

Install project's pod dependencies:

```shell
pod install
```

This uses a `Podfile` build file that looks like this:

```ruby
platform :ios, '8.0'
use_frameworks!

target 'MyApp' do
  pod 'AFNetworking', '~> 2.6'
  pod 'ORStackView', '~> 3.0'
  pod 'SwiftyJSON', '~> 2.3'
end
```

Creating a Pod:

```shell
pod spec create "$APP"
```

Edit the podspec file:

```shell
"$EDITOR" "$APP".podspec
```

Lint the podspec file:

```shell
pod spec lint "$APP".podspec
```

Reinstall dependencies:

```shell
pod deintegrate &&
pod install
```

## Metadata

Metadata is found in:

```text
<AppName>.xcodeproj/
```

and

```text
<AppName>.xcworkspace
```

You can open XCode like this:

```shell
open "$APP".xcodeproj
```

```shell
open "$APP".xcworkspace
```

### Clean

```shell
xcodebuild clean
```

```shell
xcodebuild -workspace "$APP".xcworkspace \
           -scheme SIT \
           -configuration SIT \
           clean
```

Install the Platform SDK first, otherwise you'll get an error like this:

```text
Command line invocation:
    /Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild -workspace MyApp.xcworkspace -scheme SIT -configuration SIT clean

User defaults from command line:
    IDEPackageSupportUseBuiltinSCM = YES

2025-01-30 14:18:57.750 xcodebuild[47478:154973817] Writing error result bundle to /var/folders/30/kxjrq3fj5tqdhsvbj3p9m2fh0000gq/T/ResultBundle_2025-30-01_14-18-0057.xcresult
xcodebuild: error: Found no destinations for the scheme 'SIT' and action clean.
```

Running this:

```shell
xcodebuild -workspace "$APP".xcworkspace \
           -scheme SIT \
           -configuration SIT \
           clean
```

Output should look something like this:

```text
Command line invocation:
    /Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild -workspace MyApp.xcworkspace -scheme SIT -configuration SIT clean

User defaults from command line:
    IDEPackageSupportUseBuiltinSCM = YES

--- xcodebuild: WARNING: Using the first of multiple matching destinations:
{ platform:iOS, id:dvtdevice-DVTiPhonePlaceholder-iphoneos:placeholder, name:Any iOS Device }
{ platform:iOS Simulator, id:dvtdevice-DVTiOSDeviceSimulatorPlaceholder-iphonesimulator:placeholder, name:Any iOS Simulator Device }
{ platform:iOS Simulator, id:FAF9573D-6EFF-4F38-A5D6-E0613D8AD15F, OS:17.5, name:iPad (10th generation) }
{ platform:iOS Simulator, id:FAF9573D-6EFF-4F38-A5D6-E0613D8AD15F, OS:17.5, name:iPad (10th generation) }
{ platform:iOS Simulator, id:D9DEB37D-DB2A-4C70-B12F-758FB2DDEF28, OS:17.5, name:iPad Air 11-inch (M2) }
{ platform:iOS Simulator, id:D9DEB37D-DB2A-4C70-B12F-758FB2DDEF28, OS:17.5, name:iPad Air 11-inch (M2) }
{ platform:iOS Simulator, id:3B3701D6-8908-4C5B-AE9D-28065AAB3361, OS:17.5, name:iPad Air 13-inch (M2) }
{ platform:iOS Simulator, id:3B3701D6-8908-4C5B-AE9D-28065AAB3361, OS:17.5, name:iPad Air 13-inch (M2) }
{ platform:iOS Simulator, id:4AA9C940-8B08-497A-8873-91913B1D8A26, OS:17.5, name:iPad Pro 11-inch (M4) }
{ platform:iOS Simulator, id:4AA9C940-8B08-497A-8873-91913B1D8A26, OS:17.5, name:iPad Pro 11-inch (M4) }
{ platform:iOS Simulator, id:59DA5271-F055-44DA-9266-C545D4308195, OS:17.5, name:iPad Pro 13-inch (M4) }
{ platform:iOS Simulator, id:59DA5271-F055-44DA-9266-C545D4308195, OS:17.5, name:iPad Pro 13-inch (M4) }
{ platform:iOS Simulator, id:5507F622-1A42-4914-AF9A-AA644851A559, OS:17.5, name:iPad mini (6th generation) }
{ platform:iOS Simulator, id:5507F622-1A42-4914-AF9A-AA644851A559, OS:17.5, name:iPad mini (6th generation) }
{ platform:iOS Simulator, id:8359DDF7-572A-4AEA-99B4-689EF151872A, OS:17.5, name:iPhone 15 }
{ platform:iOS Simulator, id:8359DDF7-572A-4AEA-99B4-689EF151872A, OS:17.5, name:iPhone 15 }
{ platform:iOS Simulator, id:10BEF2E3-FEBD-49AD-8A6F-E4F4C559EBF4, OS:17.5, name:iPhone 15 Plus }
{ platform:iOS Simulator, id:10BEF2E3-FEBD-49AD-8A6F-E4F4C559EBF4, OS:17.5, name:iPhone 15 Plus }
{ platform:iOS Simulator, id:2E91DE33-0CAD-4189-BE35-C00ABBA69E19, OS:17.5, name:iPhone 15 Pro }
{ platform:iOS Simulator, id:2E91DE33-0CAD-4189-BE35-C00ABBA69E19, OS:17.5, name:iPhone 15 Pro }
{ platform:iOS Simulator, id:41104926-C610-474A-9846-5C840E36CE82, OS:17.5, name:iPhone 15 Pro Max }
{ platform:iOS Simulator, id:41104926-C610-474A-9846-5C840E36CE82, OS:17.5, name:iPhone 15 Pro Max }
{ platform:iOS Simulator, id:C4EE5DBE-6048-4BCC-BDEA-8EE7E8C400C6, OS:17.5, name:iPhone SE (3rd generation) }
{ platform:iOS Simulator, id:C4EE5DBE-6048-4BCC-BDEA-8EE7E8C400C6, OS:17.5, name:iPhone SE (3rd generation) }

** CLEAN SUCCEEDED **
```

## Build Destinations and Simulators

```shell
xcodebuild \
    -workspace "$APP".xcworkspace \
    -scheme SIT \
    -configuration SIT \
    -showdestinations
```

If you see this output, you have no available destinations:

```text
Command line invocation:
/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild -workspace MyApp.xcworkspace -scheme SIT -configuration SIT -showdestinations

User defaults from command line:
IDEPackageSupportUseBuiltinSCM = YES

        Ineligible destinations for the "SIT" scheme:
                { platform:iOS, id:dvtdevice-DVTiPhonePlaceholder-iphoneos:placeholder, name:Any iOS Device, error:iOS 17.5 is not installed. To use with Xcode, first download and install the platform }
```

```shell
xcodebuild -workspace MyApp.xcworkspace   -scheme SIT   -configuration SIT   -showdestinations
Command line invocation:
    /Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild -workspace MyApp.xcworkspace -scheme SIT -configuration SIT -showdestinations

User defaults from command line:
    IDEPackageSupportUseBuiltinSCM = YES



        Available destinations for the "SIT" scheme:
                { platform:iOS, id:dvtdevice-DVTiPhonePlaceholder-iphoneos:placeholder, name:Any iOS Device }
                { platform:iOS Simulator, id:dvtdevice-DVTiOSDeviceSimulatorPlaceholder-iphonesimulator:placeholder, name:Any iOS Simulator Device }
                { platform:iOS Simulator, id:FAF9573D-6EFF-4F38-A5D6-E0613D8AD15F, OS:17.5, name:iPad (10th generation) }
                { platform:iOS Simulator, id:D9DEB37D-DB2A-4C70-B12F-758FB2DDEF28, OS:17.5, name:iPad Air 11-inch (M2) }
                { platform:iOS Simulator, id:3B3701D6-8908-4C5B-AE9D-28065AAB3361, OS:17.5, name:iPad Air 13-inch (M2) }
                { platform:iOS Simulator, id:4AA9C940-8B08-497A-8873-91913B1D8A26, OS:17.5, name:iPad Pro 11-inch (M4) }
                { platform:iOS Simulator, id:59DA5271-F055-44DA-9266-C545D4308195, OS:17.5, name:iPad Pro 13-inch (M4) }
                { platform:iOS Simulator, id:5507F622-1A42-4914-AF9A-AA644851A559, OS:17.5, name:iPad mini (6th generation) }
                { platform:iOS Simulator, id:8359DDF7-572A-4AEA-99B4-689EF151872A, OS:17.5, name:iPhone 15 }
                { platform:iOS Simulator, id:10BEF2E3-FEBD-49AD-8A6F-E4F4C559EBF4, OS:17.5, name:iPhone 15 Plus }
                { platform:iOS Simulator, id:2E91DE33-0CAD-4189-BE35-C00ABBA69E19, OS:17.5, name:iPhone 15 Pro }
                { platform:iOS Simulator, id:41104926-C610-474A-9846-5C840E36CE82, OS:17.5, name:iPhone 15 Pro Max }
                { platform:iOS Simulator, id:C4EE5DBE-6048-4BCC-BDEA-8EE7E8C400C6, OS:17.5, name:iPhone SE (3rd generation) }
```

See available simulators:

```shell
xcrun simctl list
```

See available runtimes:

```shell
xcrun simctl list runtimes
```

```text
== Runtimes ==
iOS 17.5 (17.5 - 21F79) - com.apple.CoreSimulator.SimRuntime.iOS-17-5
tvOS 17.5 (17.5 - 21L569) - com.apple.CoreSimulator.SimRuntime.tvOS-17-5
watchOS 10.5 (10.5 - 21T575) - com.apple.CoreSimulator.SimRuntime.watchOS-10-5
visionOS 1.2 (1.2 - 21O5565d) - com.apple.CoreSimulator.SimRuntime.xrOS-1-2
```

Boot one if necessary:

```shell
xcrun simctl boot "iPhone 14"
```

```shell
xcrun simctl erase all
```

Delete derived data:

```shell
rm -rf ~/Library/Developer/Xcode/DerivedData
```

or

```shell
xcodebuild -workspace "$APP".xcworkspace \
  -scheme SIT \
  -configuration SIT \
  -destination 'platform=iOS,name=iPhone 14,OS=16.4' \
  clean
```

Output should look like:

```text
xcodebuild -workspace MyApp.xcworkspace   -scheme SIT   -configuration SIT   -showdestinations
Command line invocation:
    /Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild -workspace MyApp.xcworkspace -scheme SIT -configuration SIT -showdestinations

User defaults from command line:
    IDEPackageSupportUseBuiltinSCM = YES



        Available destinations for the "SIT" scheme:
                { platform:iOS, id:dvtdevice-DVTiPhonePlaceholder-iphoneos:placeholder, name:Any iOS Device }
                { platform:iOS Simulator, id:dvtdevice-DVTiOSDeviceSimulatorPlaceholder-iphonesimulator:placeholder, name:Any iOS Simulator Device }
                { platform:iOS Simulator, id:FAF9573D-6EFF-4F38-A5D6-E0613D8AD15F, OS:17.5, name:iPad (10th generation) }
                { platform:iOS Simulator, id:D9DEB37D-DB2A-4C70-B12F-758FB2DDEF28, OS:17.5, name:iPad Air 11-inch (M2) }
                { platform:iOS Simulator, id:3B3701D6-8908-4C5B-AE9D-28065AAB3361, OS:17.5, name:iPad Air 13-inch (M2) }
                { platform:iOS Simulator, id:4AA9C940-8B08-497A-8873-91913B1D8A26, OS:17.5, name:iPad Pro 11-inch (M4) }
                { platform:iOS Simulator, id:59DA5271-F055-44DA-9266-C545D4308195, OS:17.5, name:iPad Pro 13-inch (M4) }
                { platform:iOS Simulator, id:5507F622-1A42-4914-AF9A-AA644851A559, OS:17.5, name:iPad mini (6th generation) }
                { platform:iOS Simulator, id:8359DDF7-572A-4AEA-99B4-689EF151872A, OS:17.5, name:iPhone 15 }
                { platform:iOS Simulator, id:10BEF2E3-FEBD-49AD-8A6F-E4F4C559EBF4, OS:17.5, name:iPhone 15 Plus }
                { platform:iOS Simulator, id:2E91DE33-0CAD-4189-BE35-C00ABBA69E19, OS:17.5, name:iPhone 15 Pro }
                { platform:iOS Simulator, id:41104926-C610-474A-9846-5C840E36CE82, OS:17.5, name:iPhone 15 Pro Max }
                { platform:iOS Simulator, id:C4EE5DBE-6048-4BCC-BDEA-8EE7E8C400C6, OS:17.5, name:iPhone SE (3rd generation) }
```

## Download Simulators

### Downloading using XCode CLI

```shell
xcodebuild -showsdks
```

Requires newer versions of Xcode and also admin privileges - for CI/CD prefix these download commands with `sudo`.

### Download All Platforms

If in doubt, just download everything:

```shell
xcodebuild -downloadAllPlatforms
```

The output is the same as below individual platform download commands.

### Download iOS

```shell
xcodebuild -downloadPlatform iOS
```

```text
Downloading iOS 17.5 Simulator (21F79): 7.5% (551.5 MB of 7.34 GB)
```

Verify after download:

```shell
xcrun simctl list runtimes
```

Should return something like this (instead of being blank like before):

```text
== Runtimes ==
iOS 17.5 (17.5 - 21F79) - com.apple.CoreSimulator.SimRuntime.iOS-17-5
```

If it's still empty, try to clear state and re-run the download command again:

```shell
sudo rm -rf /Library/Developer/Xcode
sudo rm -rf ~/Library/Developer/Xcode
sudo rm -rf ~/Library/Caches/com.apple.dt.Xcode
```

### Download watchOS

```shell
xcodebuild -downloadPlatform watchOS
```

```text
Downloading watchOS 10.5 Simulator (21T575): 10.9% (428.7 MB of 3.95 GB)
```

```shell
xcrun simctl list runtimes
```

```text
== Runtimes ==
iOS 17.5 (17.5 - 21F79) - com.apple.CoreSimulator.SimRuntime.iOS-17-5
watchOS 10.5 (10.5 - 21T575) - com.apple.CoreSimulator.SimRuntime.watchOS-10-5
```

### Download tvOS

```shell
xcodebuild -downloadPlatform tvOS
```

```shell
xcrun simctl list runtimes
```

```text
== Runtimes ==
iOS 17.5 (17.5 - 21F79) - com.apple.CoreSimulator.SimRuntime.iOS-17-5
tvOS 17.5 (17.5 - 21L569) - com.apple.CoreSimulator.SimRuntime.tvOS-17-5
watchOS 10.5 (10.5 - 21T575) - com.apple.CoreSimulator.SimRuntime.watchOS-10-5
```

### Download visionOS

```shell
xcodebuild -downloadPlatform visionOS
```

```shell
xcrun simctl list runtimes
```

```text
== Runtimes ==
iOS 17.5 (17.5 - 21F79) - com.apple.CoreSimulator.SimRuntime.iOS-17-5
tvOS 17.5 (17.5 - 21L569) - com.apple.CoreSimulator.SimRuntime.tvOS-17-5
watchOS 10.5 (10.5 - 21T575) - com.apple.CoreSimulator.SimRuntime.watchOS-10-5
visionOS 1.2 (1.2 - 21O5565d) - com.apple.CoreSimulator.SimRuntime.xrOS-1-2```
```

### Download using XCode GUI

```shell
open -a Xcode
```

Navigate to Xcode > Settings > Platforms (or Preferences > Components).
Look for iOS 17.5 Simulator and install it.

### Download using xcode-install

[:octocat: neonichu/xcode-install](https://github.com/neonichu/xcode-install)

This 3rd party is another alternative way to install XCode SDKs from the command line,
but it requires Apple Developer credentials.

```shell
sudo gem install xcode-install
```

Prompts for an Apple Developer account username and password (set the `$FASTLANE_PASSWORD` environment variable).
This costs $79 per year at time of writing.

```shell
export XCODE_INSTALL_USER=...
```

```shell
export XCODE_INSTALL_PASSWORD=...
```

```shell
xcversion update
```

```shell
xcversion list
```

```shell
xcversion install 'Xcode 15.0' # Adjust version if needed
```

```shell
xcversion simulators
```

```shell
xcversion install-simulator "iOS 17.5"
```

```shell
xcrun simctl create "iPhone 14 (iOS 17.5)" com.apple.CoreSimulator.SimDeviceType.iPhone-14 com.apple.CoreSimulator.SimRuntime.iOS-17-5
```

```shell
xcrun simctl boot "iPhone 14 (iOS 17.5)"
```

Verify installation:

```shell
xcrun simctl list
```

## Copy Profiles to Library

```shell
mkdir -p -v ~/Library/MobileDevice/Provisioning\ Profiles

cp -vi *.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/
```

## Load Certificate into Keychain

```shell
security list-keychains
```

Build will find it there later.

```text
CERT=Certificates-SIT.p12
```

Import certificate and allow codesign and security to read it:

```shell
security import "$CERT" \
    -k ~/Library/Keychains/login.keychain-db \
    -P "$CERT_PASSWORD" \
    -T /usr/bin/codesign \
    -T /usr/bin/security
```

## Open KeyChain Access

On your Mac laptop you may need to open keychain access if it's password protected.

In testing this didn't accept my login password, but if I opened it manually first:

```shell
open -a "Keychain Access"
```

then the build proceeded using the already opened keychain.

The [Fastlane](fastlane.md) handling of this is better where is creates a new keychain that isn't password protected.

## Build

Make sure you've got XCode set to Developer tools and not just CLI tools or you'll get
[this error](mac.md#xcodebuild-error-complaining-xcode-only-has-command-line-tools).

```shell
sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
```

Build:

```shell
xcodebuild -workspace "$APP".xcworkspace \
           -scheme SIT \
           -configuration SIT
```

If you get this error:

```text
xcodebuild: error: Failed to build workspace MyApp with scheme SIT.: This scheme builds an embedded Apple Watch app. watchOS 10.5 must be installed in order to run the scheme
```

```shell
xcodebuild -downloadPlatform watchOS
```

Print the build settings:

```shell
xcodebuild -showBuildSettings # optionally put your -workspace -scheme -configuration switches ...
```

and destinations:

```shell
xcodebuild -workspace MyApp.xcworkspace \
  -scheme SIT \
  -configuration SIT \
  -showdestinations
```

Build against a specific destination:

```shell
xcodebuild clean build -project "$APP".xcodeproj \
                       -scheme SIT \
                       -destination 'platform=iOS Simulator,name=iPhone 15'
```

Run tests:

```shell
xcodebuild test -project "$APP".xcodeproj \
                -scheme YourScheme \
                -destination 'platform=iOS Simulator,name=iPhone 15'
```

## xcpretty

[:octocat: xcpretty/xcpretty](https://github.com/xcpretty/xcpretty)

Pipe `xcodebuild` output into it to make it prettier for human readability.

Used by [Fastlane](fastlane.md).

## xcbeautify

[:octocat: cpisciotta/xcbeautify](https://github.com/cpisciotta/xcbeautify)

Faster alternative to xcpretty written in Swift, recommended and used preferentially
by [Fastlane](fastlane.md).

## AGV

Apple Generic Versioning (AGV) tool for Xcode projects:

```shell
agvtool vers  # -terse
```

## iXGuard

See [iXGuard](ixguard.md) page.

## Switching XCode versions

See [GitHub Actions - Mac Runner Versions vs XCode Versions](github-actions.md#mac-runner-versions-vs-xcode-versions).

## Download Alternate XCode Versions

### XCodes

[:octocat: XcodesOrg/xcodes](https://github.com/XcodesOrg/xcodes)

```shell
brew install xcodesorg/made/xcodes
```

List all possible XCode versions available:

```shell
xcodes list
```

List XCode versions installed:

```shell
xcodes installed
```

```text
15.4 (15F31d) (Selected) /Applications/Xcode.app
```

Download and switch to 16.1:

```shell
xcodes install 16.1
```

Just download the `.xip` package (eg. to upload to [CI/CD](cicd.md) artifacts):

```shell
xcodes download 16.1
```

This requires a iCloud account.

```shell
export XCODES_USERNAME=...
export XCODES_PASSWORD=...
```

And be prepared for the 2FA prompt if enabled on the account.

## Apple 2FA

Unfortunately Apple doesn't support authenticator apps which can be used to share QR seeds.

Why doesn't Apple support Authenticator Apps for iCloud 2FA?

### 2FA - Device Base

Apple’s 2FA is device-based,
not time-based one-time passwords (TOTP) using number seeds usually shared as a QR code to authenticator apps.

Apple’s 2FA uses trusted Apple devices to receive push notifications or generate verification codes.
Apple’s 2FA uses secure push notifications.

When signing in, Apple sends a real-time notification to trusted devices.
These notifications display location-based alerts, helping prevent unauthorized access.

### 2FA - Security & Control

Apple controls the authentication flow entirely within its ecosystem to reduce phishing risks.
Since TOTP codes can be stolen via phishing, Apple prefers to use its push-based system.

### 2FA - Fallback - SMS or Phone Call

If you don’t have a trusted Apple device, Apple provides an alternative via SMS or phone call, rather than using
third-party apps.

If you have [Mac](mac.md) you can generate a 2FA code via the CLI:

```shell
security find-generic-password -s "iCloud" -w
```

Since this is such a big problem, switched to using a [GitHub-Actions](github-actions.md) runner with the XCode versions
already installed.

See [GitHub Actions - Mac Runner Versions vs XCode versions](github-actions.md#mac-runner-versions-vs-xcode-versions).

## Troubleshooting

### security: SecKeychainItemImport: Unknown format in import

```shell
security import "$cert" \
      -k ~/Library/Keychains/login.keychain-db \
      -T /usr/bin/codesign \
      -T /usr/bin/security \
      ${CERTIFICATE_PASSWORD:+-P "$CERTIFICATE_PASSWORD"}
```

```text
security: SecKeychainItemImport: Unknown format in import.
```

Verified the Certificate contains private key using [SSL](ssl.md) troubleshooting section.

<!-- Solution: remove the `-T /usr/bin/security` switch. -->

Solution: Ensure `$cert` is a filename ending in `.p12`.

### security: SecItemCopyMatching: The specified item could not be found in the keychain

You're importing the certificate into one keychain but setting permissions on a different keychain.

### XCodeBuild / Fastlane building hanging with no output

Resolved this by adding `setup_ci` to Fastlane config and then loading the cert to the expected keychain of
`fastlane_tmp_keychain-db`.

The naming format is `"$name"-db`.

```shell
cert="certificate.p12"
keychain="build.keychain"
KEYCHAIN_PATH="$HOME/Library/Keychains/$keychain-db"
echo "KEYCHAIN_PATH=$KEYCHAIN_PATH" >> "$GITHUB_ENV"
base64 --decode <<< "$CERTIFICATE" > "$cert"
file "$cert"
md5 "$cert"
security create-keychain -p "" "$keychain"
security default-keychain -s "$keychain"
security unlock-keychain -p "" "$keychain"
security import "$cert" \
    -k "$KEYCHAIN_PATH" \
    -T /usr/bin/codesign \
    ${CERTIFICATE_PASSWORD:+-P "$CERTIFICATE_PASSWORD"}
security set-key-partition-list -S apple-tool:,apple: -k "" "$keychain"
```

### No Runtimes

If after:

```shell
xcodebuild -downloadPlatform iOS
```

You have empty runtimes:

```shell
xcrun simctl list runtimes
== Runtimes ==
```

```shell
sudo rm -rf /Library/Developer/Xcode
sudo rm -rf ~/Library/Developer/Xcode
sudo rm -rf ~/Library/Caches/com.apple.dt.Xcode
```

```shell
xcodebuild -downloadPlatform iOS
```
