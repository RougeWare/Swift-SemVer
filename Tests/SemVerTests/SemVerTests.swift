//
//  SemVerTests.swift
//  SemVer
//
//  Created by Ben Leggiero on 2018-01-09.
//  Copyright © 2020 Ben Leggiero BH-1-PS.
//

import XCTest
@testable import SemVer

class SemVerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testDescription() {
        XCTAssertEqual(SemVer(01,2,3, preRelease: "RC.4", build: 567).description, "1.2.3-RC.4+567")
        XCTAssertEqual(SemVer(01,2,3, preRelease: ["RC","4"], build: 567).description, "1.2.3-RC.4+567")
        XCTAssertEqual(SemVer(01,2,3, preRelease: ["RC","4"], build: [567]).description, "1.2.3-RC.4+567")
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
    
    
    func testPrecedence() {
        XCTAssertLessThan(SemVer("1.0.0")!, SemVer("2.0.0")!)
        XCTAssertLessThan(SemVer("2.0.0")!, SemVer("2.1.0")!)
        XCTAssertLessThan(SemVer("2.1.0")!, SemVer("2.1.1")!)
        XCTAssertLessThan(SemVer("2.0.0")!, SemVer("12.0.0")!)
        
        XCTAssertLessThan(SemVer("1.0.0-alpha")!, SemVer("1.0.0")!)
        XCTAssertLessThan(SemVer("1.0.0-alpha")!, SemVer("1.0.0-alpha.1")!)
        XCTAssertLessThan(SemVer("1.0.0-alpha.1")!, SemVer("1.0.0-alpha.beta")!)
        XCTAssertLessThan(SemVer("1.0.0-alpha.1")!, SemVer("1.0.0-beta")!)
        XCTAssertLessThan(SemVer("1.0.0-beta")!, SemVer("1.0.0-beta.2")!)
        XCTAssertLessThan(SemVer("1.0.0-beta.2")!, SemVer("1.0.0-beta.11")!)
        XCTAssertLessThan(SemVer("1.0.0-beta.11")!, SemVer("1.0.0-rc.1")!)
        XCTAssertLessThan(SemVer("1.0.0-rc.1")!, SemVer("1.0.0")!)
        
        
        // Proof of fix of #7 https://github.com/RougeWare/Swift-SemVer/issues/7
        XCTAssertTrue(SemVer(10,0,0) < SemVer(11,0,0))
        XCTAssertTrue(SemVer(11,0,0) > SemVer(10,0,0))
    }
    
    
    func testEquivalence() {
        XCTAssertEqual(SemVer(major: 1, minor: 0, patch: 0), SemVer(major: 1, minor: 0, patch: 0))
        XCTAssertEqual(SemVer("1.0.0"), SemVer(major: 1, minor: 0, patch: 0))
        XCTAssertEqual(SemVer("1.0.0"), SemVer("1.0.0"))
        // According to https://semver.org/spec/v2.0.0.html#spec-item-11, "Build metadata does not figure into precedence"
        XCTAssertEqual(SemVer("1.0+543"), SemVer("1.0+345"))
        XCTAssertEqual(SemVer(major: 2, minor: 0, patch: 0, preRelease: ["RC", 1]), SemVer(2,0,0, preRelease: ["RC",1]))
        XCTAssertEqual(SemVer(2,0,0, preRelease: ["RC",1]), SemVer("2.0.0-RC.1"))
        XCTAssertEqual(SemVer("2.0.0-RC.1"), SemVer("2.0.0-RC.1"))
        XCTAssertEqual(SemVer("2.0.0-RC.1+543"), SemVer(major: 2, minor: 0, patch: 0, preRelease: ["RC", 1], build: 543))
        XCTAssertEqual(SemVer("2.0.0-RC.1+543"), SemVer(major: 2, minor: 0, patch: 0, preRelease: ["RC", 1], build: "543"))
        XCTAssertEqual(SemVer("2.0.0-RC.1+543"), SemVer(major: 2, minor: 0, patch: 0, preRelease: ["RC", 1], build: [543]))
        XCTAssertEqual(SemVer("2.0.0-RC.1+543"), SemVer(major: 2, minor: 0, patch: 0, preRelease: ["RC", 1], build: ["543"]))
    }
    
    
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
    }
    
    
    func testBasicFixes() {
        XCTAssertEqual(SemVer(1,2,3), SemVer("01.2.3"))
        XCTAssertEqual(SemVer(1,2,3), SemVer("1.02.3"))
        XCTAssertEqual(SemVer(1,2,3), SemVer("1.2.03"))
    }
    

    static var allTests = [
        ("testDescription", testDescription),
        ("testFromString", testFromString),
        ("testPrecedence", testPrecedence),
        ("testEquivalence", testEquivalence),
        ("testInvalid", testInvalid),
        ("testBasicFixes", testBasicFixes),
    ]
}
