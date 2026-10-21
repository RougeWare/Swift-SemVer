//
//  SemVer+Identifier Tests.swift
//  SemVer
//
//  Created by Ky directing Claude Sonnet 5.5 on 2026-10-18.
//



import XCTest
@testable import SemVer



class SemVerIdentifierTests: SemVerTestClass {
    
    typealias PreReleaseIdentifier = SemVer.PreRelease.Identifier
    typealias BuildIdentifier = SemVer.Build.Identifier
    
    
    
    // MARK: - Character restrictions
    
    func testOnlyDigitsAdmits() {
        for text in ["0", "7", "10", "18446744073709551616"] {
            XCTAssertTrue(OnlyDigits.admits(text), text)
        }
        for text in ["", "01", "abc", "+5", "-0", "5.5", "٣"] {
            XCTAssertFalse(OnlyDigits.admits(text), text)
        }
    }
    
    
    func testPreReleaseCharactersAdmits() {
        for text in ["0", "7", "0a", "00a", "1a", "-", "--", "-1", "alpha", "rc-1", "99999999999999999999"] {
            XCTAssertTrue(PreReleaseCharacters.admits(text), text)
        }
        for text in ["", "01", "007", "a.b", "a b", "é", "a_b"] {
            XCTAssertFalse(PreReleaseCharacters.admits(text), text)
        }
    }
    
    
    func testBuildCharactersAdmits() {
        for text in ["0", "01", "007", "001", "21AF26D3----117B344092BD", "exp-sha"] {
            XCTAssertTrue(BuildCharacters.admits(text), text)
            XCTAssertTrue(OnlyAscii.admits(text), text)
        }
        for text in ["", "a.b", "a b", "é", "a_b"] {
            XCTAssertFalse(BuildCharacters.admits(text), text)
            XCTAssertFalse(OnlyAscii.admits(text), text)
        }
    }
    
    
    
    // MARK: - Equality
    
    func testEveryTextRouteMakesTheSameIdentifier() {
        let viaRawValue = PreReleaseIdentifier(rawValue: "5")
        let viaStringFactory = PreReleaseIdentifier.string("5")
        let viaStringLiteral: PreReleaseIdentifier = "5"
        let viaIntegerFactory = PreReleaseIdentifier.integer(5)
        let viaIntegerLiteral: PreReleaseIdentifier = 5
        
        let all = [viaRawValue, viaStringFactory, viaStringLiteral, viaIntegerFactory, viaIntegerLiteral]
        
        XCTAssertEqual(1, Set(all).count)
        for identifier in all {
            XCTAssertEqual(viaRawValue, identifier)
            XCTAssertEqual("5", identifier.description)
        }
    }
    
    
    func testBuildIdentifiersKeepLeadingZeros() {
        XCTAssertEqual("2018.01.15", SemVer.Build(identifiers: ["2018", "01", "15"]).description)
        XCTAssertNotEqual(BuildIdentifier(rawValue: "5"), BuildIdentifier(rawValue: "05"))
        XCTAssertEqual(2, Set([BuildIdentifier(rawValue: "5"), BuildIdentifier(rawValue: "05")]).count)
    }
    
    
    func testTextWhichUIntWouldRewriteIsKeptVerbatim() {
        for text in ["007", "00", "01", "+5", "-0"] {
            XCTAssertEqual(text, SemVer.AnyIdentifier(unchecked: text).description, text)
        }
        
        XCTAssertEqual(SemVer.AnyIdentifier.integer(7), SemVer.AnyIdentifier(unchecked: "7"))
        XCTAssertNotEqual(SemVer.AnyIdentifier.integer(7), SemVer.AnyIdentifier(unchecked: "007"))
    }
    
    
    func testNumbersTooBigForUIntAreStillIdentifiers() {
        let uIntMaxPlusOne = "18446744073709551616"
        XCTAssertEqual(uIntMaxPlusOne, PreReleaseIdentifier(rawValue: uIntMaxPlusOne).description)
        XCTAssertEqual(PreReleaseIdentifier(rawValue: uIntMaxPlusOne), PreReleaseIdentifier(rawValue: uIntMaxPlusOne))
    }
    
    
    
    // MARK: - Immutability
    
    // These do not compile, on purpose:
    //     identifier.rawValue = "x"                                   // setter for 'rawValue' is unavailable: Identifiers are immutable
    //     (identifier as TextOutputStream).write("hoge")              // cannot use mutating member on immutable value of type 'any TextOutputStream'
    
    func testIdentifiersIgnoreMutation() {
        let original = BuildIdentifier(rawValue: "abc")
        
        var viaExistential = original as TextOutputStream
        viaExistential.write("hoge")
        XCTAssertEqual(original, viaExistential as? BuildIdentifier)
        
        func write<Stream: TextOutputStream>(to stream: inout Stream) {
            stream.write("hoge")
        }
        var viaGeneric = original
        write(to: &viaGeneric)
        XCTAssertEqual(original, viaGeneric)
        
        var viaPrint = original
        print("RC", 1, separator: ".", to: &viaPrint)
        XCTAssertEqual(original, viaPrint)
        
        func setRawValue<Value: EssentiallyAString>(of value: inout Value) {
            value.rawValue = "zzz"
        }
        var viaRawValue = original
        setRawValue(of: &viaRawValue)
        XCTAssertEqual(original, viaRawValue)
    }
}
