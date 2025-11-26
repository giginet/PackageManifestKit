import Foundation

public struct Target: Hashable, Codable, Sendable {
    public enum TargetKind: String, Hashable, Codable, Sendable {
        case regular
        case executable
        case test
        case system
        case binary
        case plugin
        case `macro`
    }

    /// Represents a target's dependency on another entity.
    public enum Dependency: Hashable, Sendable {
        case target(name: String, condition: PackageCondition?)
        case product(
            name: String, package: String?, moduleAliases: [String: String]? = nil,
            condition: PackageCondition?)
        case byName(name: String, condition: PackageCondition?)

        var condition: PackageCondition? {
            switch self {
            case .target(_, let condition):
                return condition
            case .product(_, _, _, let condition):
                return condition
            case .byName(_, let condition):
                return condition
            }
        }

        public static func target(name: String) -> Dependency {
            return .target(name: name, condition: nil)
        }

        public static func product(
            name: String, package: String? = nil, moduleAliases: [String: String]? = nil
        ) -> Dependency {
            return .product(
                name: name, package: package, moduleAliases: moduleAliases, condition: nil)
        }
    }

    /// A namespace for target-specific build settings.
    public enum TargetBuildSetting {
        /// The tool for which a build setting is declared.
        public enum Tool: String, Codable, Hashable, CaseIterable, Sendable {
            case c
            case cxx
            case swift
            case linker
        }

        public enum InteroperabilityMode: String, Codable, Hashable, Sendable {
            case C
            case Cxx
        }

        /// The kind of the build setting, with associate configuration
        public enum Kind: Codable, Hashable, Sendable {
            case headerSearchPath(String)
            case define(String)
            case linkedLibrary(String)
            case linkedFramework(String)

            case interoperabilityMode(InteroperabilityMode)

            case enableUpcomingFeature(String)
            case enableExperimentalFeature(String)

            case unsafeFlags([String])

            case swiftLanguageMode(SwiftLanguageVersion)

            case disableWarning(String)

            public var isUnsafeFlags: Bool {
                switch self {
                case .unsafeFlags(let flags):
                    // If `.unsafeFlags` is used, but doesn't specify any flags, we treat it the same way as not specifying it.
                    return !flags.isEmpty
                case .headerSearchPath, .define, .linkedLibrary, .linkedFramework,
                    .interoperabilityMode,
                    .enableUpcomingFeature, .enableExperimentalFeature, .swiftLanguageMode,
                    .disableWarning:
                    return false
                }
            }
        }

        /// An individual build setting.
        public struct Setting: Codable, Hashable, Sendable {
            /// The tool associated with this setting.
            public let tool: Tool

            /// The kind of the setting.
            public let kind: Kind

            /// The condition at which the setting should be applied.
            public let condition: PackageCondition?

            public init(
                tool: Tool,
                kind: Kind,
                condition: PackageCondition? = .none
            ) {
                self.tool = tool
                self.kind = kind
                self.condition = condition
            }
        }
    }

    public struct Resource: Codable, Hashable, Sendable {
        public enum Rule: Codable, Hashable, Sendable {
            case process(localization: Localization?)
            case copy
            case embedInCode
        }

        public enum Localization: String, Codable, Sendable {
            case `default`
            case base
        }

        /// The rule for the resource.
        public let rule: Rule

        /// The path of the resource.
        public let path: String

        public init(rule: Rule, path: String) {
            self.rule = rule
            self.path = path
        }
    }

    /// The name of the target.
    public let name: String

    /// If true, access to package declarations from other targets is allowed.
    /// APIs is not allowed from outside.
    public let packageAccess: Bool

    /// The custom path of the target.
    public let path: String?

    /// The url of the binary target artifact.
    public let url: String?

    /// The custom sources of the target.
    public let sources: [String]?

    /// The explicitly declared resources of the target.
    public let resources: [Resource]

    /// The exclude patterns.
    public let exclude: [String]

    // FIXME: Kill this.
    //
    /// Returns true if the target type is test.
    public var isTest: Bool {
        return type == .test
    }

    /// The declared target dependencies.
    public package(set) var dependencies: [Dependency]

    /// The custom public headers path.
    public let publicHeadersPath: String?

    /// The type of target.
    public let type: TargetKind

    /// The pkg-config name of a system library target.
    public let pkgConfig: String?

    /// The providers of a system library target.
    public let providers: [SystemPackageProvider]?

    /// The declared capability for a package plugin target.
    public let pluginCapability: PluginCapability?

    /// Represents the declared capability of a package plugin.
    public enum PluginCapability: Hashable, Sendable {
        case buildTool
        case command(intent: PluginCommandIntent, permissions: [PluginPermission])
    }

