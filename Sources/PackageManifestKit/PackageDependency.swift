import Foundation

/// Represents a package dependency.
public enum PackageDependency: Equatable, Hashable, Sendable {
    /// A struct representing an enabled trait of a dependency.
    package struct Trait: Hashable, Sendable, Codable {
        /// A condition that limits the application of a dependencies trait.
        package struct Condition: Hashable, Sendable, Codable {
            /// The set of traits of this package that enable the dependencie's trait.
            package let traits: Set<String>?

            public init(traits: Set<String>?) {
                self.traits = traits
            }
        }

        /// The name of the enabled trait.
        package var name: String

        /// The condition under which the trait is enabled.
        package var condition: Condition?
    }

    case fileSystem(FileSystem)
    case sourceControl(SourceControl)
    case registry(Registry)
    
    public struct FileSystem: Equatable, Hashable, Codable, Sendable {
        public let identity: String
        public let nameForTargetDependencyResolutionOnly: String?
        public let path: URL
        public let productFilter: ProductFilter
        package let traits: Set<Trait>?
    }

    public struct SourceControl: Equatable, Hashable, Codable, Sendable {
        public let identity: String
        public let nameForTargetDependencyResolutionOnly: String?
        public let location: Location
        public let requirement: Requirement
        public let productFilter: ProductFilter
        package let traits: Set<Trait>?

        public enum Requirement: Equatable, Hashable, Sendable {
            case exact(String)
            case range(Range<String>)
            case revision(String)
            case branch(String)
        }

        public enum Location: Equatable, Hashable, Sendable {
            case local(URL)
            case remote(SourceControlURL)
        }
    }

    public struct Registry: Equatable, Hashable, Codable, Sendable {
        public let identity: String
        public let requirement: Requirement
        public let productFilter: ProductFilter
        package let traits: Set<Trait>?

        /// The dependency requirement.
        public enum Requirement: Equatable, Hashable, Sendable {
            case exact(Version)
            case range(Range<Version>)
        }
    }
}

extension PackageDependency: Codable {
    private enum CodingKeys: String, CodingKey {
        case local, fileSystem, scm, sourceControl, registry
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .fileSystem(let settings):
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .fileSystem)
            try unkeyedContainer.encode(settings)
        case .sourceControl(let settings):
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .sourceControl)
            try unkeyedContainer.encode(settings)
        case .registry(let settings):
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .registry)
            try unkeyedContainer.encode(settings)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // We'll look at which key is present. Exactly one of .fileSystem,
        // .sourceControl, or .registry should be present (to match encode(to:)).

        if container.contains(.fileSystem) {
            var unkeyed = try container.nestedUnkeyedContainer(forKey: .fileSystem)
            let settings = try unkeyed.decode(FileSystem.self)
            self = .fileSystem(settings)
        }
        else if container.contains(.sourceControl) {
            var unkeyed = try container.nestedUnkeyedContainer(forKey: .sourceControl)
            let settings = try unkeyed.decode(SourceControl.self)
            self = .sourceControl(settings)
        }
        else if container.contains(.registry) {
            var unkeyed = try container.nestedUnkeyedContainer(forKey: .registry)
            let settings = try unkeyed.decode(Registry.self)
            self = .registry(settings)
        }
        else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "No recognized PackageDependency key found."
                )
            )
        }
    }
}

extension PackageDependency.SourceControl.Requirement: Codable {
    private enum CodingKeys: String, CodingKey {
        case exact, range, revision, branch
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .exact(a1):
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .exact)
            try unkeyedContainer.encode(a1)
        case let .range(a1):
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .range)
            try unkeyedContainer.encode(CodableRange(a1))
        case let .revision(a1):
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .revision)
            try unkeyedContainer.encode(a1)
        case let .branch(a1):
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .branch)
            try unkeyedContainer.encode(a1)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Match exactly one key (just like the custom encoder).
        if container.contains(.exact) {
            var nested = try container.nestedUnkeyedContainer(forKey: .exact)
            let value = try nested.decode(String.self)
            self = .exact(value)
        }
        else if container.contains(.range) {
            var nested = try container.nestedUnkeyedContainer(forKey: .range)
            let codableRange = try nested.decode(CodableRange<String>.self)
            self = .range(codableRange.range)
        }
        else if container.contains(.revision) {
            var nested = try container.nestedUnkeyedContainer(forKey: .revision)
            let value = try nested.decode(String.self)
            self = .revision(value)
        }
        else if container.contains(.branch) {
            var nested = try container.nestedUnkeyedContainer(forKey: .branch)
            let value = try nested.decode(String.self)
            self = .branch(value)
        }
        else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "No recognized key for SourceControl.Requirement."
                )
            )
        }
    }
}

extension PackageDependency.SourceControl.Location: Codable {
    private enum CodingKeys: String, CodingKey {
        case local, remote
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .local(let path):
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .local)
            try unkeyedContainer.encode(path)
        case .remote(let url):
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .remote)
            try unkeyedContainer.encode(url)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if container.contains(.local) {
            var nested = try container.nestedUnkeyedContainer(forKey: .local)
            let path = try nested.decode(URL.self)
            self = .local(path)
        }
        else if container.contains(.remote) {
            var nested = try container.nestedUnkeyedContainer(forKey: .remote)
            let url = try nested.decode(SourceControlURL.self)
            self = .remote(url)
        }
        else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "No recognized key for SourceControl.Location."
                )
            )
        }
    }
}

extension PackageDependency.Registry.Requirement: Codable {
    private enum CodingKeys: String, CodingKey {
        case exact, range
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .exact(a1):
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .exact)
            try unkeyedContainer.encode(a1)
        case let .range(a1):
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .range)
            try unkeyedContainer.encode(CodableRange(a1))
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if container.contains(.exact) {
            var nested = try container.nestedUnkeyedContainer(forKey: .exact)
            let version = try nested.decode(Version.self)
            self = .exact(version)
        }
        else if container.contains(.range) {
            var nested = try container.nestedUnkeyedContainer(forKey: .range)
            let codableRange = try nested.decode(CodableRange<Version>.self)
            self = .range(codableRange.range)
        }
        else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "No recognized key for Registry.Requirement."
                )
            )
        }
    }
}


public struct SourceControlURL: Codable, Equatable, Hashable, Sendable {
    private let urlString: String
}
