//
//  Semantic Version + Comparable.swift
//  SemVer
//
//  Created by Ky Leggiero on 2021-10-25.
//  Copyright © 2021 Ben "Ky" Leggiero BH-1-PS.
//

import Foundation



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
    
    
    /// Compares this semantic version to the other, ignoring the given set of identifiers
    ///
    /// - Parameters:
    ///   - other:    The other version to compare this one against
    ///   - ignoring: The identifiers of each version to be ignored in this comparison
    ///
    /// - Returns: `true` iff this and the given versions match when ignoring the specified identifiers
    public func matches(_ other: SemVer, ignoring ignoredIdentifiers: IgnorableIdentifiers) -> Bool {
        self.removing(ignoredIdentifiers)
            == other.removing(ignoredIdentifiers)
    }
    
    
    
    /// Returns a copy of this version where the specified identifiers are removed or set to `0`
    ///
    /// - Parameter ignoredIdentifiers: The identifiers to remove or set to `0`
    /// - Returns: A copy of this version without the specified identifiers
    private func removing(_ ignoredIdentifiers: IgnorableIdentifiers) -> Self {
        var copy = self
        
        switch ignoredIdentifiers {
        case .minorAndPatchAndPreRelease:
            copy._minor = 0
            fallthrough
            
        case .patchAndPreRelease:
            copy._patch = 0
            fallthrough
            
        case .preRelease:
            copy.preRelease = nil
        }
        
        return copy
    }
    
    
    
    /// An identifier which can be ignored
    public enum IgnorableIdentifiers {
        
        /// Ignore the pre-release identifier (treat `1.2.3-Beta` as equal to `1.2.3`)
        case preRelease
        
        /// Ignore the patch and pre-release identifiers (treat `1.2.3` as equal to `1.2.99`; treat `1.2.3-Beta` as equal to `1.2.0`)
        case patchAndPreRelease
        
        /// Ignore the minor, patch, and pre-release identifiers (treat `1.2.3` as equal to `1.99.42`; treat `1.2.3` as equal to `1.2.99`; treat `1.2.3-Beta` as equal to `1.2.0`)
        case minorAndPatchAndPreRelease
    }
}
