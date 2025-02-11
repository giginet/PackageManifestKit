import Foundation

public struct Platform: Codable, Hashable, Sendable {
    public let platformName: String
    public let version: String
    public let options: [String]

    public init(name: String, version: String, options: [String] = []) {
        self.platformName = name
        self.version = version
        self.options = options
    }
}
