//
//  Semantic Version.swift
//  SemVer
//
//  Created by Ben Leggiero on 2018-01-09.
//  Copyright © 2021 Ben Leggiero BH-1-PS.
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
/// For instance, `SemVer(1,2,0, SemVer.Build(identifiers: ["123", "4"]))` has the same result as
/// `SemVer(1,2,0, "123.4")` and `SemVer(1,2,0, [123,4])`. Again, this is done for ease-of-use. `SemVer` itself would
/// also be expressible by a string literal, but it has too many resrictions so a failable initializer is presented
/// instead.
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
    
    
    /// Holds the raw, unmanaged value for `major`
    private var _major: Major
    
    /// Holds the raw, unmanaged value for `minor`
    private var _minor: Minor
    
    /// Holds the raw, unmanaged value for `patch`
    private var _patch: Patch
    
    
    /// The MAJOR version; increment this when you make incompatible API changes.
    ///
    /// This MUST be incremented if any backwards incompatible changes are introduced to the public API.
    /// This MAY include minor and patch level changes.
    /// Patch and minor version MUST be reset to `0` when major version is incremented. This is done automatically if
    /// you set this variable.
    ///
    /// This MUST increase numerically. For instance: 1.9.0 ➡️ 2.0.0 ➡️ 3.0.0.
    ///
    /// https://semver.org/spec/v2.0.0.html#spec-item-8
    ///
    /// - Attention: Increasing this immediately sets `minor` and `patch` to `0`.
    /// - Note: If this is `0`, then further rules don't apply.
    public var major: Major {
        set {
            if newValue < _major {
                assertionFailure(
                    """
                    Major version number was decremented (went from \(_major) to \(newValue))!
                    In production builds, this will result in the Major version number not changing.
                    """)
            }
            else {
                if newValue > _major {
                    _minor = 0
                    _patch = 0
                }
                
                _major = newValue
            }
        }
        
        get { _major }
    }
    
    /// The MINOR version; increment this when you add functionality in a backwards-compatible manner.
    ///
    /// This MUST be incremented if new, backwards compatible functionality is introduced to the public API.
    /// This MUST be incremented if any public API functionality is marked as deprecated.
    /// This MAY be incremented if substantial new functionality or improvements are introduced within the private code.
    /// This MAY include patch level changes.
    /// Patch version MUST be reset to `0` when minor version is incremented. This is done automatically if you set
    /// this variable.
    ///
    /// This MUST increase numerically. For instance: 1.9.0 ➡️ 1.10.0 ➡️ 1.11.0.
    ///
    /// https://semver.org/spec/v2.0.0.html#spec-item-7
    ///
    /// - Attention: Increasing this immediately sets `patch` to `0`.
    public var minor: Minor {
        set {
            if newValue < _minor {
                assertionFailure(
                    """
                    Minor version number was decremented (went from \(_minor) to \(newValue))!
                    In production builds, this will result in the Minor version number not changing.
                    """)
            }
            else {
                if newValue > _minor {
                    _patch = 0
                }
                
                _minor = newValue
            }
        }
        
        get { _minor }
    }
    
    /// The PATCH version; increment this when you make backwards compatible bug fixes.
    ///
    /// This MUST be incremented if only backwards compatible bug fixes are introduced. A bug fix is defined as an
    /// internal change that fixes incorrect behavior
    ///
    /// This MUST increase numerically. For instance: 1.0.9.➡️ 1.0.10 ➡️ 1.0.11.
    ///
    /// https://semver.org/spec/v2.0.0.html#spec-item-6
    public var patch: Patch {
        set {
            if newValue < _patch {
                assertionFailure(
                    """
                    Patch version number was decremented (went from \(_patch) to \(newValue))!
                    In production builds, this will result in the Patch version number not changing.
                    """)
            }
            else {
                _patch = newValue
            }
        }
        
        get { _patch }
    }
    
    /// The PRE-RELEASE extension; this identifies versions that are available before being declared stable.
    ///
    /// Identifiers MUST comprise only ASCII alphanumerics and hyphen `[0-9A-Za-z-]`.
    /// Identifiers MUST NOT be empty.
    /// Numeric identifiers MUST NOT include leading zeroes.
    /// Pre-release versions have a lower precedence than the associated normal version.
    /// A pre-release version indicates that the version is unstable and might not satisfy the intended compatibility
    /// requirements as denoted by its associated normal version.
    public var preRelease: PreRelease? {
        didSet {
            if !isValid {
                assertionFailure(
                    """
                    Pre-Release extension set to an invalid value (\(preRelease ?? "nil"))!
                    In production builds, this will result in the Pre-Release extension being reset to its previous value.
                    """)
                
                preRelease = oldValue
            }
        }
    }
    
    /// The BUILD metadata; this identifies some information about a particular build of a version, and is not
    /// considered for equivalence nor precedence.
    ///
    /// Identifiers MUST comprise only ASCII alphanumerics and hyphen `[0-9A-Za-z-]`.
    /// Identifiers MUST NOT be empty.
    /// Build metadata MUST be ignored when determining version precedence.
    /// Thus two versions that differ only in the build metadata, have the same precedence.
    public var build: Build? {
        didSet {
            if !isValid {
                assertionFailure(
                    """
                    Build extension set to an invalid value (\(build ?? "nil"))!
                    In production builds, this will result in the Build extension being reset to its previous value.
                    """)
                
                build = oldValue
            }
        }
    }
    
    
    /// Create a new Semantic Version without checking the validity of any of the pieces
    /// - Parameter unchecked: All the semantic version values, without checking their validity
    private init(unchecked: (major: Major, minor: Minor, patch: Patch, preRelease: PreRelease?, build: Build?)) {
        self._major = unchecked.major
        self._minor = unchecked.minor
        self._patch = unchecked.patch
        self.preRelease = unchecked.preRelease
        self.build = unchecked.build
    }
    
    
    /// Create a new Semantic Version with explicit parts. This returns `nil` if the given parts would create an invalid regex, like `1.02.3`
    ///
    /// - Parameters:
    ///   - major:      The MAJOR version
    ///   - minor:      The MINOR version
    ///   - patch:      The PATCH version
    ///   - preRelease: Indicates some specific information about a pre-release build, like `RC.1`
    ///   - build:      The build number, like `123` or `exp.sha.5114f85` or `2018.01.14.00.01`
    public init?(major: Major, minor: Minor, patch: Patch, preRelease: PreRelease? = nil, build: Build? = nil) {
        self.init(unchecked: (major: major,
                              minor: minor,
                              patch: patch,
                              preRelease: preRelease,
                              build: build))
        
        guard isValid else { return nil }
    }
    
    
    /// Create a new Semantic Version with explicit (yet unlabelled) parts. This returns `nil` if the given parts would create an invalid SemVer, like `1.02.3`
    ///
    /// - Parameters:
    ///   - major:      The MAJOR version
    ///   - minor:      The MINOR version
    ///   - patch:      The PATCH version
    ///   - preRelease: Indicates some specific information about a pre-release build, like `RC.1`
    ///   - build:      The build number, like `123` or `exp.sha.5114f85` or `2018.01.14.00.01`
    public init?(_ major: Major, _ minor: Minor, _ patch: Patch, preRelease: PreRelease? = nil, build: Build? = nil) {
        self.init(major: major, minor: minor, patch: patch, preRelease: preRelease, build: build)
    }
    
    
    /// Create a new simple Semantic Version with explicit parts and no extensions.
    ///
    /// This always succeeds, unlike the more-freeform initializers, since it's guaranteed to be correct at compile-time. If you need to set the Pre-Release andor Build extension, you must use one of the failable initializers.
    ///
    /// - Parameters:
    ///   - major:      The MAJOR version
    ///   - minor:      The MINOR version
    ///   - patch:      The PATCH version
    public init(major: UInt, minor: UInt, patch: UInt) {
        self.init(unchecked: (major: major,
                              minor: minor,
                              patch: patch,
                              preRelease: nil,
                              build: nil))
    }
    
    
    /// Create a new simple Semantic Version with explicit (yet unlabelled) parts and no extensions.
    ///
    /// This always succeeds, unlike the more-freeform initializers, since it's guaranteed to be correct at compile-time. If you need to set the Pre-Release andor Build extension, you must use one of the failable initializers.
    ///
    /// - Parameters:
    ///   - major:      The MAJOR version
    ///   - minor:      The MINOR version
    ///   - patch:      The PATCH version
    public init(_ major: UInt, _ minor: UInt, _ patch: UInt) {
        self.init(unchecked: (major: major,
                              minor: minor,
                              patch: patch,
                              preRelease: nil,
                              build: nil))
    }
}



