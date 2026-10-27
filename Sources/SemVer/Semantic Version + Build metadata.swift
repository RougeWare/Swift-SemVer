//
//  Semantic Version + Build metadata.swift
//  SemVer
//
//  Created by Ky on 2026-10-23.
//

import Foundation



/// The BUILD metadata; this identifies some information about a particular build of a version, and is not
/// considered for equivalence nor precedence.
///
/// Identifiers MUST comprise only ASCII alphanumerics and hyphen `[0-9A-Za-z-]`.
/// Identifiers MUST NOT be empty.
/// Build metadata MUST be ignored when determining version precedence.
/// Thus two versions that differ only in the build metadata, have the same precedence.
public struct SemanticVersionBuild: SemanticVersion.Extension {
    
    public typealias CharacterRestrictions = OnlyAlphanumerics
    
    
    
    public static let prefix: Character = "+"
    public static let name = "build"
    
    public var identifiers: [Identifier]
    
    
    public init(identifiers: [Identifier]) {
        self.identifiers = identifiers
    }
    
    
    
    /// Build metadata is not supposed to be compared, so this always returns `.orderedSame`
    @available(*, deprecated, message: "Build metadata is not supposed to be compared, so this always returns `.orderedSame`")
    public static func compare(lhs: SemanticVersionBuild, rhs: SemanticVersionBuild) -> ComparisonResult {
        .orderedSame
    }
}
