import Foundation

/// The products requested of a package.
///
/// Any product which matches the filter will be used for dependency resolution, whereas unrequested products will be ignored.
///
/// Requested products need not actually exist in the package. Under certain circumstances, the resolver may request names whose package of origin are unknown. The intended package will recognize and fulfill the request; packages that do not know what it is will simply ignore it.
public enum ProductFilter: Equatable, Hashable, Sendable {

    /// All products, targets, and tests are requested.
    ///
    /// This is used for root packages.
    case everything

    /// A set of specific products requested by one or more client packages.
    case specific(Set<String>)

    /// No products, targets, or tests are requested.
    public static var nothing: ProductFilter { .specific([]) }
}

extension ProductFilter: Codable {
    public func encode(to encoder: Encoder) throws {
        let optionalSet: Set<String>?
        switch self {
        case .everything:
            optionalSet = nil
        case .specific(let set):
            optionalSet = set
        }
        var container = encoder.singleValueContainer()
        try container.encode(optionalSet?.sorted())
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .everything
        } else {
            self = .specific(Set(try container.decode([String].self)))
        }
    }
}
