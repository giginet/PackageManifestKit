import Foundation

public struct PackageCondition: Codable, Hashable, Sendable {
    public let platformNames: [String]
    public let config: String?
    public let traits: Set<String>?

    public init(platformNames: [String] = [], config: String? = nil, traits: Set<String>? = nil) {
        assert(!(platformNames.isEmpty && config == nil && traits == nil))
        self.platformNames = platformNames
        self.config = config
        self.traits = traits
    }
}
