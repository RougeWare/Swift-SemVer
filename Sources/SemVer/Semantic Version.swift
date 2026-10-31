//
//  Semantic Version.swift
//  SemVer
//
//  Created by Ben Leggiero on 2018-01-09.
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
    public typealias Major = Identifier<OnlyDigits>
    public typealias Minor = Identifier<OnlyDigits>
    public typealias Patch = Identifier<OnlyDigits>
    public typealias Extension = SemanticVersionExtension
    public typealias PreRelease = Extension.PreRelease
    public typealias Build = Extension.Build
    
    
    /// Holds the raw, unmanaged value for `major`
    private var _major: Major
    
    /// Holds the raw, unmanaged value for `minor`
    internal var _minor: Minor
    
    /// Holds the raw, unmanaged value for `patch`
    internal var _patch: Patch
    
    
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
        self.init(unchecked: (major: .integer(major),
                              minor: .integer(minor),
                              patch: .integer(patch),
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
        self.init(unchecked: (major: .integer(major),
                              minor: .integer(minor),
                              patch: .integer(patch),
                              preRelease: nil,
                              build: nil))
    }
}



private extension SemanticVersion {
    
    /// Determines whether this semantic version is valid
    ///
    /// - Note: This must remain `private`, since the whole point of this package is that it facilitates valid semantic versions
    var isValid: Bool {
        let stringForm = description
        return nil != (try? Self.regex.wholeMatch(in: stringForm))
    }
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
    
    /// If possible, this creates a new `SemanticVersion` out of the given string. As long as the given string conforms
    /// to SemVer 2.0.0, this will succeed. If it does not, this will return `nil`.
    public init?(_ stringValue: String) {
        
        do {
            guard
                let match = try SemVer.regex.wholeMatch(in: stringValue),
                let major = Major.IntegerLiteralType(match[Regex.Captures.major]),
                let minor = Minor.IntegerLiteralType(match[Regex.Captures.minor]),
                let patch = Patch.IntegerLiteralType(match[Regex.Captures.patch])
            else {
                #if DEBUG
                print("Invalid semver: \(stringValue)")
                #endif
                return nil
            }
            
            let preRelease: PreRelease?
            let build: Build?
            
            if let preReleaseString = match[Regex.Captures.preRelease] {
                guard let parsedPreRelease = PreRelease(preReleaseString) else {
                    assertionFailure("""
                        PACKAGE MAINTAINER ERROR: Report this to https://github.com/RougeWare/Swift-SemVer/issues
                        If a string passes the SemVer regex, then it should be a valid regex. However, the `PreRelease` extension failed to parse what should be a valid SemVer pre-release extension.
                        Either both pass or both fail; mixed results indicates that one of these is incorrectly implemented.
                        
                        The whole SemVer: \(stringValue)
                        The pre-release extension: \(preReleaseString)
                        """)
                    return nil
                }
                
                preRelease = parsedPreRelease
            }
            else {
                preRelease = nil
            }
            
            if let buildString = match[Regex.Captures.build] {
                guard let parsedBuild = Build(buildString) else {
                    assertionFailure("""
                        PACKAGE MAINTAINER ERROR: Report this to https://github.com/RougeWare/Swift-SemVer/issues
                        If a string passes the SemVer regex, then it should be a valid regex. However, the `Build` extension failed to parse what should be a valid SemVer build metadata extension.
                        Either both pass or both fail; mixed results indicates that one of these is incorrectly implemented.
                        
                        The whole SemVer: \(stringValue)
                        The build extension: \(buildString)
                        """)
                    return nil
                }
                
                build = parsedBuild
            }
            else {
                build = nil
            }
            
            
            self.init(unchecked: (
                major: .integer(major),
                minor: .integer(minor),
                patch: .integer(patch),
                
                preRelease: preRelease,
                build: build
            ))
        }
        catch {
            #if DEBUG
            print("Invalid semver: \(stringValue)", error, separator: "\n")
            #endif
            return nil
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
