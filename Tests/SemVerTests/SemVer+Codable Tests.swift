//
//  SemVer+Codable Tests.swift
//  
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
}



private struct Test: Codable {
    
    let semVer: SemVer
    
    
    init(_ semVer: SemVer) {
        self.semVer = semVer
    }
}
