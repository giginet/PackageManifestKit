import Foundation

public struct ToolsVersion: Codable, Sendable, Equatable {
    public static let v3 = ToolsVersion(version: "3.1.0")
    public static let v4 = ToolsVersion(version: "4.0.0")
    public static let v4_2 = ToolsVersion(version: "4.2.0")
    public static let v5 = ToolsVersion(version: "5.0.0")
    public static let v5_2 = ToolsVersion(version: "5.2.0")
    public static let v5_3 = ToolsVersion(version: "5.3.0")
    public static let v5_4 = ToolsVersion(version: "5.4.0")
    public static let v5_5 = ToolsVersion(version: "5.5.0")
    public static let v5_6 = ToolsVersion(version: "5.6.0")
    public static let v5_7 = ToolsVersion(version: "5.7.0")
    public static let v5_8 = ToolsVersion(version: "5.8.0")
    public static let v5_9 = ToolsVersion(version: "5.9.0")
    public static let v5_10 = ToolsVersion(version: "5.10.0")
    public static let v6_0 = ToolsVersion(version: "6.0.0")
    public static let v6_1 = ToolsVersion(version: "6.1.0")
    public static let vNext = ToolsVersion(version: "999.0.0")

    private let _version: String

    init(version: String) {
        self._version = version
    }
}
