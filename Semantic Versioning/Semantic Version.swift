//
//  Semantic Version.swift
//  Semantic Versioning
//
//  Created by Ben Leggiero on 2018-01-09.
//  Copyright © 2018 Ben Leggiero. All rights reserved.
//

import Foundation



public typealias SemVer = SemanticVersion



/// An implementation of Semantic Version 2.0.0, which is copyrighted to Tom Preston-Werner CC BY 3.0.
///
/// See the spec here: https://semver.org/spec/v2.0.0.html
///
/// This is designed to be as easy as possible to use. You may use the extremely-verbose and explicit initializer which
/// labels every parameter, or the one that does the same thing but excludes the labels, or the one that simply takes
/// any valid SemVer string and gently fails to `nil` if that string is invalid. You are encouraged to use whichever
/// one of these suits the needs at the time of use. Some examples are included in the unit tests.
///
/// Keep in mind that the pre-release and build extensions can be easily represented as string- and integer-literals.
/// For instance, `SemVer(1,2, SemVer.Build(identifiers: ["123", "4"]))` has the same result as `SemVer(1,2, "123.4")`.
/// Again, this is done for ease-of-use. `SemVer` itself would also be expressible by a string literal, but it has too
/// many resrictions so a failable initializer is presented instead.
///
/// This also already conforms to `Comparable`, since comparison and precedence are a major part of the spec.
public struct SemanticVersion {
    
    public typealias Identifier = SemanticVersionIdentifier
    public typealias Major = UInt
    public typealias Minor = UInt
    public typealias Patch = UInt
    public typealias Extension = SemanticVersionExtension
    public typealias PreRelease = Extension.PreRelease
    public typealias Build = Extension.Build
    
    
    
    /// The MAJOR version; increment this when you make incompatible API changes.
    ///
    /// This MUST be incremented if any backwards incompatible changes are introduced to the public API.
    /// This MAY include minor and patch level changes.
    /// Patch and minor version MUST be reset to `0` when major version is incremented.
    ///
    /// https://semver.org/spec/v2.0.0.html#spec-item-8
    ///
    /// - Attention: If this is `0`, then further rules don't apply.
    public var major: Major {
        willSet {
            minor = 0
            patch = 0
        }
    }
    
    /// The MINOR version; increment this when you add functionality in a backwards-compatible manner
    ///
    /// This MUST be incremented if new, backwards compatible functionality is introduced to the public API.
    /// This MUST be incremented if any public API functionality is marked as deprecated.
    /// This MAY be incremented if substantial new functionality or improvements are introduced within the private code.
    /// This MAY include patch level changes.
    /// Patch version MUST be reset to `0` when minor version is incremented.
    ///
    /// https://semver.org/spec/v2.0.0.html#spec-item-7
    public var minor: Minor {
        willSet {
            patch = 0
        }
    }
    
    /// The PATCH version; increment this when you
    ///
    /// This MUST be incremented if only backwards compatible bug fixes are introduced. A bug fix is defined as an
    /// internal change that fixes incorrect behavior
    ///
    /// https://semver.org/spec/v2.0.0.html#spec-item-6
    public var patch: Patch?
    
    public var preRelease: PreRelease?
    public var build: Build?
    
    
    /// Create a new Semantic Version with explicit parts
    ///
    /// - Parameters:
    ///   - major: The MAJOR version
    ///   - minor: The MINOR version
    ///   - patch: The PATCH version
    ///   - preRelease: Indicates some specific information about a pre-release build, like `RC.1`
    ///   - build: The build number, like `123` or `exp.sha.5114f85` or `2018.01.14.00.01`
    public init(major: Major, minor: Minor, patch: Patch? = nil, preRelease: PreRelease? = nil, build: Build? = nil) {
        self.major = major
        self.minor = minor
        self.patch = patch
        self.preRelease = preRelease
        self.build = build
    }
    
    
    /// Create a new Semantic Version with explicit (yet unlabelled) parts
    ///
    /// - Parameters:
    ///   - major: The MAJOR version
    ///   - minor: The MINOR version
    ///   - patch: The PATCH version
    ///   - preRelease: Indicates some specific information about a pre-release build, like `RC.1`
    ///   - build: The build number, like `123` or `exp.sha.5114f85` or `2018.01.14.00.01`
    public init(_ major: Major, _ minor: Minor, _ patch: Patch? = nil, _ preRelease: PreRelease? = nil, _ build: Build? = nil) {
        self.init(major: major, minor: minor, patch: patch, preRelease: preRelease, build: build)
    }
}



/// A single piece of a semantic version, like `minor` or `build`
public protocol SemanticVersionIdentifier {}



extension UInt: SemanticVersion.Identifier {}



