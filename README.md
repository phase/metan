# Metan

![screenshot of catan board on ios](screenshots/ios-board.png "ios board")

Catan clone using Kotlin Multiplatform Mobile (KMM) + macOS.

## Project Structure
- `shared`: KMM module with shared Kotlin
  - `commonMain`: on all targets
  - `androidMain`: on all Android targets
  - `darwinMain`: on all iOS and macOS targets
  - `iosMain`: on all iOS targets
  - `macosMain`: on all macOS targets
  - lots of target-specific source sets
- `android`: the android app
  - depends on `shared`
- `darwin`: the XCode project for the macOS and iOS apps, Swift
  - `shared`: shared Swift code for both apps
  - `ios`: the iOS app
  - `macos`: the macOS app

The KMM plugin generates an Obj-C header with a bunch of Swift attributes that the Swift compiler
(and XCode) understand how to read, so you can use Kotlin in your Swift.

## Building

I'm not sure how to package this yet.

```bash
# build framework for macOS target
./gradlew linkDebugFrameworkMacosArm64
# same for iOS
./gradlew linkDebugFrameworkIosArm64
```