private extension SemVer {
    
    /// Determines whether this semantic version is valid
    ///
    /// - Note: This must remain `private`, since the whole point of this package is that it facilitates valid semantic versions
    var isValid: Bool {
        let stringForm = description
        return Self.regex.numberOfMatches(in: stringForm, options: [], range: NSRange(location: 0, length: stringForm.count)) > 0
    }
}



/// A single piece of a semantic version, like `minor` or `build`
public protocol SemanticVersionIdentifier {}



extension UInt: SemanticVersion.Identifier {}



/// An extension to a semantic version. Currently, only pre-release and build extensions are supported.
public protocol SemanticVersionExtension:
    SemanticVersion.Identifier,
    CustomStringConvertible,
    ExpressibleByArrayLiteral,
    ExpressibleByIntegerLiteral,
    ExpressibleByStringLiteral,
    Comparable
{
    /// A piece of the extension. For instance, in the pre-release extension `RC.1`, the identifiers are `RC` and `1`.
    typealias Identifier = String
    
    /// All idenntifiers in this extension
    var identifiers: [Identifier] { get }
    
    /// The character that precedes this extension when it appears in a SemVer.
    /// For example, the `-` in `1.0.0-RC.1`, or the + in `1.0.0+123`.
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
    var isInitialDevelopment: Bool {
        return major == 0
    }
    
    
    /// Indicates whether this version number implies a public build. If this returns `true`, changes to the version
    /// number will accurately reflect changes to the build.
    ///
    /// https://semver.org/spec/v2.0.0.html#spec-item-5
    var isPublic: Bool {
        return major > 0
    }
}



