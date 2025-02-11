import Foundation

public enum SystemPackageProvider: Hashable, Codable, Sendable {
    case brew([String])
    case apt([String])
    case yum([String])
    case nuget([String])
}
