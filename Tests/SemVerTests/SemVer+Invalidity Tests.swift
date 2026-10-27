//
//  SemVer+Invalidity Tests.swift
//  SemVerTests
//
//  Created by Ky directing Claude Sonnet 5.5 on 2026-10-27.
//

import Testing
import Foundation
@testable import SemVer



/// Tests that this package follows its policy for invalid input:
///
/// - This package guarantees valid semantic versions
/// - If a dev supplies an invalid semantic version as a string, they get back `nil`
/// - If they do that with a literal, they get back an empty collection
/// - DEBUG builds assert where invalidity is detected (these tests turn that off with `isTesting`, so they can look at
///   what production would do)
///
/// Every test here is expected to pass once the policy is fully followed.
@Suite("Invalid input follows the policy")
struct SemVerInvalidInputTests {
    
    /// What `SemVerTestClass.setUp` does for XCTests. This runs before each test, because each test gets its own instance.
    ///
    /// Without this, the assertions in the literal tests would stop the run instead of letting them look at the result
    init() {
        isTesting = true
    }
    
    
    
    // MARK: - Extension strings
    
    // These pass a `String` variable (not a literal) to the initializer. That picks the failable `init?(_:)`; passing a
    // literal would pick `init(stringLiteral:)`, which can't fail and yields an empty extension instead.
    
    /// Pre-release text which breaks the grammar. Empty identifiers (`a..b`, a leading or trailing dot, or no text at
    /// all) are the interesting ones: `split` throws away empty pieces unless told otherwise, so they can slip through
    /// as if they weren't there.
    private static let invalidPreReleaseText = [
        "", "a..b", "alpha.", ".alpha", "..", ".",
        "007", "1.007", "alpha.01",
        "a$", "a b", "a_b", "é", "a\u{301}", "😱",
    ]
    
    
    /// Build text which breaks the grammar. Leading zeroes are fine here, so those aren't listed
    private static let invalidBuildText = [
        "", "a..b", "build.", ".build", "..", ".",
        "a$", "a b", "a_b", "é", "a\u{301}", "😱",
    ]
    
    
    @Test(arguments: invalidPreReleaseText)
    func testInvalidPreReleaseTextReturnsNil(_ text: String) {
        #expect(nil == SemVer.PreRelease(text), "\"\(text)\" is not a valid pre-release, so it must return nil")
    }
    
    
    @Test(arguments: invalidBuildText)
    func testInvalidBuildTextReturnsNil(_ text: String) {
        #expect(nil == SemVer.Build(text), "\"\(text)\" is not valid build metadata, so it must return nil")
    }
    
    
    
    // MARK: - Extension literals
    
    /// A single invalid element in an array literal makes the whole literal empty, not just that element.
    ///
    /// This is the same as a string literal with an invalid part (`"alpha.$67.1"`), and as an array literal whose only
    /// element is invalid (`["$67"]`); both already end up empty. Without this, an array literal would keep
    /// `alpha.1`, which isn't what the dev wrote.
    @Test
    func testPreReleaseArrayLiteralWithAnInvalidElementIsEmpty() {
        let withBadCharacter: SemVer.PreRelease = ["alpha", "$67", "1"]
        let withEmpty: SemVer.PreRelease = ["alpha", "", "1"]
        let withLeadingZero: SemVer.PreRelease = ["alpha", "007"]
        
        #expect(withBadCharacter.identifiers.isEmpty, "got \"\(withBadCharacter)\"")
        #expect(withEmpty.identifiers.isEmpty, "got \"\(withEmpty)\"")
        #expect(withLeadingZero.identifiers.isEmpty, "got \"\(withLeadingZero)\"")
    }
    
    
    /// See `testPreReleaseArrayLiteralWithAnInvalidElementIsEmpty`
    @Test
    func testBuildArrayLiteralWithAnInvalidElementIsEmpty() {
        let withBadCharacter: SemVer.Build = ["20261026", "#1", "abc"]
        let withEmpty: SemVer.Build = ["20261026", "", "abc"]
        
        #expect(withBadCharacter.identifiers.isEmpty, "got \"\(withBadCharacter)\"")
        #expect(withEmpty.identifiers.isEmpty, "got \"\(withEmpty)\"")
    }
    
    
    /// The memberwise initializer is public, and its elements are identifiers, which can be written as literals. An
    /// invalid literal there must not leave a hidden invalid identifier inside the extension, where it would not even
    /// equal itself.
    @Test
    func testPreReleaseMemberwiseInitializerKeepsNoInvalidIdentifiers() {
        let preRelease = SemVer.PreRelease(identifiers: ["a$"])
        
        #expect(preRelease.identifiers.isEmpty, "got \(preRelease.identifiers.count) identifier(s)")
        #expect(preRelease == preRelease, "an extension must equal itself")
    }
    
    
    /// See `testPreReleaseMemberwiseInitializerKeepsNoInvalidIdentifiers`
    @Test
    func testBuildMemberwiseInitializerKeepsNoInvalidIdentifiers() {
        let build = SemVer.Build(identifiers: ["a$"])
        
        #expect(build.identifiers.isEmpty, "got \(build.identifiers.count) identifier(s)")
        #expect(build == build, "an extension must equal itself")
    }
    
    
    
