//
//  Conveniences.swift
//  SemVer
//
//  Created by Ben Leggiero on 2018-01-14.
//  Copyright © 2020 Ben Leggiero BH-1-PS.
//

import Foundation



/// To get around Swift complaining about using `+` too much to concatenate strings
///
/// - Parameter strings: All strings to concatenate
/// - Returns: All the given strings, concatenated
func concat(_ strings: String...) -> String {
    return strings.reduce(into: "", { (result, each) in
        result += each
    })
}



/// Determines if `lhs` and `rhs` are virtually equivalent, using `isEquivalentToNil` if one is `nil` and the other is not
///
/// - Parameters:
///   - lhs: The first value to compare
///   - rhs: The second value to compare
///   - isEquivalentToNull: [optional] If one value is `nil` and the other is not, this will say whether to treat the
///                         non-`nil` value as if it were equivalent to `nil`. Defaults to always returning `false`.
/// - Returns: `true` iff both are equal (both `nil`, or both non-nil with the same value), or if one is `nil` and the
///            other is effectively `nil`.
func isEquivalent<T: Equatable>(_ lhs: T?, _ rhs: T?, isEquivalentToNil: (T) -> Bool = { _ in false }) -> Bool {
    if let lhs = lhs {
        if let rhs = rhs { // lhs != nil, rhs != nil
            return lhs == rhs
        }
        else { // lhs != nil, rhs == nil
            return isEquivalentToNil(lhs)
        }
    }
    else {
        if let rhs = rhs { // lhs == nil, rhs != nil
            return isEquivalentToNil(rhs)
        }
        else { // lhs == nil, rhs == nil
            return true
        }
    }
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
    /// A semantic alias for `.orderedDescending`
    public static var lhsHasPrecedence: ComparisonResult { return .orderedDescending }
    
    /// A semantic alias for `.orderedAscending`
    public static var rhsHasPrecedence: ComparisonResult { return .orderedAscending }
}



/// The old Objective-C style of `Comparable`, where the comparison operaton returns `<`, `==`, or `>`
protocol ObjcComparable {
    /// Compares this and the other objects, and returns the comparison result
    ///
    /// - Parameter other: The object to compare to this one
    /// - Returns: The result of the comparison
    func compare(to other: Self) -> ComparisonResult
}



extension UInt: ObjcComparable {
    /// Compares this to the other `UInt`
    ///
    /// - Parameter other: The `UInt` to compare to this one
    /// - Returns: The result of the comparison
    func compare(to other: UInt) -> ComparisonResult {
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



extension Int: ObjcComparable {
    /// Compares this to the other `Int`
    ///
    /// - Parameter other: The `Int` to compare to this one
    /// - Returns: The result of the comparison
    func compare(to other: Int) -> ComparisonResult {
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



public extension NSRange {
    /// If this represents a null or unfound range, this returns `nil`; else, this returns the range itself
    public var orNil: NSRange? {
        if location == NSNotFound {
            return nil
        }
        return self
    }
}