extension SemanticVersion: LosslessStringConvertible {
    
    /// A purely-numeric identifier for the `regex` which matches semantic versions
    private static let regex_numericIdentifier    = #"(?:0|[1-9]\d*)"#
    
    /// A pre-release identifier for the `regex` which matches semantic versions
    private static let regex_preReleaseIdentifier = #"(?:0|[1-9A-Za-z-][0-9A-Za-z-]*)"#
    
    /// A build identifier for the `regex` which matches semantic versions
    private static let regex_buildIdentifier      =                  #"[0-9A-Za-z-]*"#
    
    
    /// Builds a version identifier (major/minor/patch)
    /// - Parameter name: The name of the identifier, like `patch`
    @inline(__always)
    private static func regex_versionIdentifier(_ name: String) -> String {
        "(?<\(name)>\(regex_numericIdentifier))"
    }
    
    
    /// Builds a SemVer extension (pre-release / build)
    /// - Parameters:
    ///   - delimiter: The delimiter which distinguishes this extension, like `-` or `\+`
    ///   - name:      The name of this extension, like `preRelease` or `build`
    ///   - id:        The pattern to insert into the regex for each identifier in this extension
    @inline(__always)
    private static func regex_extension(_ delimiter: String, _ name: String, id: String) -> String {
        #"(?:\#(delimiter)(?<\#(name)>\#(id)(?:\.\#(id))*))?"#
    }
    
    
    /// A regular expression which matches and conveniently groups all Semantic Version strings
    public static let regex = try! NSRegularExpression(
        pattern: "^" +
        regex_versionIdentifier("major") + #"\."# +
        regex_versionIdentifier("minor") + #"\."# +
             regex_versionIdentifier("patch") +
        regex_extension("-", "preRelease", id: regex_preReleaseIdentifier) +
        regex_extension(#"\+"#, "build", id: regex_buildIdentifier) +
        "$",
        options: [])
    
    
    /// If possible, this creates a new `SemanticVersion` out of the given string. As long as the given string conforms
    /// to SemVer 2.0.0, this will succeed. If it does not, this will return `nil`.
    public init?(_ stringValue: String) {
        let matches = SemVer.regex.matches(in: stringValue, options: [], range: NSRange(location: 0, length: stringValue.count))
        if #available(macOS 10.13, iOS 11, tvOS 11, watchOS 4, *) {
            guard
                !matches.isEmpty,
                let major = matches[0].group("major", in: stringValue).flatMap({ Major($0) }),
                let minor = matches[0].group("minor", in: stringValue).flatMap({ Minor($0) }),
                let patch = matches[0].group("patch", in: stringValue).flatMap({ Patch($0) })
                else
            {
                return nil
            }
            
            self.init(unchecked: (
                major: major,
                minor: minor,
                patch: patch,
                
                preRelease: matches[0].group("preRelease", in: stringValue).flatMap { PreRelease($0) },
                build: matches[0].group("build", in: stringValue).flatMap { Build($0) })
            )
        }
        else { // FIXME: Remove ASAP
            guard
                !matches.isEmpty,
                let major = matches[0].group(1, in: stringValue).flatMap({ Major($0) }),
                let minor = matches[0].group(2, in: stringValue).flatMap({ Minor($0) }),
                let patch = matches[0].group(3, in: stringValue).flatMap({ Patch($0) })
                else
            {
                return nil
            }
            
            self.init(unchecked: (
                major: major,
                minor: minor,
                patch: patch,
                
                preRelease: matches[0].group(4, in: stringValue).flatMap { PreRelease($0) },
                build: matches[0].group(6, in: stringValue).flatMap { Build($0) })
            )
        }
    }
    
    
    /// The standard String form of a semantic version
    public var description: String {
        return concat("\(major).\(minor).\(patch)",
            (preRelease.map { $0.descriptionWithPrefix } ?? ""),
            (build.map { $0.descriptionWithPrefix } ?? "")
        )
    }
}



