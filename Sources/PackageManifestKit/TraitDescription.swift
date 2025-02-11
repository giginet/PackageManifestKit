import Foundation

public struct TraitDescription: Sendable, Hashable, Codable {
    /// The trait's canonical name.
    ///
    /// This is used when enabling the trait or when referring to it from other modifiers in the manifest.
    public var name: String

    /// The trait's description.
    public var description: String?

    /// A set of other traits of this package that this trait enables.
    public var enabledTraits: Set<String>
}
