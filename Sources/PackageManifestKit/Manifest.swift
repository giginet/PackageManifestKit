import Foundation

public struct Manifest: Codable {
    public let name: String
    public let packageKind: PackageKind
    public let pkgConfig: String?
    public let platforms: [Platform]
    public let products: [Product]
    public let providers: String?
    public let swiftLanguageVersions: [String]?
    public let dependencies: [Dependency]
    public let targets: [Target]
    public let toolsVersion: ToolsVersion
    public let cLanguageStandard: String?
    public let cxxLanguageStandard: String?
}

public struct PackageKind: Codable {
    public let root: [String]
}

public struct Platform: Codable {
    public let options: [String]
    public let platformName: String
    public let version: String
}

public struct Product: Codable {
    public let name: String
    public let settings: [String]
    public let targets: [String]
    public let type: ProductType
}

public struct ProductType: Codable {
    public let library: [String]?
}

public struct Dependency: Codable {
    public let sourceControl: [SourceControl]
}

public struct SourceControl: Codable {
    public let identity: String
    public let location: Location
    public let productFilter: String?
    public let requirement: Requirement
}

public struct Location: Codable {
    public let remote: [Remote]
}

public struct Remote: Codable {
    public let urlString: String
}

public struct Requirement: Codable {
    public let range: [VersionRange]
}

public struct VersionRange: Codable {
    public let lowerBound: String
    public let upperBound: String
}

public struct Target: Codable {
    public let dependencies: [String]
    public let exclude: [String]
    public let name: String
    public let packageAccess: Bool
    public let resources: [String]
    public let settings: [String]
    public let type: String
}

public struct ToolsVersion: Codable {
    public let _version: String
}