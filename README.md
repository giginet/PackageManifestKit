# PackageManifestKit

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
