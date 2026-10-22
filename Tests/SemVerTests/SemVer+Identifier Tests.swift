//
//  SemVer+Identifier Tests.swift
//  SemVer
//
//  Created by Ky directing Claude Sonnet 5.5 on 2026-10-18.
//

import Testing
import Foundation
import EssentiallyAString
@testable import SemVer





@Suite("Identifier")
struct SemVerIdentifierTests {
    
    typealias PreReleaseIdentifier = SemVer.PreRelease.Identifier
    typealias BuildIdentifier = SemVer.Build.Identifier
    
    
    /// What `SemVerTestClass.setUp` does for XCTests. Every test gets its own instance of this suite, so this runs before each one.
    ///
    /// This is needed so `assertionFailure` doesn't trap in the immutability test
    init() {
        isTesting = true
    }
    
    
    
    // MARK: - Character restrictions
    
    @Test(arguments: ["0", "7", "10", "18446744073709551616"])
    func testOnlyDigitsAdmits(_ text: String) {
        #expect(OnlyDigits.admits(text))
    }
    
    
    @Test(arguments: ["", "01", "abc", "+5", "-0", "5.5", "٣"])
    func testOnlyDigitsRefuses(_ text: String) {
        #expect(false == OnlyDigits.admits(text))
    }
    
    
    @Test(arguments: ["0", "7", "0a", "00a", "1a", "-", "--", "-1", "alpha", "rc-1", "99999999999999999999"])
    func testPreReleaseCharactersAdmits(_ text: String) {
        #expect(PreReleaseCharacters.admits(text))
    }
    
    
    @Test(arguments: ["", "01", "007", "a.b", "a b", "é", "a_b"])
    func testPreReleaseCharactersRefuses(_ text: String) {
        #expect(false == PreReleaseCharacters.admits(text))
    }
    
    
    @Test(arguments: ["0", "01", "007", "001", "21AF26D3----117B344092BD", "exp-sha"])
    func testBuildCharactersAdmits(_ text: String) {
        #expect(BuildCharacters.admits(text))
        #expect(OnlyAscii.admits(text))
    }
    
    
    @Test(arguments: ["", "a.b", "a b", "é", "a_b"])
    func testBuildCharactersRefuses(_ text: String) {
        #expect(false == BuildCharacters.admits(text))
        #expect(false == OnlyAscii.admits(text))
    }
    
    
    
    // MARK: - Equality
    
    @Test
    func testEveryTextRouteMakesTheSameIdentifier() {
        let viaRawValue = PreReleaseIdentifier(rawValue: "5")
        let viaStringFactory = PreReleaseIdentifier.string("5")
        let viaStringLiteral: PreReleaseIdentifier = "5"
        let viaIntegerFactory = PreReleaseIdentifier.integer(5)
        let viaIntegerLiteral: PreReleaseIdentifier = 5
        
        let all = [viaRawValue, viaStringFactory, viaStringLiteral, viaIntegerFactory, viaIntegerLiteral]
        
        #expect(1 == Set(all).count)
        for identifier in all {
            #expect(viaRawValue == identifier)
            #expect("5" == identifier.description)
        }
    }
    
    
    @Test
    func testBuildIdentifiersKeepLeadingZeros() {
        #expect("2018.01.15" == SemVer.Build(identifiers: ["2018", "01", "15"]).description)
        #expect(BuildIdentifier(rawValue: "5") != BuildIdentifier(rawValue: "05"))
        #expect(2 == Set([BuildIdentifier(rawValue: "5"), BuildIdentifier(rawValue: "05")]).count)
    }
    
    
    /// `UInt("007")` is `7`, so text which `UInt` would rewrite must stay text
    @Test(arguments: ["007", "00", "01", "+5", "-0"])
    func testTextWhichUIntWouldRewriteIsKeptVerbatim(_ text: String) {
        #expect(text == SemVer.AnyIdentifier(unchecked: text).description)
    }
    
    
    @Test
    func testCanonicalNumbersBecomeIntegers() {
        #expect(SemVer.AnyIdentifier.integer(7) == SemVer.AnyIdentifier(unchecked: "7"))
        #expect(SemVer.AnyIdentifier.integer(7) != SemVer.AnyIdentifier(unchecked: "007"))
    }
    
    
    @Test
    func testNumbersTooBigForUIntAreStillIdentifiers() {
        let uIntMaxPlusOne = "18446744073709551616"
        #expect(uIntMaxPlusOne == PreReleaseIdentifier(rawValue: uIntMaxPlusOne).description)
        #expect(PreReleaseIdentifier(rawValue: uIntMaxPlusOne) == PreReleaseIdentifier(rawValue: uIntMaxPlusOne))
    }
    
    
    
    // MARK: - Immutability
    
    // These do not compile, on purpose:
    //     identifier.rawValue = "x"                                   // setter for 'rawValue' is unavailable: Identifiers are immutable
    //     (identifier as TextOutputStream).write("hoge")              // cannot use mutating member on immutable value of type 'any TextOutputStream'
    
    @Test
    func testIdentifiersIgnoreMutation() {
        let original = BuildIdentifier(rawValue: "abc")
        
        var viaExistential = original as TextOutputStream
        viaExistential.write("hoge")
        #expect(original == viaExistential as? BuildIdentifier)
        
        func write<Stream: TextOutputStream>(to stream: inout Stream) {
            stream.write("hoge")
        }
        var viaGeneric = original
        write(to: &viaGeneric)
        #expect(original == viaGeneric)
        
        var viaPrint = original
        print("RC", 1, separator: ".", to: &viaPrint)
        #expect(original == viaPrint)
        
        func setRawValue<Value: EssentiallyAString>(of value: inout Value) {
            value.rawValue = "zzz"
        }
        var viaRawValue = original
        setRawValue(of: &viaRawValue)
        #expect(original == viaRawValue)
    }
}
