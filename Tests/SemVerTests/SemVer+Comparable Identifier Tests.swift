//
//  SemVer+Comparable Identifier Tests.swift
//  SemVerTests
//
//  These extend the existing `SemVerComparableTests`. They can also be pasted into that class (replace `private var identifierPool` with a `private let` if you like).
//

import XCTest
@testable import SemVer



extension SemVerComparableTests {
    
    // MARK: - Identifier precedence
    
    private typealias PreReleaseIdentifier = SemVer.PreRelease.Identifier
    
    
    private func preRelease(_ text: String) -> SemVer.PreRelease {
        SemVer.PreRelease(identifiers: text.split(separator: ".").map { PreReleaseIdentifier(rawValue: String($0)) })
    }
    
    
    /// SemVer 2.0.0 item 11 for two pre-release identifiers, written without any library call that could hide a mistake.
    /// https://semver.org/spec/v2.0.0.html#spec-item-11
    ///
    /// - Returns: A negative number, `0`, or a positive number, when `lhs` has lower, equal, or higher precedence than `rhs`
    private func specOrder(_ lhs: String, _ rhs: String) -> Int {
        func isNumeric(_ text: String) -> Bool { false == text.isEmpty && text.utf8.allSatisfy { 48 ... 57 ~= $0 } }
        
        func compareBytes(_ lhs: String, _ rhs: String) -> Int {
            let lhsBytes = Array(lhs.utf8), rhsBytes = Array(rhs.utf8)
            for index in 0 ..< Swift.min(lhsBytes.count, rhsBytes.count) where lhsBytes[index] != rhsBytes[index] {
                return lhsBytes[index] < rhsBytes[index] ? -1 : 1
            }
            return lhsBytes.count == rhsBytes.count ? 0 : (lhsBytes.count < rhsBytes.count ? -1 : 1)
        }
        
        switch (lhsIsNumeric: isNumeric(lhs), rhsIsNumeric: isNumeric(rhs)) {
        case (lhsIsNumeric: true, rhsIsNumeric: true):
            // No leading zeros, so more digits means a bigger number
            return lhs.utf8.count == rhs.utf8.count ? compareBytes(lhs, rhs) : (lhs.utf8.count < rhs.utf8.count ? -1 : 1)
            
        case (lhsIsNumeric: true, rhsIsNumeric: false):
            return -1
            
        case (lhsIsNumeric: false, rhsIsNumeric: true):
            return 1
            
        case (lhsIsNumeric: false, rhsIsNumeric: false):
            return compareBytes(lhs, rhs)
        }
    }
    
    
    private var identifierPool: [String] { [
        "0", "1", "2", "9", "10", "11", "99", "100", "4294967295", "4294967296", "18446744073709551615", "18446744073709551616",
        "99999999999999999999", "100000000000000000000",
        "-1", "-", "--", "a", "A", "B", "Z", "a-b", "a-", "alpha", "Alpha", "0a", "00a", "1a", "9z", "1-", "z", "beta", "rc",
    ] }
    
    
    private func allSixOperators<Value: Comparable>(_ lhs: Value, _ rhs: Value) -> [Bool] {
        [lhs < rhs, lhs > rhs, lhs <= rhs, lhs >= rhs, lhs == rhs, lhs != rhs]
    }
    
    
    func testPreReleasePrecedenceExampleFromTheSpec() {
        let chain = ["alpha", "alpha.1", "alpha.beta", "beta", "beta.2", "beta.11", "rc.1"]
        
        for (lowerIndex, lower) in chain.enumerated() {
            for higher in chain[(lowerIndex + 1)...] {
                XCTAssertLessThan(preRelease(lower), preRelease(higher), "\(lower) < \(higher)")
                XCTAssertGreaterThan(preRelease(higher), preRelease(lower), "\(higher) > \(lower)")
                XCTAssertNotEqual(preRelease(lower), preRelease(higher), "\(lower) != \(higher)")
            }
        }
    }
    
    
    func testNumericIdentifiersAreComparedNumerically() {
        XCTAssertLessThan(preRelease("2"), preRelease("11"))
        XCTAssertLessThan(preRelease("9"), preRelease("10"))
        XCTAssertLessThan(preRelease("99"), preRelease("100"))
        
        // Too big for a 64-bit UInt, but still just a number
        XCTAssertLessThan(preRelease("18446744073709551615"), preRelease("18446744073709551616"))
        XCTAssertLessThan(preRelease("99999999999999999999"), preRelease("100000000000000000000"))
        XCTAssertLessThan(preRelease("4294967296"), preRelease("18446744073709551616"))
    }
    
    
    func testNumericIdentifiersAlwaysPrecedeAlphanumericOnes() {
        for alphanumeric in ["-1", "-", "--", "0a", "00a", "1a", "1-", "A", "a"] {
            for numeric in ["0", "2", "18446744073709551616", "99999999999999999999"] {
                XCTAssertLessThan(preRelease(numeric), preRelease(alphanumeric), "\(numeric) < \(alphanumeric)")
                XCTAssertGreaterThan(preRelease(alphanumeric), preRelease(numeric), "\(alphanumeric) > \(numeric)")
            }
        }
    }
    
    
    func testAlphanumericIdentifiersAreComparedInAsciiOrder() {
        XCTAssertLessThan(preRelease("B"), preRelease("a"))
        XCTAssertLessThan(preRelease("Alpha"), preRelease("alpha"))
        XCTAssertLessThan(preRelease("a"), preRelease("a-"))
        XCTAssertLessThan(preRelease("a-b"), preRelease("a0"))
        XCTAssertLessThan(preRelease("alpha"), preRelease("beta"))
    }
    
    
    func testLargerSetOfIdentifiersHasHigherPrecedence() {
        XCTAssertLessThan(preRelease("alpha"), preRelease("alpha.1"))
        XCTAssertLessThan(preRelease("1.2"), preRelease("1.2.0"))
        XCTAssertLessThan(preRelease("1.2.99"), preRelease("1.3"))
    }
    
    
    /// An empty pre-release sorts lowest here, but SemVer says a version with NO pre-release outranks one with any.
    /// So `SemVer.<` must handle "no pre-release" before it ever asks this
    func testEmptyPreReleaseIsLowestAmongPreReleases() {
        XCTAssertLessThan(SemVer.PreRelease(identifiers: []), preRelease("alpha"))
    }
    
    
    func testIdentifierPrecedenceAgreesWithTheSpecOnEveryPair() {
        for lhs in identifierPool {
            for rhs in identifierPool {
                let expected = specOrder(lhs, rhs)
                let expectedOperators = [0 > expected, 0 < expected, 0 >= expected, 0 <= expected, 0 == expected, 0 != expected]
                let lhsIdentifier = PreReleaseIdentifier(rawValue: lhs), rhsIdentifier = PreReleaseIdentifier(rawValue: rhs)
                
                XCTAssertEqual(expectedOperators, allSixOperators(lhsIdentifier, rhsIdentifier), "\(lhs) vs \(rhs)")
                XCTAssertEqual(expectedOperators, [lhsIdentifier < rhsIdentifier, lhsIdentifier > rhsIdentifier, lhsIdentifier <= rhsIdentifier, lhsIdentifier >= rhsIdentifier, lhsIdentifier == rhsIdentifier, lhsIdentifier != rhsIdentifier], "\(lhs) vs \(rhs), concrete")
            }
        }
    }
    
    
    func testIdentifierPrecedenceObeysTheLawsOfAnOrder() {
        let identifiers = identifierPool.map { PreReleaseIdentifier(rawValue: $0) }
        
        for a in identifiers {
            XCTAssertFalse(a < a, "irreflexive: \(a)")
            
            for b in identifiers {
                XCTAssertFalse(a < b && b < a, "asymmetric: \(a), \(b)")
                
                for c in identifiers where a < b && b < c {
                    XCTAssertLessThan(a, c, "transitive: \(a), \(b), \(c)")
                }
            }
        }
    }
    
    
    func testPreReleasePrecedenceAgreesWithTheSpecOnEveryPairOfShortLists() {
        let small = ["1", "2", "10", "alpha", "beta", "99999999999999999999"]
        let lists: [[String]] = [[]] + small.map { [$0] } + small.flatMap { first in small.map { [first, $0] } }
        
        func specOrder(_ lhs: [String], _ rhs: [String]) -> Int {
            for (lhsIdentifier, rhsIdentifier) in zip(lhs, rhs) {
                let order = self.specOrder(lhsIdentifier, rhsIdentifier)
                if 0 != order { return order }
            }
            return lhs.count == rhs.count ? 0 : (lhs.count < rhs.count ? -1 : 1)
        }
        
        for lhs in lists {
            for rhs in lists {
                let expected = specOrder(lhs, rhs)
                let lhsPreRelease = preRelease(lhs.joined(separator: ".")), rhsPreRelease = preRelease(rhs.joined(separator: "."))
                
                XCTAssertEqual(0 > expected, lhsPreRelease < rhsPreRelease, "\(lhs) < \(rhs)")
                XCTAssertEqual(0 < expected, lhsPreRelease > rhsPreRelease, "\(lhs) > \(rhs)")
                XCTAssertEqual(0 == expected, lhsPreRelease == rhsPreRelease, "\(lhs) == \(rhs)")
                XCTAssertEqual(0 > expected ? .orderedAscending : (0 < expected ? .orderedDescending : .orderedSame),
                               SemVer.PreRelease.compare(lhs: lhsPreRelease, rhs: rhsPreRelease),
                               "compare \(lhs) \(rhs)")
            }
        }
    }
}
