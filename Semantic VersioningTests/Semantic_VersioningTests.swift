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
    }
    
    
    @available(OSX 10.13, *)
    func testFromString() {
        XCTAssertEqual(SemVer("1.2.3-RC.4+567"), SemVer(major: 1, minor: 2, patch: 3, preRelease: SemanticVersionPreRelease(identifiers: ["RC", "4"]), build: SemanticVersionBuild(identifiers: ["567"])))
    }
}
