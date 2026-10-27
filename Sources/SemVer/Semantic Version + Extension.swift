//
//  Semantic Version + Extension.swift
//  SemVer
//
//  Created by Ky on 2026-10-23.
//

import Foundation



/// An extension to a semantic version. Currently, only pre-release and build extensions are supported.
public protocol SemanticVersionExtension:
    CustomStringConvertible,
    ExpressibleByArrayLiteral,
    ExpressibleByIntegerLiteral,
    ExpressibleByStringLiteral,
    Comparable
{
    /// Currently, all SemVer extensions can be any ASCII sequence
    associatedtype CharacterRestrictions: CanBeAlphanumeric = OnlyAlphanumerics
    
    
    
    /// The character that precedes this extension when it appears in a SemVer.
    /// For example, the `-` in `1.0.0-RC.1`, or the + in `1.0.0+123`.
    static var prefix: Character { get }
    
    /// The name of this semantic version extension, like `"pre-release"` or `"build"`
    static var name: String { get }
    
    
    /// All idenntifiers in this extension
    var identifiers: [Identifier] { get }
    
    /// Creates a new SemVer extension with the given identifiers
    ///
    /// - Parameter identifiers: All identifiers of this extension
    init(identifiers: [Identifier])
    
    
    /// Compares two SemVer extensions of this type, and returns the determined order. This attempts to exactly match the
    /// behavior described in the SemVer 2.0.0 spec paragraph 11: https://semver.org/spec/v2.0.0.html#spec-item-11
    ///
    /// - Parameters:
    ///   - lhs: The first extension to compare
    ///   - rhs: The second extension to compare
    ///
    /// - Returns: The order of the extensions
    static func compare(lhs: Self, rhs: Self) -> ComparisonResult
}



public extension SemanticVersionExtension {
    /// A piece of the extension. For instance, in the pre-release extension `RC.1`, the identifiers are `RC` and `1`.
    typealias Identifier = SemanticVersion.Identifier<CharacterRestrictions>
}




public extension SemanticVersion.Extension {
    
    typealias PreRelease = SemanticVersionPreRelease
    typealias Build = SemanticVersionBuild
    
    
    
    /// Creates a string of period-separated identifiers, so `["public", "RC", 1]` would become `"public.RC.1"`
    var description: String {
        return identifiers.filter(\.isValid).joined(separator: ".")
    }
    
    
    /// Creates a string suitable for naïve concatenation with a semantic version string.
    /// For example, a pre-release extension like `["RC", 1]` would become `"-RC.1"`, and a build like
    /// `["2018", "01", "15"]` would become `"+2018.01.15"`.
    var descriptionWithPrefix: String {
        return "\(type(of: self).prefix)\(description)"
    }
    
    
    /// Creates a new extension by converting the given array into an array of strings
    ///
    /// If any of the given strings would be an invalid identifier, this returns `nil`.
    ///
    /// - Parameter identifiers: Soon-to-be identifiers
    init?(_ identifiers: [String]) {
        guard false == identifiers.isEmpty else { return nil }
        
        do {
            self.init(identifiers: try identifiers.map {
                guard let stringIdentifier = Identifier.string($0.description) else {
                    assertionFailure("Invalid \(Self.name) identifier. In production, the whole SemVer will be rejected: \($0)")
                    
                    // Using errors here because throwing is the only early-exit option here
                    throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: ""))
                }
                
                return stringIdentifier
            })
        }
        catch {
            return nil
        }
    }
    
    
    /// Creates a new extension by separating the given raw string by any periods in it
    ///
    /// - Parameter rawString: A raw representation of a semantic version string.
    ///                        This should match the regex `/^[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*$/`.
    init?(_ rawString: Substring) {
        // Since `.split` will happily just remove its separator from the start & end, and compress repeated separators,
        // but all those cases are invalid for identifiers, we gotta check for that first
        guard false == rawString.hasPrefix("."),
              false == rawString.hasSuffix("."),
              false == rawString.contains("..")
        else {
            return nil
        }
        
        self.init(rawString.split(separator: ".").map { String($0) })
    }
    
    
    /// Creates a new extension by separating the given raw string by any periods in it
    ///
    /// - Parameter rawString: A raw representation of a semantic version string.
    ///                        This should match the regex `/^[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*$/`.
    init?(_ rawString: String) {
        // Since `.split` will happily just remove its separator from the start & end, and compress repeated separators,
        // but all those cases are invalid for identifiers, we gotta check for that first
        guard false == rawString.hasPrefix("."),
              false == rawString.hasSuffix("."),
              false == rawString.contains("..")
        else {
            return nil
        }
        
        self.init(rawString.split(separator: ".").map { String($0) })
    }
    
    
    /// Creates a new extension by converting the given array/varargs into an array of strings
    ///
    /// - Parameter identifiers: Soon-to-be identifiers
    init(arrayLiteral elements: Self.Identifier...) {
        // The `Identifier` initializer will mark invalid identifiers; invalidate the whole extension if we find any
        guard elements.allSatisfy(\.isValid) else {
            assertionFailure("""
                Invalid identifiers detected!
                In production builds, the entire \(Self.name) extension will be empty
                """)
            self.init(identifiers: [])
            return
        }
        self.init(identifiers: elements)
    }
    
    
    /// Creates a new extension by converting the given integer into a string and assuming that is the only identifier
    ///
    /// - Parameter value: The only identifier, to become a string
    init(integerLiteral value: UInt) {
        self.init(identifiers: [.integer(value)])
    }
    
    
    /// Creates a new extension by separating the given raw string by any periods in it
    ///
    /// - Parameter rawString: A raw representation of a semantic version string.
    ///                        This should match the regex `/^[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*$/`.
    init(stringLiteral value: String) {
        guard let success = Self.init(value) else {
            assertionFailure("""
                Invalid \(Self.name) in literal!
                In production, this will result in an empty/omitted \(Self.name): \(value)
                """)
            self.init(identifiers: [])
            return
        }
        
        self = success
    }
}



public extension SemanticVersion.Extension {
    
    /// Determines whether the given two SemVer extensions are in ascending order. This attempts to exactly match the
    /// behavior described in the SemVer 2.0.0 spec paragraph 11: https://semver.org/spec/v2.0.0.html#spec-item-11
    ///
    /// - Parameters:
    ///   - lhs: The first extension to compare
    ///   - rhs: The second extension to compare
    /// - Returns: `true` iff `lhs` is less than, or has lower precedence than, `rhs`. If they have the same
    ///            precedence, this will still return `false`.
    /// - Note:  To determine the exact order, use `compare(lhs:rhs:)`
    static func <(lhs: Self, rhs: Self) -> Bool {
        .orderedAscending == compare(lhs: lhs, rhs: rhs)
    }
    
    
    /// Determines whether one SemVer 2.0.0 extension is equal to another
    ///
    /// - Parameters:
    ///   - lhs: One extension
    ///   - rhs: Another extension
    ///
    /// - Returns: `true` iff the given two extensions are equal
    static func ==(lhs: Self, rhs: Self) -> Bool {
        .orderedSame == compare(lhs: lhs, rhs: rhs)
    }
    
    
    func compare(to other: Self) -> ComparisonResult {
        Self.compare(lhs: self, rhs: other)
    }
}
