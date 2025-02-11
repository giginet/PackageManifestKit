import Foundation

public struct Product: Hashable, Sendable, Codable {

    /// The name of the product.
    public let name: String

    /// The targets in the product.
    public let targets: [String]

    /// The type of product.
    public let type: ProductType
}

public enum ProductType: Equatable, Hashable, Sendable {

    /// The type of library.
    public enum LibraryType: String, Codable, Sendable {

        /// Static library.
        case `static`

        /// Dynamic library.
        case `dynamic`

        /// The type of library is unspecified and should be decided by package manager.
        case automatic
    }

    /// A library product.
    case library(LibraryType)

    /// An executable product.
    case executable

    /// An executable code snippet.
    case snippet

    /// An plugin product.
    case plugin

    /// A test product.
    case test

    /// A macro product.
    case `macro`

    public var isLibrary: Bool {
        guard case .library = self else { return false }
        return true
    }
}

extension ProductType: Codable {
    private enum CodingKeys: String, CodingKey {
        case library, executable, snippet, plugin, test, `macro`
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .library(a1):
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .library)
            try unkeyedContainer.encode(a1)
        case .executable:
            try container.encodeNil(forKey: .executable)
        case .snippet:
            try container.encodeNil(forKey: .snippet)
        case .plugin:
            try container.encodeNil(forKey: .plugin)
        case .test:
            try container.encodeNil(forKey: .test)
        case .macro:
            try container.encodeNil(forKey: .macro)
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
        case .library:
            var unkeyedValues = try values.nestedUnkeyedContainer(forKey: key)
            let a1 = try unkeyedValues.decode(ProductType.LibraryType.self)
            self = .library(a1)
        case .test:
            self = .test
        case .executable:
            self = .executable
        case .snippet:
            self = .snippet
        case .plugin:
            self = .plugin
        case .macro:
            self = .macro
        }
    }
}