/// An extension to a semantic version. Currently, only pre-release and build extensions are supported.
public protocol SemanticVersionExtension: SemanticVersion.Identifier, CustomStringConvertible,
        ExpressibleByArrayLiteral, ExpressibleByIntegerLiteral, ExpressibleByStringLiteral, Comparable {
    
    /// A piece of the extension. For instance, in the pre-release extension `RC.1`, the identifiers are `RC` and `1`.
    typealias Identifier = String
    
    /// All idenntifiers in this extension
    var identifiers: [Identifier] { get }
    
    /// The character that precedes this extension when it appears in a SemVer.
    /// For example, the `-` in `1.0-RC.1`, or the + in `1.0+123`.
    static var prefix: Character { get }
    
    /// Creates a new SemVer extension with the given identifiers
    ///
    /// - Parameter identifiers: All identifiers of this extension
    init(identifiers: [Identifier])
}



public extension SemanticVersion {
    
    /// Indicates whether this version number implies an _initial_ development build, which could change ay any time.
    /// If this returns `true`, the build may change drastically at any time and must not be considered stable.
    ///
    /// https://semver.org/spec/v2.0.0.html#spec-item-4
    public var isInitialDevelopment: Bool {
        return major == 0
    }
    
    
    /// Indicates whether this version number implies a public build. If this returns `true`, changes to the version
    /// number will accurately reflect changes to the build.
    ///
    /// https://semver.org/spec/v2.0.0.html#spec-item-5
    public var isPublic: Bool {
        return major > 0
    }
}



extension SemanticVersion: CustomStringConvertible {
    
    /// A regular expression which matches and convenienctly groups all Semantic Version strings
    public static let regex = try! NSRegularExpression(pattern:
        "^(?<major>\\d+)\\." +
        "(?<minor>\\d+)" +
        "(?:\\.(?<patch>\\d+))?" +
        "(?:-(?<preRelease>(?:(?<preReleaseId>[0-9A-Za-z-]+)\\.?)+))?" +
        "(?:\\+(?<build>(?:(?<buildId>[0-9A-Za-z-]+)\\.?)+))?$",
                                                       options: .caseInsensitive)
    
    
    /// If possible, this creates a new `SemanticVersion` out of the given string. As long as the given string conforms
    /// to SemVer 2.0.0, this will succeed. If it does not, this will return `nil`.
    public init?(_ stringValue: String) {
        let matches = SemVer.regex.matches(in: stringValue, options: [], range: NSRange(location: 0, length: stringValue.count))
        if #available(OSX 10.13, *) {
            guard
                !matches.isEmpty,
                let major = matches[0].group("major", in: stringValue).flatMap({ Major($0) }),
                let minor = matches[0].group("minor", in: stringValue).flatMap({ Minor($0) })
                else {
                    return nil
            }
            
            self.major = major
            self.minor = minor
            self.patch = matches[0].group("patch", in: stringValue).flatMap { Patch($0) }
            
            self.preRelease = matches[0].group("preRelease", in: stringValue).flatMap { PreRelease($0) }
            self.build = matches[0].group("build", in: stringValue).flatMap { Build($0) }
        }
        else { // FIXME: Remove ASAP
            guard
                !matches.isEmpty,
                let major = matches[0].group(1, in: stringValue).flatMap({ Major($0) }),
                let minor = matches[0].group(2, in: stringValue).flatMap({ Minor($0) })
                else {
                    return nil
            }
            
            self.major = major
            self.minor = minor
            self.patch = matches[0].group(3, in: stringValue).flatMap { Patch($0) }
            
            self.preRelease = matches[0].group(4, in: stringValue).flatMap { PreRelease($0) }
            self.build = matches[0].group(6, in: stringValue).flatMap { Build($0) }
        }
    }
    
    
    /// The standard String form of a semantic version
    public var description: String {
        return concat("\(major).\(minor)",
            (patch.map { ".\($0)" } ?? ""),
            (preRelease.map { $0.descriptionWithPrefix } ?? ""),
            (build.map { $0.descriptionWithPrefix } ?? "")
        )
    }
}



extension SemanticVersion: Comparable {
    
    /// All of the fields of this `SemanticVersion` that should be used for comparison,
    /// in order so that the first one takes the highest precedence
    public var orderedComparableIdentifiers: [Identifier] {
        var orderedComparableFields: [Identifier] = [major, minor]
        if let patch = patch {
            orderedComparableFields.append(patch)
        }
        if let preRelease = preRelease {
            orderedComparableFields.append(preRelease)
        }
        return orderedComparableFields
    }
    
    
    /// Implements Semantic Version precedence
    ///
    /// https://semver.org/spec/v2.0.0.html#spec-item-11
    ///
    /// - Parameters:
    ///   - lhs: The first semantic version to compare
    ///   - rhs: The second semantic version to compare
    /// - Returns: `true` iff the left has lower precedence than the right
    public static func <(lhs: SemanticVersion, rhs: SemanticVersion) -> Bool {
        if lhs.major < rhs.major
            || lhs.minor < rhs.minor
            || isAscending(lhs.patch, rhs.patch, isLessThanNil: { $0 < 0 }) {
            return true
        }
        
        if let lhsPreRelease = lhs.preRelease {
            if let rhsPreRelease = rhs.preRelease {
                return lhsPreRelease < rhsPreRelease
            }
            else {
                return true
            }
        }
        else {
            return false
        }
    }
    
    
    public static func ==(lhs: SemanticVersion, rhs: SemanticVersion) -> Bool {
        return lhs.major == rhs.major
            && lhs.minor == rhs.minor
            && isEquivalent(lhs.patch, rhs.patch, isEquivalentToNil: { $0 == 0 })
            && isEquivalent(lhs.preRelease, rhs.preRelease, isEquivalentToNil: { $0 == "" })
    }
}



