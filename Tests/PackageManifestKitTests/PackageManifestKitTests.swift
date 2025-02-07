import Testing
import Foundation
@testable import PackageManifestKit

@Test func testDecodeManifest() async throws {
    let url = URL(filePath: #filePath)
        .deletingLastPathComponent()
        .appending(components: "Resources", "sample_manifest.json")

    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    let manifest = try decoder.decode(Manifest.self, from: data)
    
    #expect(manifest.name == "PackageManifestKit")
    #expect(manifest.packageKind.root == ["root"])
    #expect(manifest.pkgConfig == nil)
    #expect(manifest.platforms.count == 1)
    #expect(manifest.platforms[0].platformName == "macos")
    #expect(manifest.platforms[0].version == "10.15")
    #expect(manifest.products.count == 1)
    #expect(manifest.products[0].name == "PackageManifestKit")
    #expect(manifest.products[0].type.library == ["automatic"])
    #expect(manifest.swiftLanguageVersions == ["5"])
    #expect(manifest.dependencies.count == 1)
    #expect(manifest.dependencies[0].sourceControl[0].identity == "swift-testing")
    #expect(manifest.toolsVersion._version == "5.9.0")
}
