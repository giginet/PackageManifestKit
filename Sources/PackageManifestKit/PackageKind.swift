import Foundation

public enum PackageKind: Sendable, Equatable {
    /// A root package.
    case root(URL)

    /// A non-root local package.
    case fileSystem(URL)

    /// A local source package.
    case localSourceControl(URL)

    /// A remote source package.
    case remoteSourceControl(String)

    /// A package from  a registry.
    case registry(String)
    
    var isRoot: Bool {
        if case .root = self {
            return true
        } else {
            return false
        }
    }
}

extension PackageKind: Encodable {
    private enum CodingKeys: String, CodingKey {
        case root, fileSystem, localSourceControl, remoteSourceControl, registry
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .root(let path):
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .root)
            try unkeyedContainer.encode(path)
        case .fileSystem(let path):
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .fileSystem)
            try unkeyedContainer.encode(path)
        case .localSourceControl(let path):
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .localSourceControl)
            try unkeyedContainer.encode(path)
        case .remoteSourceControl(let url):
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .remoteSourceControl)
            try unkeyedContainer.encode(url)
        case .registry:
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .registry)
            try unkeyedContainer.encode(self.isRoot)
        }
    }
}

extension PackageKind: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Usually, you'd ensure exactly one key is present:
        guard let key = container.allKeys.first else {
            throw DecodingError.dataCorrupted(
                .init(codingPath: decoder.codingPath,
                      debugDescription: "No keys found for PackageKind.")
            )
        }

        switch key {
        case .root:
            var nested = try container.nestedUnkeyedContainer(forKey: .root)
            let path = try nested.decode(URL.self)
            self = .root(path)

        case .fileSystem:
            var nested = try container.nestedUnkeyedContainer(forKey: .fileSystem)
            let path = try nested.decode(URL.self)
            self = .fileSystem(path)

        case .localSourceControl:
            var nested = try container.nestedUnkeyedContainer(forKey: .localSourceControl)
            let path = try nested.decode(URL.self)
            self = .localSourceControl(path)

        case .remoteSourceControl:
            var nested = try container.nestedUnkeyedContainer(forKey: .remoteSourceControl)
            let url = try nested.decode(String.self)
            self = .remoteSourceControl(url)

        case .registry:
            var nested = try container.nestedUnkeyedContainer(forKey: .registry)
            let registryURL = try nested.decode(String.self)
            self = .registry(registryURL)
        }
    }
}
