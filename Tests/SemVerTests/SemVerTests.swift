//
//  SemVerTests.swift
//  SemVer
//
//  Created by Ben Leggiero on 2018-01-09.
//  Copyright © 2021 Ben Leggiero BH-1-PS.
//

import XCTest
import SemVer



class SemVerTests: SemVerTestClass {
    
    
    func testDescription() {
        XCTAssertEqual(SemVer(01,2,3, preRelease: "RC.4", build: 567)!.description, "1.2.3-RC.4+567")
        XCTAssertEqual(SemVer(01,2,3, preRelease: ["RC","4"], build: 567)!.description, "1.2.3-RC.4+567")
        XCTAssertEqual(SemVer(01,2,3, preRelease: ["RC","4"], build: [567])!.description, "1.2.3-RC.4+567")
        XCTAssertEqual(SemVer("1.2.3-RC.4+567")?.description, "1.2.3-RC.4+567")
    }
    
    
    func testFromString() {
        XCTAssertEqual(SemVer("1.2.3"), SemVer(major: 1, minor: 2, patch: 3))
        XCTAssertEqual(SemVer("1.2.3-RC"), SemVer(major: 1, minor: 2, patch: 3, preRelease: SemanticVersionPreRelease(identifiers: ["RC"])))
        XCTAssertEqual(SemVer("1.2.3-4"), SemVer(major: 1, minor: 2, patch: 3, preRelease: SemanticVersionPreRelease(identifiers: [4])))
        XCTAssertEqual(SemVer("1.2.3+567.8"), SemVer(major: 1, minor: 2, patch: 3, build: SemanticVersionBuild(identifiers: [567])))
        XCTAssertEqual(SemVer("1.2.3-RC.4+567.8"), SemVer(major: 1, minor: 2, patch: 3, preRelease: SemanticVersionPreRelease(identifiers: ["RC", "4"]), build: SemanticVersionBuild(identifiers: ["567", "8"])))
        XCTAssertEqual(SemVer("1.2.3-RC.4+567.8"), SemVer(1,2,3, preRelease: ["RC",4], build: [567,8]))
    }
    
    
    func testBuildNumber() {
        XCTAssertEqual(SemVer("1.2.3+123")!.description, "1.2.3+123")
        XCTAssertEqual(SemVer("1.2.3+exp.sha.5114f85")!.description, "1.2.3+exp.sha.5114f85")
        XCTAssertEqual(SemVer("1.2.3+2018.01.14.00.01")!.description, "1.2.3+2018.01.14.00.01")
    }
    
    
    // MARK: - Precedence
    
    
    func testInvalid() {
        XCTAssertNil(SemVer("Obviously Bad"))
        XCTAssertNil(SemVer("1"))
        XCTAssertNil(SemVer("1.2"))
        XCTAssertNil(SemVer("1.2-RC.4"))
        XCTAssertNil(SemVer("1.2-RC.4+567.8"))
        XCTAssertNil(SemVer("1.2-RC.4+567"))
        XCTAssertNil(SemVer("1.2-RC+567.8"))
        XCTAssertNil(SemVer("-2.0"))
        XCTAssertNil(SemVer("2.0-β"))
        XCTAssertNil(SemVer("2.0-beta_1"))
        XCTAssertNil(SemVer("1.-2"))
        XCTAssertNil(SemVer("1.2.-3"))
        XCTAssertNil(SemVer("1.2.3.4"))
        
        // Proof of fix of #14: https://github.com/RougeWare/Swift-SemVer/issues/14
        XCTAssertNil(SemVer(1,0,0, preRelease: "01"))
        XCTAssertNil(SemVer("1.0.0-01"))
        XCTAssertNil(SemVer("1.0.0-01.02.03"))
        
        XCTAssertNil(SemVer("01.2.3"))
        XCTAssertNil(SemVer("1.02.3"))
        XCTAssertNil(SemVer("1.2.03"))
    }
    
    
    
    static let allTests = [
        ("testDescription", testDescription),
        ("testFromString", testFromString),
        ("testInvalid", testInvalid),
    ]
}
