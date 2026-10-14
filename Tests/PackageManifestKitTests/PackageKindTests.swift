import Foundation
import Testing

@testable import PackageManifestKit

@Suite
struct PackageKindTests {
    @Test
    func roundTripRegistry() throws {
        let kind = PackageKind.registry("scope.name")
        let data = try JSONEncoder().encode(kind)
        let decodedKind = try JSONDecoder().decode(PackageKind.self, from: data)

        #expect(decodedKind == kind)
    }
}
