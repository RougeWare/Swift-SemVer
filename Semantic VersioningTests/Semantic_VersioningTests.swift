//
//  Semantic_VersioningTests.swift
//  Semantic VersioningTests
//
//  Created by Personal on 1/9/18.
//  Copyright © 2018 Ben Leggiero. All rights reserved.
//

import XCTest
@testable import Semantic_Versioning

class Semantic_VersioningTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testDescription() {
        XCTAssertEqual(SemVer(01,2,3,"RC.4",567).description, "1.2.3-RC.4+567")
        XCTAssertEqual(SemVer(01,2,3,["RC","4"],567).description, "1.2.3-RC.4+567")
        XCTAssertEqual(SemVer(01,2,3,["RC","4"],[567]).description, "1.2.3-RC.4+567")
        XCTAssertEqual(SemVer("1.2.3-RC.4+567")?.description, "1.2.3-RC.4+567")
    }
    
    
    func testFromString() {
        XCTAssertEqual(SemVer("1.2"), SemVer(major: 1, minor: 2))
        XCTAssertEqual(SemVer("1.2.3"), SemVer(major: 1, minor: 2, patch: 3))
        XCTAssertEqual(SemVer("1.2.3-RC"), SemVer(major: 1, minor: 2, patch: 3, preRelease: SemanticVersionPreRelease(identifiers: ["RC"])))
        XCTAssertEqual(SemVer("1.2.3-4"), SemVer(major: 1, minor: 2, patch: 3, preRelease: SemanticVersionPreRelease(identifiers: [4])))
        XCTAssertEqual(SemVer("1.2.3+567.8"), SemVer(major: 1, minor: 2, patch: 3, build: SemanticVersionBuild(identifiers: [567])))
        XCTAssertEqual(SemVer("1.2-RC.4+567.8"), SemVer(major: 1, minor: 2, preRelease: SemanticVersionPreRelease(identifiers: ["RC", "4"]), build: SemanticVersionBuild(identifiers: ["567", "8"])))
        XCTAssertEqual(SemVer("1.2.3-RC.4+567.8"), SemVer(major: 1, minor: 2, patch: 3, preRelease: SemanticVersionPreRelease(identifiers: ["RC", "4"]), build: SemanticVersionBuild(identifiers: ["567", "8"])))
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
    }
}
