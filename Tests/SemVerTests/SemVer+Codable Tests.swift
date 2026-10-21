//
//  SemVer+Codable Tests.swift
//  SemVerTests
//
//  Created by Ky Leggiero on 2021-10-18.
//

import XCTest
import SemVer



class SemVerCodableTests: SemVerTestClass {
    
    func testEncode() throws {
        let encoder = JSONEncoder()
        
        
        func encode(_ semVer: SemVer) throws -> String {
            String(data: try encoder.encode(Test(semVer)), encoding: .utf8)!
        }
        
        
        func expect(_ output: String) -> String {
            #"{"semVer":"\#(output)"}"#
        }
        
        
        XCTAssertEqual(expect("0.0.0"), try encode(SemVer(0,0,0)))
        XCTAssertEqual(expect("0.0.1"), try encode(SemVer(0,0,1)))
        XCTAssertEqual(expect("0.1.0"), try encode(SemVer(0,1,0)))
        XCTAssertEqual(expect("1.0.0"), try encode(SemVer(1,0,0)))
        XCTAssertEqual(expect("0.0.999"), try encode(SemVer(0,0,999)))
        XCTAssertEqual(expect("0.999.0"), try encode(SemVer(0,999,0)))
        XCTAssertEqual(expect("999.0.0"), try encode(SemVer(999,0,0)))
        
        XCTAssertEqual(expect("1.2.3-RC.4+567"), try encode(SemVer(01,2,3, preRelease: "RC.4", build: 567)!))
        XCTAssertEqual(expect("1.2.3-RC.4+567"), try encode(SemVer(01,2,3, preRelease: ["RC","4"], build: 567)!))
        XCTAssertEqual(expect("1.2.3-RC.4+567"), try encode(SemVer(01,2,3, preRelease: ["RC","4"], build: [567])!))
        XCTAssertEqual(expect("1.2.3-RC.4+567"), try encode(SemVer("1.2.3-RC.4+567")!))
    }
    
    
    func testDecode() throws {
        let decoder = JSONDecoder()
        
        
        func decode(_ semVer: String) throws -> SemVer {
            try decoder.decode(Test.self, from: #"{"semVer":"\#(semVer)"}"#.data(using: .utf8)!).semVer
        }
        
        
        XCTAssertEqual(SemVer(0,0,0), try decode("0.0.0"))
        XCTAssertEqual(SemVer(0,0,1), try decode("0.0.1"))
        XCTAssertEqual(SemVer(0,1,0), try decode("0.1.0"))
        XCTAssertEqual(SemVer(1,0,0), try decode("1.0.0"))
        XCTAssertEqual(SemVer(0,0,999), try decode("0.0.999"))
        XCTAssertEqual(SemVer(0,999,0), try decode("0.999.0"))
        XCTAssertEqual(SemVer(999,0,0), try decode("999.0.0"))
        
        XCTAssertEqual(SemVer(01,2,3, preRelease: "RC.4", build: 567)!,       try decode("1.2.3-RC.4+567"))
        XCTAssertEqual(SemVer(01,2,3, preRelease: ["RC","4"], build: 567)!,   try decode("1.2.3-RC.4+567"))
        XCTAssertEqual(SemVer(01,2,3, preRelease: ["RC","4"], build: [567])!, try decode("1.2.3-RC.4+567"))
        XCTAssertEqual(SemVer("1.2.3-RC.4+567")!,                             try decode("1.2.3-RC.4+567"))
    }
    
    
    func testEncodeDecode() {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        
        func encodeDecode(_ semVer: SemVer) throws -> SemVer {
            try decoder.decode(Test.self, from: try encoder.encode(Test(semVer))).semVer
        }
        
        
        
        XCTAssertEqual(SemVer(0,0,0), try encodeDecode(SemVer(0,0,0)))
        XCTAssertEqual(SemVer(0,0,1), try encodeDecode(SemVer(0,0,1)))
        XCTAssertEqual(SemVer(0,1,0), try encodeDecode(SemVer(0,1,0)))
        XCTAssertEqual(SemVer(1,0,0), try encodeDecode(SemVer(1,0,0)))
        XCTAssertEqual(SemVer(0,0,999), try encodeDecode(SemVer(0,0,999)))
        XCTAssertEqual(SemVer(0,999,0), try encodeDecode(SemVer(0,999,0)))
        XCTAssertEqual(SemVer(999,0,0), try encodeDecode(SemVer(999,0,0)))
        
        XCTAssertEqual(SemVer(01,2,3, preRelease: "RC.4", build: 567)!,       try encodeDecode(SemVer(01,2,3, preRelease: "RC.4", build: 567)!))
        XCTAssertEqual(SemVer(01,2,3, preRelease: ["RC","4"], build: 567)!,   try encodeDecode(SemVer(01,2,3, preRelease: ["RC","4"], build: 567)!))
        XCTAssertEqual(SemVer(01,2,3, preRelease: ["RC","4"], build: [567])!, try encodeDecode(SemVer(01,2,3, preRelease: ["RC","4"], build: [567])!))
        XCTAssertEqual(SemVer("1.2.3-RC.4+567")!,                             try encodeDecode(SemVer("1.2.3-RC.4+567")!))
    }
    
    
    
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
        enum RogueRestriction: CanBeAlphanumeric {}
        
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



private struct Test: Codable {
    
    let semVer: SemVer
    
    
    init(_ semVer: SemVer) {
        self.semVer = semVer
    }
}
