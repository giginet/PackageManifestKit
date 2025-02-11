import Testing
import Foundation
@testable import PackageManifestKit

@Suite
struct ManifestTests {
    private let jsonDecoder = JSONDecoder()
    
    @Test func decodeManifest() async throws {
        let jsonData = try #require(FixtureLoader.load(named: "simple_package.json"))
        
        let manifest = try jsonDecoder.decode(Manifest.self, from: jsonData)
        
        // Basic properties
        #expect(manifest.name == "MyFramework")
        #expect(manifest.packageKind.isRoot)
        
        // Platforms
        #expect(manifest.platforms?.isEmpty == true)
        
        // Swift Language Version
        #expect(manifest.swiftLanguageVersions == nil)
        
        // Tools Version
        #expect(manifest.toolsVersion == .v6_0)
        
        // Products
        #expect(manifest.products.count == 1)
        let myFrameworkProduct = try #require(manifest.products.first)
        #expect(myFrameworkProduct.targets == ["MyFramework"])
        #expect(myFrameworkProduct.type == .library(.automatic))
        
        // Optional properties
        #expect(manifest.pkgConfig == nil)
        #expect(manifest.providers == nil)
        #expect(manifest.cLanguageStandard == nil)
        #expect(manifest.cxxLanguageStandard == nil)
    }
}
