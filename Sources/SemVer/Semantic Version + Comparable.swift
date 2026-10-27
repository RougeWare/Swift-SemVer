//
//  Semantic Version + Comparable.swift
//  SemVer
//
//  Created by Ky Leggiero on 2021-10-25.
//

import Foundation



extension SemanticVersion: Comparable {
    
    /// All of the fields of this `SemanticVersion` that should be used for comparison,
    /// in order so that the first one takes the highest precedence
    public var orderedComparableIdentifiers: [AnyIdentifier] {
        var orderedComparableFields: [AnyIdentifier] = [.init(major.integerValue), .init(minor.integerValue), .init(patch.integerValue)]
        if let preRelease = preRelease {
            orderedComparableFields.append(contentsOf: preRelease.identifiers.compactMap(AnyIdentifier.init))
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
        .orderedAscending == lhs.compare(to: rhs)
    }
    
    
    public func compare(to rhs: Self) -> ComparisonResult {
        
        //                                       https://semver.org/#spec-item-11
        //
        // Precedence refers to how versions are compared to each other when ordered.
        // 1. Precedence MUST be calculated by separating the version into major, minor, patch and pre-release
        //    identifiers in that order (Build metadata does not figure into precedence).
        // 2. Precedence is determined by the first difference when comparing each of these identifiers from left to
        //    right as follows: Major, minor, and patch versions are always compared numerically.
        //    Example: 1.0.0 < 2.0.0 < 2.1.0 < 2.1.1.
        // 3. When major, minor, and patch are equal, a pre-release version has lower precedence than a normal version:
        //    Example: 1.0.0-alpha < 1.0.0.
        //
        // (pre-release precedence encoded in `Semantic Version + PreRelease.swift`)

        
        
        if self.major != rhs.major {
            // 1.0.0 < 2.0.0
            return self.major.compare(to: rhs.major)
        }
        else if self.minor != rhs.minor {
            // 1.2.0 < 1.3.0
            return self.minor.compare(to: rhs.minor)
        }
        else if self.patch != rhs.patch {
            // 1.2.3 < 1.2.4
            return self.patch.compare(to: rhs.patch)
        }
        else { // lhs Mmp == rhs Mmp
            if let self_preRelease = self.preRelease?.nonEmptyOrNil { // self has a pre-release extension
                if let rhs_preRelease = rhs.preRelease?.nonEmptyOrNil { // both have pre-release extensions
                    return self_preRelease.compare(to: rhs_preRelease)
                }
                else { // self has a pre-release but not rhs
                    return .rhsHasPrecedence
                }
            }
            else { // self has no pre-release extension
                if nil != rhs.preRelease { // rhs has a pre-release but not self
                    return .lhsHasPrecedence
                }
                else { // neither have a pre-release extension
                    // Checked everything except build metadata, which does not figure into precedence, so they're the same
                    return .orderedSame
                }
            }
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
        .orderedSame == lhs.compare(to: rhs)
    }
    
    
    /// Compares this semantic version to the other, ignoring the given set of identifiers
    ///
    /// - Parameters:
    ///   - other:    The other version to compare this one against
    ///   - ignoring: _optional_ - The identifiers of each version to be ignored in this comparison. If omitted, this will use an appropriate comparison for this and the given versions
    ///
    /// - Returns: `true` iff this and the given versions match when ignoring the specified identifiers
    public func matches(_ other: SemVer, ignoring ignoredIdentifiers: IgnorableIdentifiers) -> Bool {
        self.removing(ignoredIdentifiers)
            == other.removing(ignoredIdentifiers)
    }
    
    
    /// Compares this semantic version to the other, ignoring identifiers which are appropriate to ignore in this context
    ///
    /// - Parameters:
    ///   - other:    The other version to compare this one against
    ///   - ignoring: _optional_ - The identifiers of each version to be ignored in this comparison. If omitted, this will use an appropriate comparison for this and the given versions
    ///
    /// - Returns: `true` iff this and the given versions match when ignoring the appropriately-ignorable identifiers
    public func matches(_ other: SemVer) -> Bool {
        let ignoredIdentifiers: IgnorableIdentifiers =
            if self.isInitialDevelopment
                || other.isInitialDevelopment {
                .none
            }
            else {
                .minorAndPatchAndPreRelease
            }
        
        return matches(other, ignoring: ignoredIdentifiers)
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
            
        case .none:
            break
        }
        
        return copy
    }
    
    
    
    /// An identifier which can be ignored
    public enum IgnorableIdentifiers {
        
        /// Only ignore build identifiers (treat `1.2.3-Beta` as only equal to `1.2.3-Beta`; treat it different from `1.2.3` and from `1.2.3-Alpha`). Build numbers are ignored [according to the spec](https://semver.org/#spec-item-10)
        case none
        
        /// Ignore the pre-release identifier (treat `1.2.3-Beta` as equal to `1.2.3`)
        case preRelease
        
        /// Ignore the patch and pre-release identifiers (treat `1.2.3` as equal to `1.2.99`; treat `1.2.3-Beta` as equal to `1.2.0`)
        case patchAndPreRelease
        
        /// Ignore the minor, patch, and pre-release identifiers (treat `1.2.3` as equal to `1.99.42`; treat `1.2.3` as equal to `1.2.99`; treat `1.2.3-Beta` as equal to `1.2.0`)
        case minorAndPatchAndPreRelease
    }
}
