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
        isTesting = true
    }
    
    
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
    
    func testPrecedence() {
        
        // MARK: Less than
        
        XCTAssertLessThan(SemVer("0.0.1")!, SemVer("0.1.0")!)
        XCTAssertLessThan(SemVer("0.0.99999")!, SemVer("0.1.0")!)
        XCTAssertLessThan(SemVer("0.0.1")!, SemVer("1.0.0")!)
        XCTAssertLessThan(SemVer("0.1.0")!, SemVer("1.0.0")!)
        XCTAssertLessThan(SemVer("0.0.1")!, SemVer("1.1.0")!)
        XCTAssertLessThan(SemVer("0.1.0")!, SemVer("1.1.0")!)
        XCTAssertLessThan(SemVer("0.1.1")!, SemVer("1.1.0")!)
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
        
        // MARK: Greater than
        
        XCTAssertGreaterThan(SemVer("0.1.0")!, SemVer("0.0.1")!)
        XCTAssertGreaterThan(SemVer("0.1.0")!, SemVer("0.0.99999")!)
        XCTAssertGreaterThan(SemVer("1.0.0")!, SemVer("0.0.1")!)
        XCTAssertGreaterThan(SemVer("1.0.0")!, SemVer("0.1.0")!)
        XCTAssertGreaterThan(SemVer("1.1.0")!, SemVer("0.0.1")!)
        XCTAssertGreaterThan(SemVer("1.1.0")!, SemVer("0.1.0")!)
        XCTAssertGreaterThan(SemVer("1.1.0")!, SemVer("0.1.1")!)
        XCTAssertGreaterThan(SemVer("2.0.0")!, SemVer("1.0.0")!)
        XCTAssertGreaterThan(SemVer("2.1.0")!, SemVer("2.0.0")!)
        XCTAssertGreaterThan(SemVer("2.1.1")!, SemVer("2.1.0")!)
        XCTAssertGreaterThan(SemVer("12.0.0")!, SemVer("2.0.0")!)
        
        XCTAssertGreaterThan(SemVer("1.0.0")!, SemVer("1.0.0-alpha")!)
        XCTAssertGreaterThan(SemVer("1.0.0-alpha.1")!, SemVer("1.0.0-alpha")!)
        XCTAssertGreaterThan(SemVer("1.0.0-alpha.beta")!, SemVer("1.0.0-alpha.1")!)
        XCTAssertGreaterThan(SemVer("1.0.0-beta")!, SemVer("1.0.0-alpha.1")!)
        XCTAssertGreaterThan(SemVer("1.0.0-beta.2")!, SemVer("1.0.0-beta")!)
        XCTAssertGreaterThan(SemVer("1.0.0-beta.11")!, SemVer("1.0.0-beta.2")!)
        XCTAssertGreaterThan(SemVer("1.0.0-rc.1")!, SemVer("1.0.0-beta.11")!)
        XCTAssertGreaterThan(SemVer("1.0.0")!, SemVer("1.0.0-rc.1")!)
        
        
        // MARK: <
        
        XCTAssertTrue(SemVer("0.0.1")! < SemVer("0.1.0")!)
        XCTAssertTrue(SemVer("0.0.99999")! < SemVer("0.1.0")!)
        XCTAssertTrue(SemVer("0.0.1")! < SemVer("1.0.0")!)
        XCTAssertTrue(SemVer("0.1.0")! < SemVer("1.0.0")!)
        XCTAssertTrue(SemVer("0.0.1")! < SemVer("1.1.0")!)
        XCTAssertTrue(SemVer("0.1.0")! < SemVer("1.1.0")!)
        XCTAssertTrue(SemVer("0.1.1")! < SemVer("1.1.0")!)
        XCTAssertTrue(SemVer("1.0.0")! < SemVer("2.0.0")!)
        XCTAssertTrue(SemVer("2.0.0")! < SemVer("2.1.0")!)
        XCTAssertTrue(SemVer("2.1.0")! < SemVer("2.1.1")!)
        XCTAssertTrue(SemVer("2.0.0")! < SemVer("12.0.0")!)
        
        XCTAssertFalse(SemVer("0.0.1")! > SemVer("0.1.0")!)
        XCTAssertFalse(SemVer("0.0.99999")! > SemVer("0.1.0")!)
        XCTAssertFalse(SemVer("0.0.1")! > SemVer("1.0.0")!)
        XCTAssertFalse(SemVer("0.1.0")! > SemVer("1.0.0")!)
        XCTAssertFalse(SemVer("0.0.1")! > SemVer("1.1.0")!)
        XCTAssertFalse(SemVer("0.1.0")! > SemVer("1.1.0")!)
        XCTAssertFalse(SemVer("0.1.1")! > SemVer("1.1.0")!)
        XCTAssertFalse(SemVer("1.0.0")! > SemVer("2.0.0")!)
        XCTAssertFalse(SemVer("2.0.0")! > SemVer("2.1.0")!)
        XCTAssertFalse(SemVer("2.1.0")! > SemVer("2.1.1")!)
        XCTAssertFalse(SemVer("2.0.0")! > SemVer("12.0.0")!)
        
        XCTAssertTrue(SemVer("1.0.0-alpha")! < SemVer("1.0.0")!)
        XCTAssertTrue(SemVer("1.0.0-alpha")! < SemVer("1.0.0-alpha.1")!)
        XCTAssertTrue(SemVer("1.0.0-alpha.1")! < SemVer("1.0.0-alpha.beta")!)
        XCTAssertTrue(SemVer("1.0.0-alpha.1")! < SemVer("1.0.0-beta")!)
        XCTAssertTrue(SemVer("1.0.0-beta")! < SemVer("1.0.0-beta.2")!)
        XCTAssertTrue(SemVer("1.0.0-beta.2")! < SemVer("1.0.0-beta.11")!)
        XCTAssertTrue(SemVer("1.0.0-beta.11")! < SemVer("1.0.0-rc.1")!)
        XCTAssertTrue(SemVer("1.0.0-rc.1")! < SemVer("1.0.0")!)
        
        XCTAssertFalse(SemVer("1.0.0-alpha")! > SemVer("1.0.0")!)
        XCTAssertFalse(SemVer("1.0.0-alpha")! > SemVer("1.0.0-alpha.1")!)
        XCTAssertFalse(SemVer("1.0.0-alpha.1")! > SemVer("1.0.0-alpha.beta")!)
        XCTAssertFalse(SemVer("1.0.0-alpha.1")! > SemVer("1.0.0-beta")!)
        XCTAssertFalse(SemVer("1.0.0-beta")! > SemVer("1.0.0-beta.2")!)
        XCTAssertFalse(SemVer("1.0.0-beta.2")! > SemVer("1.0.0-beta.11")!)
        XCTAssertFalse(SemVer("1.0.0-beta.11")! > SemVer("1.0.0-rc.1")!)
        XCTAssertFalse(SemVer("1.0.0-rc.1")! > SemVer("1.0.0")!)
        
        // MARK: >
        
        XCTAssertTrue(SemVer("0.1.0")! > SemVer("0.0.1")!)
        XCTAssertTrue(SemVer("0.1.0")! > SemVer("0.0.99999")!)
        XCTAssertTrue(SemVer("1.0.0")! > SemVer("0.0.1")!)
        XCTAssertTrue(SemVer("1.0.0")! > SemVer("0.1.0")!)
        XCTAssertTrue(SemVer("1.1.0")! > SemVer("0.0.1")!)
        XCTAssertTrue(SemVer("1.1.0")! > SemVer("0.1.0")!)
        XCTAssertTrue(SemVer("1.1.0")! > SemVer("0.1.1")!)
        XCTAssertTrue(SemVer("2.0.0")! > SemVer("1.0.0")!)
        XCTAssertTrue(SemVer("2.1.0")! > SemVer("2.0.0")!)
        XCTAssertTrue(SemVer("2.1.1")! > SemVer("2.1.0")!)
        XCTAssertTrue(SemVer("12.0.0")! > SemVer("2.0.0")!)
        
        XCTAssertFalse(SemVer("0.1.0")! < SemVer("0.0.1")!)
        XCTAssertFalse(SemVer("0.1.0")! < SemVer("0.0.99999")!)
        XCTAssertFalse(SemVer("1.0.0")! < SemVer("0.0.1")!)
        XCTAssertFalse(SemVer("1.0.0")! < SemVer("0.1.0")!)
        XCTAssertFalse(SemVer("1.1.0")! < SemVer("0.0.1")!)
        XCTAssertFalse(SemVer("1.1.0")! < SemVer("0.1.0")!)
        XCTAssertFalse(SemVer("1.1.0")! < SemVer("0.1.1")!)
        XCTAssertFalse(SemVer("2.0.0")! < SemVer("1.0.0")!)
        XCTAssertFalse(SemVer("2.1.0")! < SemVer("2.0.0")!)
        XCTAssertFalse(SemVer("2.1.1")! < SemVer("2.1.0")!)
        XCTAssertFalse(SemVer("12.0.0")! < SemVer("2.0.0")!)
        
        XCTAssertTrue(SemVer("1.0.0")! > SemVer("1.0.0-alpha")!)
        XCTAssertTrue(SemVer("1.0.0-alpha.1")! > SemVer("1.0.0-alpha")!)
        XCTAssertTrue(SemVer("1.0.0-alpha.beta")! > SemVer("1.0.0-alpha.1")!)
        XCTAssertTrue(SemVer("1.0.0-beta")! > SemVer("1.0.0-alpha.1")!)
        XCTAssertTrue(SemVer("1.0.0-beta.2")! > SemVer("1.0.0-beta")!)
        XCTAssertTrue(SemVer("1.0.0-beta.11")! > SemVer("1.0.0-beta.2")!)
        XCTAssertTrue(SemVer("1.0.0-rc.1")! > SemVer("1.0.0-beta.11")!)
        XCTAssertTrue(SemVer("1.0.0")! > SemVer("1.0.0-rc.1")!)
        
        XCTAssertFalse(SemVer("1.0.0")! < SemVer("1.0.0-alpha")!)
        XCTAssertFalse(SemVer("1.0.0-alpha.1")! < SemVer("1.0.0-alpha")!)
        XCTAssertFalse(SemVer("1.0.0-alpha.beta")! < SemVer("1.0.0-alpha.1")!)
        XCTAssertFalse(SemVer("1.0.0-beta")! < SemVer("1.0.0-alpha.1")!)
        XCTAssertFalse(SemVer("1.0.0-beta.2")! < SemVer("1.0.0-beta")!)
        XCTAssertFalse(SemVer("1.0.0-beta.11")! < SemVer("1.0.0-beta.2")!)
        XCTAssertFalse(SemVer("1.0.0-rc.1")! < SemVer("1.0.0-beta.11")!)
        XCTAssertFalse(SemVer("1.0.0")! < SemVer("1.0.0-rc.1")!)
        
        
        // MARK: Proof of fix of #7
        // https://github.com/RougeWare/Swift-SemVer/issues/7
        XCTAssertTrue(SemVer(10,0,0)! < SemVer(11,0,0)!)
        XCTAssertTrue(SemVer(11,0,0)! > SemVer(10,0,0)!)
        
        XCTAssertFalse(SemVer(10,0,0)! > SemVer(11,0,0)!)
        XCTAssertFalse(SemVer(11,0,0)! < SemVer(10,0,0)!)
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
        
        // Proof of fix of #14: https://github.com/RougeWare/Swift-SemVer/issues/14
        XCTAssertNil(SemVer(1,0,0, preRelease: "01"))
        XCTAssertNil(SemVer("1.0.0-01"))
        XCTAssertNil(SemVer("1.0.0-01.02.03"))
        
        XCTAssertNil(SemVer("01.2.3"))
        XCTAssertNil(SemVer("1.02.3"))
        XCTAssertNil(SemVer("1.2.03"))
    }
    
    
    func testAdvancedEquality() {
        XCTAssertEqual(SemVer(1,2,3), SemVer("1.2.3"))
        XCTAssertEqual(SemVer(1,2,3), SemVer("1.2.3+12"))
        XCTAssertEqual(SemVer(1,2,3, build: 12), SemVer("1.2.3"))
        XCTAssertEqual(SemVer(1,2,3, build: 12), SemVer(1,2,3))
        XCTAssertEqual(SemVer(1,2,3, build: 12), SemVer("1.2.3+12"))
    }
    

    static let allTests = [
        ("testDescription", testDescription),
        ("testFromString", testFromString),
        ("testPrecedence", testPrecedence),
        ("testEquivalence", testEquivalence),
        ("testInvalid", testInvalid),
        ("testAdvancedEquality", testAdvancedEquality),
    ]
}
