import Testing
import Foundation
@testable import PackageManifestKit

@Suite
struct ManifestTests {
    private let jsonDecoder = JSONDecoder()
    
    @Test func decodeManifest() async throws {
        let jsonData = try #require(FixtureLoader.load(named: "simple_package.json"))
        
        let manifest = try jsonDecoder.decode(Manifest.self, from: jsonData)
        
        #expect(manifest.name == "MyFramework")
    }
}
