# PackageManifestKit

![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/giginet/PackageManifestKit/ci.yml?style=flat-square&logo=github)
![Swift 6.0](https://img.shields.io/badge/Swift-6.0-FA7343?logo=swift&style=flat-square)
[![Xcode 16.2](https://img.shields.io/badge/Xcode-16.2-1984E6?style=flat-square&logo=xcode&link=https%3A%2F%2Fdeveloper.apple.com%2Fxcode%2F)](https://developer.apple.com/xcode/)
[![SwiftPM](https://img.shields.io/badge/SwiftPM-compatible-green?logo=swift&style=flat-square)](https://swift.org/package-manager/) 
![Platforms](https://img.shields.io/badge/Platform-macOS-lightgray?logo=apple&style=flat-square)
[![License](https://img.shields.io/badge/License-MIT-darkgray?style=flat-square)
](https://github.com/giginet/PackageManifestKit/blob/main/LICENSE.md)

Swift model collections for parsing `Package.swift`.

> [!WARNING]
> This product is very experimental. It doesn't have enough test cases.

## Overview

SwiftPM has a feature to dump the `Package.swift` resolution result as JSON. This package provides `Codable' models to handle the JSON.

```console
swift package dump-package > package.json
```

## Usage

```swift
import PackageManifestKit

let manifest = jsonDecoder.decode(Manifest.self, from: jsonData)

```