extension SemanticVersion: Comparable {
    
    /// All of the fields of this `SemanticVersion` that should be used for comparison,
    /// in order so that the first one takes the highest precedence
    public var orderedComparableIdentifiers: [Identifier] {
        var orderedComparableFields: [Identifier] = [major, minor, patch]
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
    ///
    /// - Returns: `true` iff the left has lower precedence than the right
    public static func <(lhs: SemanticVersion, rhs: SemanticVersion) -> Bool {
        if lhs.major < rhs.major
            || (lhs.major == rhs.major && lhs.minor < rhs.minor)
            || (lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch < rhs.patch)
        {
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
    
    
    /// Determines whether the given two semantic versions are equivalent. Equivalence is implied by the precedence
    /// rules laid out in SemVer 2.0.0 paragraph 11: https://semver.org/spec/v2.0.0.html#spec-item-11
    ///
    /// Remember that build metadata does not factor into equality. For example, `"1.2.3+45" == "1.2.3+67"`.
    ///
    /// - Parameters:
    ///   - lhs: The first version to compare
    ///   - rhs: The second version to compare
    ///
    /// - Returns: `true` if the two versions are equivalent
    public static func ==(lhs: SemanticVersion, rhs: SemanticVersion) -> Bool {
        return lhs.major == rhs.major
            && lhs.minor == rhs.minor
            && lhs.patch == rhs.patch
            && isEquivalent(lhs.preRelease, rhs.preRelease, isEquivalentToNil: { $0 == "" })
        // According to https://semver.org/spec/v2.0.0.html#spec-item-11, "Build metadata does not figure into precedence"
    }
}



/// The PRE-RELEASE extension; this identifies versions that are available before being declared stable.
///
/// Identifiers MUST comprise only ASCII alphanumerics and hyphen `[0-9A-Za-z-]`.
/// Identifiers MUST NOT be empty.
/// Numeric identifiers MUST NOT include leading zeroes.
/// Pre-release versions have a lower precedence than the associated normal version.
/// A pre-release version indicates that the version is unstable and might not satisfy the intended compatibility
/// requirements as denoted by its associated normal version.
public struct SemanticVersionPreRelease: SemanticVersion.Extension {
    
    public static let prefix: Character = "-"
    
    public var identifiers: [Identifier]
    
    
    public init(identifiers: [Identifier]) {
        self.identifiers = identifiers
    }
}



/// The BUILD metadata; this identifies some information about a particular build of a version, and is not
/// considered for equivalence nor precedence.
///
/// Identifiers MUST comprise only ASCII alphanumerics and hyphen `[0-9A-Za-z-]`.
/// Identifiers MUST NOT be empty.
/// Build metadata MUST be ignored when determining version precedence.
/// Thus two versions that differ only in the build metadata, have the same precedence.
public struct SemanticVersionBuild: SemanticVersion.Extension {
    
    public static let prefix: Character = "+"
    
    public var identifiers: [Identifier]
    
    
    public init(identifiers: [Identifier]) {
        self.identifiers = identifiers
    }
}



public extension SemanticVersion.Extension {
    
    typealias PreRelease = SemanticVersionPreRelease
    typealias Build = SemanticVersionBuild
    
    
    
    /// Creates a string of period-separated identifiers, so `["public", "RC", 1]` would become `"public.RC.1"`
    var description: String {
        return identifiers.joined(separator: ".")
    }
    
    
    /// Creates a string suitable for naïve concatenation with a semantic version string.
    /// For example, a pre-release extension like `["RC", 1]` would become `"-RC.1"`, and a build like
    /// `["2018", "01", "15"]` would become `"+2018.01.15"`.
    var descriptionWithPrefix: String {
        return "\(type(of: self).prefix)\(description)"
    }
    
    
    /// Creates a new extension by converting the given array into an array of strings
    ///
    /// - Parameter identifiers: Soon-to-be identifiers
    init(identifiers: [CustomStringConvertible]) {
        self.init(identifiers: identifiers.map { $0.description })
    }
    
    
    /// Creates a new extension by separating the given raw string by any periods in it
    ///
    /// - Parameter rawString: A raw representation of a semantic version string.
    ///                        This should match the regex `/^[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*$/`.
    init(_ rawString: Substring) {
        self.init(identifiers: rawString.split(separator: ".").map { String($0) })
    }
    
    
    /// Creates a new extension by separating the given raw string by any periods in it
    ///
    /// - Parameter rawString: A raw representation of a semantic version string.
    ///                        This should match the regex `/^[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*$/`.
    init(_ rawString: String) {
        self.init(identifiers: rawString.split(separator: ".").map { String($0) })
    }
    
    
    /// Creates a new extension by converting the given varargs into an array of strings
    ///
    /// - Parameter identifiers: Soon-to-be identifiers
    init(_ identifiers: CustomStringConvertible...) {
        self.init(identifiers: identifiers)
    }
    
    
    /// Creates a new extension by converting the given array/varargs into an array of strings
    ///
    /// - Parameter identifiers: Soon-to-be identifiers
    init(arrayLiteral elements: CustomStringConvertible...) {
        self.init(identifiers: elements)
    }
    
    
    /// Creates a new extension by converting the given integer into a string and assuming that is the only identifier
    ///
    /// - Parameter value: The only identifier, to become a string
    init(integerLiteral value: UInt) {
        self.init(identifiers: [value])
    }
    
    
    /// Creates a new extension by separating the given raw string by any periods in it
    ///
    /// - Parameter rawString: A raw representation of a semantic version string.
    ///                        This should match the regex `/^[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*$/`.
    init(stringLiteral value: String) {
        self.init(value)
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
        return compare(lhs: lhs, rhs: rhs) == .orderedAscending
    }
    
    
    /// Compares two SemVer extensions and returns the determined order. This attempts to exactly match the
    /// behavior described in the SemVer 2.0.0 spec paragraph 11: https://semver.org/spec/v2.0.0.html#spec-item-11
    ///
    /// - Parameters:
    ///   - lhs: The first extension to compare
    ///   - rhs: The second extension to compare
    ///
    /// - Returns: The order of the extensions
    static func compare(lhs: Self, rhs: Self) -> ComparisonResult {
        
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
                if nil == UInt(rhsId) {
                    // Neither LHS nor RHS are UInt
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
                }
                else {
                    return .lhsHasPrecedence // LHS is not UInt, RHS is; LHS > RHS; Numeric identifiers have lower precedence
                }
            }
        }
        
        // If we got here, all items are equal, so the only unequal items must be those in a longer identifier list.
        // Longer identifier lists have higher precedence.
        return lhsIds.count.compare(to: rhsIds.count)
    }
    
    
    /// Determines whether one SemVer 2.0.0 extension is equal to another
    ///
    /// - Parameters:
    ///   - lhs: One extension
    ///   - rhs: Another extension
    ///
    /// - Returns: `true` iff the given two extensions are equal
    static func ==(lhs: Self, rhs: Self) -> Bool {
        let (lhsIdentifiers, rhsIdenditifers) = (lhs.identifiers, rhs.identifiers)
        return lhsIdentifiers.count == rhsIdenditifers.count
            && !lhsIdentifiers.zip(with: rhsIdenditifers).contains(where: !=)
    }
}



// #3: https://github.com/RougeWare/Swift-SemVer/issues/3
private extension NSTextCheckingResult {
    
