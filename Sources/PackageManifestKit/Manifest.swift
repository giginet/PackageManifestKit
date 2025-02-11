import Foundation

//case name, path, url, version, targetMap, toolsVersion,
//     pkgConfig, providers, cLanguageStandard, cxxLanguageStandard, swiftLanguageVersions,
//     dependencies, products, targets, traits, platforms, packageKind, revision,
//     defaultLocalization

public struct Manifest: Codable, Sendable {
    public let name: String
    public let toolsVersion: ToolsVersion
    public let pkgConfig: String?
    public let providers: [SystemPackageProvider]?
    public let cLanguageStandard: String?
    public let cxxLanguageStandard: String?
    public let swiftLanguageVersions: [SwiftLanguageVersion]?
//    public let dependencies: [Dependency]
    public let products: [Product]
    public let targets: [Target]
    public let traits: [String]?
    public let platforms: [Platform]?
    public let packageKind: PackageKind
    public let revision: String?
    public let defaultLocalization: String?
    
}
