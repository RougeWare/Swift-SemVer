//
//  Semantic Version + PreRelease.swift
//  SemVer
//
//  Created by Ky on 2026-10-23.
//

import Foundation


/// The PRE-RELEASE extension; this identifies versions that are available before being declared stable.
///
/// Identifiers MUST comprise only ASCII alphanumerics and hyphen `[0-9A-Za-z-]`.
/// Identifiers MUST NOT be empty.
/// Numeric identifiers MUST NOT include leading zeroes.
/// Pre-release versions have a lower precedence than the associated normal version.
/// A pre-release version indicates that the version is unstable and might not satisfy the intended compatibility
/// requirements as denoted by its associated normal version.
public struct SemanticVersionPreRelease: SemanticVersion.Extension {
    
    public typealias CharacterRestrictions = PreReleaseCharacters
    
    
    
    public static let prefix: Character = "-"
    
    public var identifiers: [Identifier]
    
    
    public init(identifiers: [Identifier]) {
        self.identifiers = identifiers
    }
    
    
    public static func compare(lhs: SemanticVersionPreRelease, rhs: SemanticVersionPreRelease) -> ComparisonResult {
        
        //                                       https://semver.org/#spec-item-11
        //
        // Precedence for two pre-release versions with the same major, minor, and patch version MUST be determined by
        // comparing each dot separated identifier from left to right until a difference is found as follows:
        //     1. Identifiers consisting of only digits are compared numerically.
        //     2. Identifiers with letters or hyphens are compared lexically in ASCII sort order.
        //     3. Numeric identifiers always have lower precedence than non-numeric identifiers.
        //     4. A larger set of pre-release fields has a higher precedence than a smaller set, if all of the
        //        preceding identifiers are equal.
        
        let (lhsIds, rhsIds) = (lhs.identifiers, rhs.identifiers)
        
        let zipped = lhsIds.zip(with: rhsIds)
        
        for (lhsId, rhsId) in zipped {
            if let lhsInt = UInt(lhsId) { // LHS is an integer
                if let rhsInt = UInt(rhsId) { // Both LHS and RHS are ints; compare them numerically
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
                        let comparisonResult = lhsId.compare(to: rhsId)
                        switch comparisonResult {
                        case .orderedSame: continue
                        case .orderedAscending, .orderedDescending: return comparisonResult
                        }
                    }
                }
                else { // LHS is not UInt, RHS is; LHS > RHS
                    return .lhsHasPrecedence // Numeric identifiers have lower precedence
                }
            }
        }
        
        // If we got here, all preceding identifiers are equal, so a larger set of pre-release fields has a higher
        // precedence than a smaller set
        return lhsIds.count.compare(to: rhsIds.count)
    }
}