    // MARK: - Whole version strings
    
    // These go through the regex in `SemVer(_ stringValue:)`, which is checked separately from the extension initializers
    
    /// Version strings which break the grammar. Each must return `nil`
    private static let invalidVersionText = [
        // Empty identifiers
        "1.0.0+", "1.0.0+a..b", "1.0.0+.a", "1.0.0+a.", "1.0.0-", "1.0.0-a..b", "1.0.0-.a", "1.0.0-a.",
        
        // Leading zeroes in numeric pre-release identifiers
        "1.0.0-007", "1.0.0-00", "1.0.0-alpha.01", "1.0.0-01.alpha",
        
        // Anything non-ASCII, including combining marks, which can hide at the end of an otherwise-valid part
        "1.0.0-a\u{301}", "1.0.0+a\u{301}", "1.0.0\u{301}", "1.0.0-é", "1.0.0+é", "1.0.0-😱", "1.0.0+😱",
    ]
    
    
    /// Version strings which are valid, even though they look a little like some invalid ones
    private static let validVersionText = [
        // A leading zero is only forbidden in an identifier which is all digits
        "1.0.0-0a", "1.0.0-00a", "1.0.0-1a", "1.0.0-0-", "1.0.0-alpha.0a", "1.0.0-0a.0b",
        
        // Build identifiers can have any leading zeroes
        "1.0.0+01", "1.0.0+001", "1.0.0-alpha+001", "1.0.0+2018.01.15",
    ]
    
    
    @Test(arguments: invalidVersionText)
    func testInvalidVersionTextReturnsNil(_ text: String) {
        #expect(nil == SemVer(text), "\"\(text)\" is not a valid semantic version, so it must return nil")
    }
    
    
    @Test(arguments: invalidVersionText)
    func testInvalidVersionTextFailsToDecode(_ text: String) {
        #expect(throws: SemVer.DecodingError.self, "\"\(text)\" is not a valid semantic version, so it must fail to decode") {
            _ = try JSONDecoder().decode(SemVer.self, from: Data("\"\(text)\"".utf8))
        }
    }
    
    
    /// Valid text must come back whole. In particular, nothing may be silently dropped
    @Test(arguments: validVersionText)
    func testValidVersionTextIsKeptWhole(_ text: String) {
        #expect(text == SemVer(text)?.description, "\"\(text)\" is a valid semantic version, so it must be kept exactly")
    }
    
    
    /// Issue #37: pre-release identifiers can't have leading zeroes, but the same digits in build metadata are fine
    @Test
    func testLeadingZeroesAreRejectedInPreReleaseButKeptInBuild() {
        #expect(nil == SemVer("1.2.3-007+2018.01.15"))
        #expect("1.2.3+2018.01.15" == SemVer("1.2.3+2018.01.15")?.description)
    }
}
