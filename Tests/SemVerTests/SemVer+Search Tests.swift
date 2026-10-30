//
//  SemVer+Search Tests.swift
//  SemVerTests
//
//  Created by Ky directing Claude Sonnet 5.5 on 2026-10-29.
//

import Testing
import Foundation
import RegexBuilder
@testable import SemVer



/// Tests searching larger strings for semantic versions with `SemVer.regex`.
///
/// The rules for what can touch a version on either side are written on ``SemanticVersion/regex``.
@Suite("Finding semantic versions in larger strings")
struct SemVerSearchTests {
    
    /// Every version `regex` finds in `text`, in order
    private static func versionsFound(in text: String) -> [String] {
        text.matches(of: SemVer.regex).map { String($0.0) }
    }
    
    
    
    // MARK: - What gets found
    
    /// Each text, and the versions that should be found in it
    private static let textsWithVersions: [(text: String, versions: [String])] = [
        ("1.2.3", ["1.2.3"]),
        ("Released 1.2.3-rc.1+b5 today.", ["1.2.3-rc.1+b5"]),
        ("Upgrade from 1.2.3 to 2.0.0.", ["1.2.3", "2.0.0"]),
        ("Version 1.2.3.", ["1.2.3"]),
        ("Version 1.2.3, then 1.2.4", ["1.2.3", "1.2.4"]),
        ("(1.2.3)", ["1.2.3"]),
        ("<1.2.3-beta>", ["1.2.3-beta"]),
        ("\"1.0.0+001\"", ["1.0.0+001"]),
        ("path/1.2.3/lib", ["1.2.3"]),
        ("1.2.3\n2.0.0-alpha\n", ["1.2.3", "2.0.0-alpha"]),
        ("1.2.3 2.0.0", ["1.2.3", "2.0.0"]),
        ("1.2.3,2.0.0", ["1.2.3", "2.0.0"]),
        ("1.0.0-0a and 1.0.0-alpha.0b", ["1.0.0-0a", "1.0.0-alpha.0b"]),
        ("1.2.3-alpha-a.b-c+build.1-aef", ["1.2.3-alpha-a.b-c+build.1-aef"]),
        ("1.0.0-1.2.3", ["1.0.0-1.2.3"]),
        ("no version here", []),
        ("", []),
    ]
    
    
    @Test("It finds the whole version", arguments: textsWithVersions)
    func testFindsWholeVersions(_ text: String, _ versions: [String]) {
        #expect(versions == Self.versionsFound(in: text), "in \(text.debugDescription)")
    }
    
    
    /// Each of these is a valid version on its own, so it has to be found whole no matter what's around it
    private static let validVersions = [
        "0.0.4", "1.2.3", "10.20.30", "1.1.2-prerelease+meta", "1.1.2+meta", "1.1.2+meta-valid",
        "1.0.0-alpha", "1.0.0-alpha.beta", "1.0.0-alpha.beta.1", "1.0.0-alpha0.valid", "1.0.0-alpha.0valid",
        "1.0.0-alpha-a.b-c-somethinglong+build.1-aef.1-its-okay", "2.0.0-rc.1+build.123", "10.2.3-DEV-SNAPSHOT",
        "1.2.3-SNAPSHOT-123", "1.0.0-alpha+beta", "1.2.3----RC-SNAPSHOT.12.9.1--.12+788",
        "1.0.0+0.build.1-rc.10000aaa-kk-0.1", "1.0.0-0A.is.legal",
    ]
    
    
    @Test("It finds a valid version whole, however it is surrounded", arguments: validVersions)
    func testFindsValidVersionWhenSurrounded(_ version: String) {
        let surroundings = [
            "\(version)",
            " \(version) ",
            "-\(version)",
            "(\(version))",
            "Version \(version).",
            "[\(version)], ",
            "\"\(version)\"",
            "first line\n\(version)\nlast line",
            "path/\(version)/lib",
        ]
        
        for text in surroundings {
            #expect([version] == Self.versionsFound(in: text), "in \(text.debugDescription)")
        }
    }
    
    
    @Test("The captures are the pieces of the version")
    func testCapturesArePiecesOfVersion() throws {
        let text = "Released 1.2.3-rc.1+b5 today."
        let match = try #require(text.firstMatch(of: SemVer.regex))
        
        #expect("1.2.3-rc.1+b5" == match.0)
        #expect("1" == match[SemVer.Regex.Captures.major])
        #expect("2" == match[SemVer.Regex.Captures.minor])
        #expect("3" == match[SemVer.Regex.Captures.patch])
        #expect("rc.1" == match[SemVer.Regex.Captures.preRelease])
        #expect("b5" == match[SemVer.Regex.Captures.build])
    }
    
    
    @Test("The captures for a missing pre-release or build are nil")
    func testCapturesForMissingExtensionsAreNil() throws {
        let text = "Released 1.2.3 today."
        let match = try #require(text.firstMatch(of: SemVer.regex))
        
        #expect("1.2.3" == match.0)
        #expect(nil == match[SemVer.Regex.Captures.preRelease])
        #expect(nil == match[SemVer.Regex.Captures.build])
    }
    
    
    