    /// Finds the group located at the given index in this text checking result, within the given string
    ///
    /// - Parameters:
    ///   - groupIndex: The index of the group
    ///   - string:     The string to search
    ///
    /// - Returns: The substring at the given group index, or `nil` if there is none
    func group(_ groupIndex: Int, in string: String) -> Substring? {
        guard let range = self.range(at: groupIndex).orNil else {
            return nil
        }
        return _group(range: range, in: string)
    }
    
    /// Finds the group with the given name in this text checking result, within the given string
    ///
    /// - Parameters:
    ///   - groupName: The name of the group
    ///   - string:    The string to search
    ///
    /// - Returns: The substring at the given group index, or `nil` if there is none
    @available(macOS 10.13, iOS 11, tvOS 11, watchOS 4, *)
    func group(_ groupName: String, in string: String) -> Substring? {
        guard let range = self.range(withName: groupName).orNil else {
            return nil
        }
        return _group(range: range, in: string)
    }
    
    
    /// The base of the other `group(_:in:)` functions; simply returns the substring of the given string at the given
    /// range, iff that range is valid. If the range is invalid (e.g. if it's not inside the string or location is `NSNotFound`)
    ///
    /// - Parameters:
    ///   - range:  The range of characters to return
    ///   - string: The string to search
    ///
    /// - Returns: The substring at the given range, or `nil` if there is none
    private func _group(range: NSRange, in string: String) -> Substring? {
        guard range.location != NSNotFound else {
            return nil
        }
        let startingIndex = string.index(string.startIndex, offsetBy: range.location)
        let endingIndex = string.index(startingIndex, offsetBy: range.length)
        guard string.endIndex >= endingIndex else {
            return nil
        }
        return string[startingIndex..<endingIndex]
    }
}
