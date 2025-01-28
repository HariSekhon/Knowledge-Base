# Mobile Builds

<!-- INDEX_START -->

- [iOS](#ios)
  - [CocoaPods](#cocoapods)
  - [Metadata](#metadata)
  - [Build](#build)

<!-- INDEX_END -->

## iOS

### CocoaPods

<https://cocoapods.org/>

<https://guides.cocoapods.org/>

CocoaPods is a dependency manager for Swift and Objective-C Cocoa projects.

It's written in Ruby and can be installed using the system ruby.

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
pod spec create "$app"
```

```shell
"$EDITOR" "$app".podspec
```

```shell
pod spec lint "$app".podspec
```

### Metadata

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
open "$app".xcodeproj
```

```shell
open "$app".xcworkspace
```

### Build

```shell
xcodebuild -workspace "$app".xcworkspace -scheme SIT -configuration SIT clean
```