    // MARK: - What doesn't
    
    /// SemVer-shaped text which isn't a SemVer. Finding `1.2.3` in `1.2.3.4` or `01.2.3` would give back a version
    /// that isn't what's in the text.
    private static let textsWithoutVersions = [
        "01.2.3", "1.02.3", "1.2.03", "0.1.2.3", "1.2.3.4", "1.2", "1.2.x", "1.2.3.beta",
        "a1.2.3", "1.2.3b", "v1.2.3", "_1.2.3", "1.2.3_",
        "1.2.3-", "1.2.3+", "1.2.3-+", "1.2.3-007", "1.2.3-alpha_beta", "1.2.3+a_b",
        "1.2.3-é", "1.2.3-😱", "é1.2.3", "1.2.3é", "1.2.3-a\u{301}",
    ]
    
    
    @Test("It doesn't find a version in text which isn't one", arguments: textsWithoutVersions)
    func testDoesNotFindVersionInNonVersion(_ text: String) {
        #expect([] == Self.versionsFound(in: text), "in \(text.debugDescription)")
        #expect([] == Self.versionsFound(in: "see \(text) here"), "in \"see \(text) here\"")
    }
    
    
    
    /// Nothing before or after a version can be part of the match, or `wholeMatch` would call the string valid
    @Test("wholeMatch refuses a version with anything touching it", arguments: [
        " 1.2.3", "-1.2.3", "+1.2.3", "1.2.3+", "v1.2.3", "1.2.3 ", "1.2.3.", "1.2.3.4", "1.2.3-",
    ])
    func testWholeMatchRefusesTouchedVersion(_ text: String) {
        #expect(nil == (try? SemVer.regex.wholeMatch(in: text)), "in \(text.debugDescription)")
    }
    
    
    
    // MARK: - Agreement with the whole-string regex
    
    /// Every string made of a few characters, with a space on each side. Searching finds the whole string as a version
    /// exactly when `wholeMatch` says the whole string is one.
    @Test("It agrees with the whole-string regex on short strings")
    func testAgreesWithWholeStringRegex() {
        let alphabet = ["0", "1", ".", "-", "+", "a"]
        var checked = 0
        var disagreements = [String]()
        
        func check(_ text: String) {
            checked += 1
            
            let isWhole = nil != (try? SemVer.regex.wholeMatch(in: text))
            let found = Self.versionsFound(in: " \(text) ")
            
            if isWhole != ([text] == found) {
                disagreements.append("\(text.debugDescription): wholeMatch \(isWhole), found \(found)")
            }
        }
        
        func extend(_ current: String, remaining: Int) {
            guard 0 < remaining else {
                return
            }
            
            for character in alphabet {
                let next = current + character
                check(next)
                extend(next, remaining: remaining - 1)
            }
        }
        
        for prefix in ["1.0.0", "0.0.0"] {
            check(prefix)
            extend(prefix, remaining: 4)
        }
        
        #expect(
            disagreements.isEmpty,
            "\(disagreements.count) of \(checked) strings disagree. First: \(disagreements.prefix(8))"
        )
    }
}
