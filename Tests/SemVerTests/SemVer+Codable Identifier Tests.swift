//
//  SemVer+Codable Identifier Tests.swift
//  SemVerTests
//
//  These extend the existing `SemVerCodableTests`. They can also be pasted into that class.
//

import XCTest
import SemVer



extension SemVerCodableTests {
    
    private func decode<Value: Decodable>(_ type: Value.Type, _ json: String) throws -> Value {
        try JSONDecoder().decode(type, from: Data(json.utf8))
    }
    
    
    private func assertRejected<Value: Decodable>(_ type: Value.Type, _ json: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertThrowsError(try decode(type, json), json, file: file, line: line) { error in
            guard case DecodingError.dataCorrupted = error else {
                return XCTFail("Expected dataCorrupted for \(json), but got \(error)", file: file, line: line)
            }
        }
    }
    
    
    
    // MARK: - Identifiers
    
    func testIdentifierDecodingAcceptsWhatItsRestrictionAdmits() throws {
        XCTAssertEqual([0, 7, 10] as [SemVer.Identifier<OnlyDigits>],
                       try decode([SemVer.Identifier<OnlyDigits>].self, #"[0, 7, 10]"#))
        
        XCTAssertEqual(["alpha", 1, "0a", "--"] as [SemVer.PreRelease.Identifier],
                       try decode([SemVer.PreRelease.Identifier].self, #"["alpha", 1, "0a", "--"]"#))
        
        XCTAssertEqual(["01", 7, "exp-sha", "007"] as [SemVer.Build.Identifier],
                       try decode([SemVer.Build.Identifier].self, #"["01", 7, "exp-sha", "007"]"#))
        
        XCTAssertEqual(["a-b", 3, "01"] as [SemVer.AnyIdentifier],
                       try decode([SemVer.AnyIdentifier].self, #"["a-b", 3, "01"]"#))
    }
    
    
    func testIdentifierDecodingRejectsWhatItsRestrictionRefuses() {
        assertRejected([SemVer.Identifier<OnlyDigits>].self, #"[7, "abc"]"#)
        assertRejected([SemVer.Identifier<OnlyDigits>].self, #"["01"]"#)
        assertRejected([SemVer.Identifier<OnlyDigits>].self, #"["+5"]"#)
        
        assertRejected([SemVer.PreRelease.Identifier].self, #"["01"]"#)
        assertRejected([SemVer.PreRelease.Identifier].self, #"["a.b"]"#)
        assertRejected([SemVer.PreRelease.Identifier].self, #"[""]"#)
        
        assertRejected([SemVer.Build.Identifier].self, #"["a.b"]"#)
        assertRejected([SemVer.Build.Identifier].self, #"[""]"#)
        assertRejected([SemVer.Build.Identifier].self, #"["é"]"#)
        
        assertRejected([SemVer.AnyIdentifier].self, #"["a b"]"#)
    }
    
    
    func testIdentifierRestrictionsDefinedElsewhereAreRejected() throws {
        enum RogueRestriction: CanBeAscii {}
        
        // Proves the failure below is the rogue restriction, not the JSON
        XCTAssertEqual(["abc"] as [SemVer.AnyIdentifier], try decode([SemVer.AnyIdentifier].self, #"["abc"]"#))
        
        assertRejected([SemVer.Identifier<RogueRestriction>].self, #"["abc"]"#)
    }
    
    
    func testBuildIdentifiersSurviveEncodeThenDecode() throws {
        let identifiers: [SemVer.Build.Identifier] = ["01", 7]
        let encoded = try JSONEncoder().encode(identifiers)
        
        XCTAssertEqual(#"["01",7]"#, String(decoding: encoded, as: UTF8.self))
        XCTAssertEqual(identifiers, try JSONDecoder().decode([SemVer.Build.Identifier].self, from: encoded))
    }
}
