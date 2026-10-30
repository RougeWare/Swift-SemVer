//
//  Conveniences.swift
//  SemVer
//
//  Created by Ben Leggiero on 2018-01-14.
//

import Foundation



internal extension Comparable {
    
    /// Compares this value to the other, in this order
    ///
    /// - Parameter other: The value to compare against this one
    /// - Returns: The result of the comparison
    func compare(to other: Self) -> ComparisonResult {
        if self == other {
            return .orderedSame
        }
        else if self < other {
            return .orderedAscending
        }
        else {
            return .orderedDescending
        }
    }
}



/// To get around Swift complaining about using `+` too much to concatenate strings
///
/// - Parameter strings: All strings to concatenate
/// - Returns: All the given strings, concatenated
func concat(_ strings: String...) -> String {
    return strings.reduce(into: "", { (result, each) in
        result += each
    })
}



/// Determines if `lhs` and `rhs` are in virtually ascending order, using `isLessThanNil` if one is `nil` and the other is not
///
/// - Parameters:
///   - lhs: The first value to comprare
///   - rhs: The second value to compare
///   - isEquivalentToNull: [optional] If one value is `nil` and the other is not, this will say whether to treat the
///                         non-`nil` value as if it were equivalent to `nil`. Defaults to always returning `false`.
/// - Returns: `true` iff both are equal (both `nil`, or both non-nil with the same value), or if one is `nil` and the
///            other is effectively `nil`.
// TODO: No longer used, but useful - Move to another package
// #3: https://github.com/RougeWare/Swift-SemVer/issues/3
func isAscending<T: Comparable>(_ lhs: T?, _ rhs: T?, isLessThanNil: (T) -> Bool = { _ in false }) -> Bool {
    if let lhs = lhs {
        if let rhs = rhs { // lhs != nil, rhs != nil
            return lhs < rhs
        }
        else { // lhs != nil, rhs == nil
            return isLessThanNil(lhs) // lhs < nil
        }
    }
    else {
        if let rhs = rhs { // lhs == nil, rhs != nil
            return !isLessThanNil(rhs) // nil < rhs
        }
        else { // lhs == nil, rhs == nil
            return true
        }
    }
}



extension Sequence {
    /// A different syntax for `Swift.zip(_:_:)`. See `Swift.zip(_:_:)` for the exact behavior.
    ///
    /// - Parameter other: The other sequence to zip this one with
    /// - Returns: This sequence zipped with the other one
    func zip<Other: Sequence>(with other: Other) -> Zip2Sequence<Self, Other> {
        return Swift.zip(self, other)
    }
}



extension ComparisonResult {
    /// A semantic alias for `.orderedDescending`; `>`
    public static var lhsHasPrecedence: ComparisonResult { return .orderedDescending }
    
    /// A semantic alias for `.orderedAscending`; `<`
    public static var rhsHasPrecedence: ComparisonResult { return .orderedAscending }
}



internal extension Collection {
    
    /// Iff this pre-release extension is empty, this returns `nil`. Else, it just returns `self` unmodified
    @inlinable
    var nonEmptyOrNil: Self? {
        isEmpty ? nil : self
    }
}



internal extension SemVer.PreRelease {
    
    /// Iff this pre-release extension is empty, this returns `nil`. Else, it just returns `self` unmodified
    @inlinable
    var nonEmptyOrNil: Self? {
        identifiers.isEmpty ? nil : self
    }
}
