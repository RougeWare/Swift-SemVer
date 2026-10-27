//
//  SemVer+Extension Tests.swift
//  SemVerTests
//
//  Created by Ky directing Claude Sonnet 5.5 on 2026-10-26.
//

import Testing
import Foundation
@testable import SemVer



/// Tests for what pre-release and build extensions have in common: they must obey the rules of `Equatable` and
/// `Comparable` as a pair, no matter what their `compare(lhs:rhs:)` does.
///
/// Swift's `Comparable` only works if, for any two values, exactly one of these is true: `a < b`, `a == b`, `b < a`.
/// If `==` and `<` are written by different code, they can drift apart. For example, if `==` compares identifiers but
/// `compare(lhs:rhs:)` always says "same", then two different builds are neither equal nor ordered. That makes sorting
/// and `Set`/`Dictionary` behavior unpredictable, even though every other test might still pass.
@Suite("Extensions: Equatable and Comparable agree")
struct SemVerExtensionOrderTests {
    
    /// What `SemVerTestClass.setUp` does for XCTests. This runs before each test, because each test gets its own instance.
    init() {
        isTesting = true
    }
    
    
    
    // MARK: - Values to check
    
    /// Pre-release extensions to check. Together they cover: single and multiple identifiers, numeric against
    /// alphanumeric, a number too big for `UInt`, and a longer list that starts with a shorter one.
    ///
    /// This is computed, not stored, because Swift 6 won't allow shared mutable static state.
    ///
    /// These are literals and every one of them is valid; a typo here would make an empty extension instead
    /// (and crash a DEBUG build, which is what you'd want to see)
    private static var preReleases: [SemVer.PreRelease] {
        [
            "alpha", "alpha.1", "alpha.beta", "beta", "beta.2", "beta.11", "rc.1",
            "1", "2", "10", "1.2", "1.2.0", "0a", "99999999999999999999",
        ]
    }
    
    
    /// Build extensions to check. Includes ones which differ only by leading zeroes, since those are legal here and
    /// are the likeliest to be compared wrongly.
    private static var builds: [SemVer.Build] {
        [
            "a", "b", "1", "001", "1.2", "1.02", "exp-sha", "20130313144700",
        ]
    }
    
    
    
    // MARK: - The rules
    
    /// For every pair of values, exactly one of `a < b`, `a == b`, `b < a` must be true.
    ///
    /// This is the test that catches `==` and `<` disagreeing
    @Test
    func testPreReleaseHasExactlyOneRelationForEveryPair() {
        Self.expectExactlyOneRelationForEveryPair(Self.preReleases)
    }
    
    
    /// See `testPreReleaseHasExactlyOneRelationForEveryPair`
    @Test
    func testBuildHasExactlyOneRelationForEveryPair() {
        Self.expectExactlyOneRelationForEveryPair(Self.builds)
    }
    
    
    /// Every value must equal itself, and not be less than itself
    @Test
    func testPreReleaseIsReflexive() {
        Self.expectReflexive(Self.preReleases)
    }
    
    
    /// See `testPreReleaseIsReflexive`
    @Test
    func testBuildIsReflexive() {
        Self.expectReflexive(Self.builds)
    }
    
    
    /// If `a < b` and `b < c`, then `a < c`
    @Test
    func testPreReleaseOrderIsTransitive() {
        Self.expectTransitive(Self.preReleases)
    }
    
    
    /// See `testPreReleaseOrderIsTransitive`
    @Test
    func testBuildOrderIsTransitive() {
        Self.expectTransitive(Self.builds)
    }
    
    
    
    // MARK: - Checking tools
    
    /// Checks that every pair among the given values has exactly one of the three relations: less, equal, greater
    private static func expectExactlyOneRelationForEveryPair<Extension: SemanticVersionExtension>(_ values: [Extension]) {
        for lhs in values {
            for rhs in values {
                let relations = [lhs < rhs, lhs == rhs, rhs < lhs]
                
                #expect(1 == relations.filter { $0 }.count,
                        "\(Extension.name) \"\(lhs)\" vs \"\(rhs)\": [<, ==, >] was \(relations), but exactly one must be true")
                
                // `==` has to be symmetrical, too
                #expect((lhs == rhs) == (rhs == lhs), "\(Extension.name) \"\(lhs)\" vs \"\(rhs)\": == must be symmetrical")
            }
        }
    }
    
    
    /// Checks that every given value equals itself, and is not less than itself
    private static func expectReflexive<Extension: SemanticVersionExtension>(_ values: [Extension]) {
        for value in values {
            #expect(value == value, "\(Extension.name) \"\(value)\" must equal itself")
            #expect(false == (value < value), "\(Extension.name) \"\(value)\" must not be less than itself")
        }
    }
    
    
    /// Checks that, among the given values, whenever `a < b` and `b < c`, then `a < c`
    private static func expectTransitive<Extension: SemanticVersionExtension>(_ values: [Extension]) {
        for a in values {
            for b in values where a < b {
                for c in values where b < c {
                    #expect(a < c, "\(Extension.name) \"\(a)\" < \"\(b)\" < \"\(c)\", so \"\(a)\" must be < \"\(c)\"")
                }
            }
        }
    }
}