public struct SemanticVersionPreRelease: SemanticVersion.Extension {

    public static let prefix: Character = "-"
    
    public var identifiers: [Identifier]
    
    
    public init(identifiers: [Identifier]) {
        self.identifiers = identifiers
    }
}



public struct SemanticVersionBuild: SemanticVersion.Extension {
    
    public static let prefix: Character = "+"
    
    public var identifiers: [Identifier]
    
    
    public init(identifiers: [Identifier]) {
        self.identifiers = identifiers
    }
}



public extension SemanticVersion.Extension {
    
    public typealias PreRelease = SemanticVersionPreRelease
    public typealias Build = SemanticVersionBuild
    
    
    
    public var description: String {
        return identifiers.joined(separator: ".")
    }
    public var descriptionWithPrefix: String {
        return "\(type(of: self).prefix)\(description)"
    }
    
    
    public init(identifiers: [CustomStringConvertible]) {
        self.init(identifiers: identifiers.map { $0.description })
    }
    
    
    public init(_ rawString: Substring) {
        self.init(identifiers: rawString.split(separator: ".").map { String($0) })
    }
    
    
    public init(_ rawString: String) {
        self.init(identifiers: rawString.split(separator: ".").map { String($0) })
    }
    
    
    public init(_ identifiers: CustomStringConvertible...) {
        self.init(identifiers: identifiers)
    }
    
    
    public init(arrayLiteral elements: CustomStringConvertible...) {
        self.init(identifiers: elements)
    }
    
    
    public init(integerLiteral value: UInt) {
        self.init(value)
    }
    
    
    public init(stringLiteral value: String) {
        self.init(value)
    }
}



public extension SemanticVersion.Extension {
    
    public static func <(lhs: Self, rhs: Self) -> Bool {
        return compare(lhs: lhs, rhs: rhs) == .orderedAscending
    }
    
    
    public static func compare(lhs: Self, rhs: Self) -> ComparisonResult {
        
        if lhs == rhs {
            return .orderedSame
        }
        
        let (lhsIds, rhsIds) = (lhs.identifiers, rhs.identifiers)
        
        let zipped = lhsIds.zip(with: rhsIds)
        
        for (lhsId, rhsId) in zipped {
            if let lhsInt = UInt(lhsId) {
                if let rhsInt = UInt(rhsId) { // Both LHS and RHS are ints; compare them normally
                    let comparisonResult = lhsInt.compare(to: rhsInt)
                    switch comparisonResult {
                    case .orderedSame: continue // no difference found; keep looking until we find one
                    case .orderedAscending, .orderedDescending: return comparisonResult
                    }
                }
                else { // LHS is UInt, RHS is not; LHS < RHS
                    return .rhsHasPrecedence // Numeric identifiers have lower precedence
                }
            }
            else { // LHS is not UInt
                switch UInt(rhsId) == nil {
                case true: // Neither LHS nor RHS are UInt
                    if lhsId == rhsId {
                        continue // If both are the same, don't use this identifier to decide precedence
                    }
                    else {
                        let comparisonResult = lhsId.compare(rhsId)
                        switch comparisonResult {
                        case .orderedSame: continue
                        case .orderedAscending, .orderedDescending: return comparisonResult
                        }
                    }
                    
                case false: return .lhsHasPrecedence // LHS is not UInt, RHS is; LHS > RHS; Numeric identifiers have lower precedence
                }
            }
        }
        
        // If we got here, all items are equal, so the only unequal items must be those in a longer identifier list
        
        // Longer identifier lists have higher precedence
        
        return lhsIds.count.compare(to: rhsIds.count)
    }
    
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        let (lhsIds, rhsIds) = (lhs.identifiers, rhs.identifiers)
        return lhsIds.count == rhsIds.count && !lhsIds.zip(with: rhsIds).contains(where: { $0.0 != $0.1 })
    }
}



private extension NSTextCheckingResult {
    
    func group(_ groupIndex: Int, in string: String) -> Substring? {
        guard let range = self.range(at: groupIndex).orNil else {
            return nil
        }
        return _group(range: range, in: string)
    }
    
    @available(macOS 10.13, iOS 11, tvOS 11, watchOS 4, *)
    func group(_ groupName: String, in string: String) -> Substring? {
        guard let range = self.range(withName: groupName).orNil else {
            return nil
        }
        return _group(range: range, in: string)
    }
    
    
    private func _group(range: NSRange, in string: String) -> Substring? {
        let startingIndex = string.index(string.startIndex, offsetBy: range.location)
        let endingIndex = string.index(startingIndex, offsetBy: range.length)
        return string[startingIndex..<endingIndex]
    }
}
