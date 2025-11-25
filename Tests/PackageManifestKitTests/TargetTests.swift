import Foundation
import Testing

@testable import PackageManifestKit

@Suite
struct TargetTests {
    private let jsonDecoder = JSONDecoder()

    @Test
    func decodeWarningControlSetting() throws {
        // .disableWarning("conversion")
        let rawJSONString = """
        {
            "disableWarning" : {
              "_0" : "conversion"
            }
        }
        """

        let target = try jsonDecoder.decode(
            Target.TargetBuildSetting.Kind.self,
            from: #require(rawJSONString.data(using: .utf8))
        )

        #expect(target == .disableWarning("conversion"))
    }
}
