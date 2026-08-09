import Foundation
import Testing

@testable import PackageManifestKit

@Suite
struct TargetTests {
    private let jsonDecoder = JSONDecoder()

    @Test
    func decodeStrictMemorySafety() throws {
        // .strictMemorySafety()
        let rawJSONString =
            """
            {
                "strictMemorySafety" : {
                }
            }
            """

        let target = try jsonDecoder.decode(
            Target.TargetBuildSetting.Kind.self,
            from: #require(rawJSONString.data(using: .utf8))
        )

        #expect(target == .strictMemorySafety)
    }

    @Test
    func decodeTreatAllWarnings() throws {
        // .treatAllWarnings(as: .error)
        let rawJSONString =
            """
            {
                "treatAllWarnings" : {
                    "_0" : "error"
                }
            }
            """

        let target = try jsonDecoder.decode(
            Target.TargetBuildSetting.Kind.self,
            from: #require(rawJSONString.data(using: .utf8))
        )

        #expect(target == .treatAllWarnings("error"))
    }

    @Test
    func decodeTreatWarning() throws {
        // .treatWarning("Name", as: .warning)
        let rawJSONString =
            """
            {
                "treatWarning" : {
                    "_0" : "Name",
                    "_1" : "warning"
                }
            }
            """

        let target = try jsonDecoder.decode(
            Target.TargetBuildSetting.Kind.self,
            from: #require(rawJSONString.data(using: .utf8))
        )

        #expect(target == .treatWarning("Name", "warning"))
    }

    @Test
    func decodeDefaultIsolation() throws {
        // .defaultIsolation(MainActor.self)
        let rawJSONString =
            """
            {
                "defaultIsolation" : {
                    "_0" : "MainActor"
                }
            }
            """

        let target = try jsonDecoder.decode(
            Target.TargetBuildSetting.Kind.self,
            from: #require(rawJSONString.data(using: .utf8))
        )

        #expect(target == .defaultIsolation("MainActor"))
    }

    @Test
    func decodeWarningControlSetting() throws {
        // .disableWarning("conversion")
        let rawJSONString =
            """
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