    public enum PluginCommandIntent: Hashable, Codable, Sendable {
        case documentationGeneration
        case sourceCodeFormatting
        case custom(verb: String, description: String)
    }

    public enum PluginNetworkPermissionScope: Hashable, Codable, Sendable {
        case none
        case local(ports: [Int])
        case all(ports: [Int])
        case docker
        case unixDomainSocket

        public init?(_ scopeString: String, ports: [Int]) {
            switch scopeString {
            case "none": self = .none
            case "local": self = .local(ports: ports)
            case "all": self = .all(ports: ports)
            case "docker": self = .docker
            case "unix-socket": self = .unixDomainSocket
            default: return nil
            }
        }
    }

    public enum PluginPermission: Hashable, Codable, Sendable {
        case allowNetworkConnections(scope: PluginNetworkPermissionScope, reason: String)
        case writeToPackageDirectory(reason: String)
    }

    /// The target-specific build settings declared in this target.
    public let settings: [TargetBuildSetting.Setting]

    /// The binary target checksum.
    public let checksum: String?

    /// The usages of package plugins by the target.
    public let pluginUsages: [PluginUsage]?

    /// Represents a target's usage of a plugin target or product.
    public enum PluginUsage: Hashable, Sendable {
        case plugin(name: String, package: String?)
    }
}

extension Target.Dependency: Codable {
    private enum CodingKeys: String, CodingKey {
        case target, product, byName
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .target(let a1, let a2):
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .target)
            try unkeyedContainer.encode(a1)
            try unkeyedContainer.encode(a2)
        case .product(let a1, let a2, let a3, let a4):
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .product)
            try unkeyedContainer.encode(a1)
            try unkeyedContainer.encode(a2)
            try unkeyedContainer.encode(a3)
            try unkeyedContainer.encode(a4)
        case .byName(let a1, let a2):
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .byName)
            try unkeyedContainer.encode(a1)
            try unkeyedContainer.encode(a2)
        }
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        guard let key = values.allKeys.first(where: values.contains) else {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: decoder.codingPath, debugDescription: "Did not find a matching key")
            )
        }
        switch key {
        case .target:
            var unkeyedValues = try values.nestedUnkeyedContainer(forKey: key)
            let a1 = try unkeyedValues.decode(String.self)
            let a2 = try unkeyedValues.decodeIfPresent(PackageCondition.self)
            self = .target(name: a1, condition: a2)
        case .product:
            var unkeyedValues = try values.nestedUnkeyedContainer(forKey: key)
            let a1 = try unkeyedValues.decode(String.self)
            let a2 = try unkeyedValues.decodeIfPresent(String.self)
            let a3 = try unkeyedValues.decodeIfPresent([String: String].self)
            let a4 = try unkeyedValues.decodeIfPresent(PackageCondition.self)
            self = .product(name: a1, package: a2, moduleAliases: a3, condition: a4)
        case .byName:
            var unkeyedValues = try values.nestedUnkeyedContainer(forKey: key)
            let a1 = try unkeyedValues.decode(String.self)
            let a2 = try unkeyedValues.decodeIfPresent(PackageCondition.self)
            self = .byName(name: a1, condition: a2)
        }
    }
}

extension Target.PluginUsage: Codable {
    private enum CodingKeys: String, CodingKey {
        case plugin
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .plugin(let name, let package):
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .plugin)
            try unkeyedContainer.encode(name)
            try unkeyedContainer.encode(package)
        }
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        guard let key = values.allKeys.first(where: values.contains) else {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: decoder.codingPath, debugDescription: "Did not find a matching key")
            )
        }
        switch key {
        case .plugin:
            var unkeyedValues = try values.nestedUnkeyedContainer(forKey: key)
            let name = try unkeyedValues.decode(String.self)
            let package = try unkeyedValues.decodeIfPresent(String.self)
            self = .plugin(name: name, package: package)
        }
    }
}

extension Target.PluginCapability: Codable {
    private enum CodingKeys: CodingKey {
        case buildTool, command
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .buildTool:
            try container.encodeNil(forKey: .buildTool)
        case .command(let a1, let a2):
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .command)
            try unkeyedContainer.encode(a1)
            try unkeyedContainer.encode(a2)
        }
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        guard let key = values.allKeys.first(where: values.contains) else {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: decoder.codingPath, debugDescription: "Did not find a matching key")
            )
        }
        switch key {
        case .buildTool:
            self = .buildTool
        case .command:
            var unkeyedValues = try values.nestedUnkeyedContainer(forKey: key)
            let a1 = try unkeyedValues.decode(Target.PluginCommandIntent.self)
            let a2 = try unkeyedValues.decode([Target.PluginPermission].self)
            self = .command(intent: a1, permissions: a2)
        }
    }
}
