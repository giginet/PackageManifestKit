// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "PackageManifestKit",
    products: [
        .library(
            name: "PackageManifestKit",
            targets: ["PackageManifestKit"]),
    ],
    targets: [
        .target(
            name: "PackageManifestKit"),
        .testTarget(
            name: "PackageManifestKitTests",
            dependencies: [
                "PackageManifestKit",
            ]
        ),
    ]
)
