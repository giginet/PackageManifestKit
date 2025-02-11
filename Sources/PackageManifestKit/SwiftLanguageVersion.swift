import Foundation

public struct SwiftLanguageVersion: Codable, Hashable, Sendable {
    /// Swift language version 3.
    public static let v3 = SwiftLanguageVersion(version: "3")

    /// Swift language version 4.
    public static let v4 = SwiftLanguageVersion(version: "4")

    /// Swift language version 4.2.
    public static let v4_2 = SwiftLanguageVersion(version: "4.2")

    /// Swift language version 5.
    public static let v5 = SwiftLanguageVersion(version: "5")

    /// Swift language version 6.
    public static let v6 = SwiftLanguageVersion(version: "6")

    private let version: String

    init(version: String) {
        self.version = version
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(version)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let version = try container.decode(String.self)
        self.init(version: version)
    }
}
