/*
 This source file is part of the Swift.org open source project

 Copyright (c) 2014 - 2017 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See http://swift.org/LICENSE.txt for license information
 See http://swift.org/CONTRIBUTORS.txt for Swift project authors
*/
import Foundation

/// A wrapper for Range to make it Codable.
///
/// Technically, we can use conditional conformance and make
/// stdlib's Range Codable but since extensions leak out, it
/// is not a good idea to extend types that you don't own.
///
/// Range conformance will be added soon to stdlib so we can remove
/// this type in the future.
public struct CodableRange<Bound> where Bound: Comparable & Codable {

    /// The underlying range.
    public let range: Range<Bound>

    /// Create a CodableRange instance.
    public init(_ range: Range<Bound>) {
        self.range = range
    }
}

extension CodableRange: Sendable where Bound: Sendable {}

extension CodableRange: Codable {
    private enum CodingKeys: String, CodingKey {
        case lowerBound, upperBound
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(range.lowerBound, forKey: .lowerBound)
        try container.encode(range.upperBound, forKey: .upperBound)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let lowerBound = try container.decode(Bound.self, forKey: .lowerBound)
        let upperBound = try container.decode(Bound.self, forKey: .upperBound)
        self.init(Range(uncheckedBounds: (lowerBound, upperBound)))
    }
}
