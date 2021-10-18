//
//  SemVer mutations tests.swift
//  SemVer
//
//  Created by Ky Leggiero on 2021-10-12.
//  Copyright © 2021 Ben Leggiero BH-1-PS.
//

import XCTest
import SemVer



class SemVerMutationTests: SemVerTestClass {
    
    
    // MARK: - Increment
    
    func testIncrementMajorVersion() {
        
        var versions = Versions()
        
        versions.v0_0_0.major += 1
        XCTAssertEqual(versions.v0_0_0, SemVer(1,0,0))
        
        versions.v0_0_1.major += 1
        XCTAssertEqual(versions.v0_0_1, SemVer(1,0,0))
        
        versions.v0_0_999.major += 1
        XCTAssertEqual(versions.v0_0_999, SemVer(1,0,0))
        
        versions.v0_1_0.major += 1
        XCTAssertEqual(versions.v0_1_0, SemVer(1,0,0))
        
        versions.v0_1_999.major += 1
        XCTAssertEqual(versions.v0_1_999, SemVer(1,0,0))
        
        versions.v0_999_0.major += 1
        XCTAssertEqual(versions.v0_999_0, SemVer(1,0,0))
        
        versions.v0_999_1.major += 1
        XCTAssertEqual(versions.v0_999_1, SemVer(1,0,0))
        
        versions.v0_999_999.major += 1
        XCTAssertEqual(versions.v0_999_999, SemVer(1,0,0))
        
        
        versions.v1_0_0.major += 1
        XCTAssertEqual(versions.v1_0_0, SemVer(2,0,0))
        
        versions.v1_0_1.major += 1
        XCTAssertEqual(versions.v1_0_1, SemVer(2,0,0))
        
        versions.v1_0_999.major += 1
        XCTAssertEqual(versions.v1_0_999, SemVer(2,0,0))
        
        versions.v1_1_0.major += 1
        XCTAssertEqual(versions.v1_1_0, SemVer(2,0,0))
        
        versions.v1_1_999.major += 1
        XCTAssertEqual(versions.v1_1_999, SemVer(2,0,0))
        
        versions.v1_999_0.major += 1
        XCTAssertEqual(versions.v1_999_0, SemVer(2,0,0))
        
        versions.v1_999_1.major += 1
        XCTAssertEqual(versions.v1_999_1, SemVer(2,0,0))
        
        versions.v1_999_999.major += 1
        XCTAssertEqual(versions.v1_999_999, SemVer(2,0,0))
        
        
        versions.v2_0_0.major += 1
        XCTAssertEqual(versions.v2_0_0, SemVer(3,0,0))
        
        versions.v2_0_1.major += 1
        XCTAssertEqual(versions.v2_0_1, SemVer(3,0,0))
        
        versions.v2_0_999.major += 1
        XCTAssertEqual(versions.v2_0_999, SemVer(3,0,0))
        
        versions.v2_1_0.major += 1
        XCTAssertEqual(versions.v2_1_0, SemVer(3,0,0))
        
        versions.v2_1_999.major += 1
        XCTAssertEqual(versions.v2_1_999, SemVer(3,0,0))
        
        versions.v2_999_0.major += 1
        XCTAssertEqual(versions.v2_999_0, SemVer(3,0,0))
        
        versions.v2_999_1.major += 1
        XCTAssertEqual(versions.v2_999_1, SemVer(3,0,0))
        
        versions.v2_999_999.major += 1
        XCTAssertEqual(versions.v2_999_999, SemVer(3,0,0))
        
        
        versions.v999_0_0.major += 1
        XCTAssertEqual(versions.v999_0_0, SemVer(1000,0,0))
        
        versions.v999_0_1.major += 1
        XCTAssertEqual(versions.v999_0_1, SemVer(1000,0,0))
        
        versions.v999_0_999.major += 1
        XCTAssertEqual(versions.v999_0_999, SemVer(1000,0,0))
        
        versions.v999_1_0.major += 1
        XCTAssertEqual(versions.v999_1_0, SemVer(1000,0,0))
        
        versions.v999_1_999.major += 1
        XCTAssertEqual(versions.v999_1_999, SemVer(1000,0,0))
        
        versions.v999_999_0.major += 1
        XCTAssertEqual(versions.v999_999_0, SemVer(1000,0,0))
        
        versions.v999_999_1.major += 1
        XCTAssertEqual(versions.v999_999_1, SemVer(1000,0,0))
        
        versions.v999_999_999.major += 1
        XCTAssertEqual(versions.v999_999_999, SemVer(1000,0,0))
    }
    
    
    func testIncrementMinorVersion() {
        
        var versions = Versions()
        
        versions.v0_0_0.minor += 1
        XCTAssertEqual(versions.v0_0_0, SemVer(0,1,0))
        
        versions.v0_0_1.minor += 1
        XCTAssertEqual(versions.v0_0_1, SemVer(0,1,0))
        
        versions.v0_0_999.minor += 1
        XCTAssertEqual(versions.v0_0_999, SemVer(0,1,0))
        
        versions.v0_1_0.minor += 1
        XCTAssertEqual(versions.v0_1_0, SemVer(0,2,0))
        
        versions.v0_1_999.minor += 1
        XCTAssertEqual(versions.v0_1_999, SemVer(0,2,0))
        
        versions.v0_999_0.minor += 1
        XCTAssertEqual(versions.v0_999_0, SemVer(0,1000,0))
        
        versions.v0_999_1.minor += 1
        XCTAssertEqual(versions.v0_999_1, SemVer(0,1000,0))
        
        versions.v0_999_999.minor += 1
        XCTAssertEqual(versions.v0_999_999, SemVer(0,1000,0))
        
        
        versions.v1_0_0.minor += 1
        XCTAssertEqual(versions.v1_0_0, SemVer(1,1,0))
        
        versions.v1_0_1.minor += 1
        XCTAssertEqual(versions.v1_0_1, SemVer(1,1,0))
        
        versions.v1_0_999.minor += 1
        XCTAssertEqual(versions.v1_0_999, SemVer(1,1,0))
        
        versions.v1_1_0.minor += 1
        XCTAssertEqual(versions.v1_1_0, SemVer(1,2,0))
        
        versions.v1_1_999.minor += 1
        XCTAssertEqual(versions.v1_1_999, SemVer(1,2,0))
        
        versions.v1_999_0.minor += 1
        XCTAssertEqual(versions.v1_999_0, SemVer(1,1000,0))
        
        versions.v1_999_1.minor += 1
        XCTAssertEqual(versions.v1_999_1, SemVer(1,1000,0))
        
        versions.v1_999_999.minor += 1
        XCTAssertEqual(versions.v1_999_999, SemVer(1,1000,0))
        
        
        versions.v2_0_0.minor += 1
        XCTAssertEqual(versions.v2_0_0, SemVer(2,1,0))
        
        versions.v2_0_1.minor += 1
        XCTAssertEqual(versions.v2_0_1, SemVer(2,1,0))
        
        versions.v2_0_999.minor += 1
        XCTAssertEqual(versions.v2_0_999, SemVer(2,1,0))
        
        versions.v2_1_0.minor += 1
        XCTAssertEqual(versions.v2_1_0, SemVer(2,2,0))
        
        versions.v2_1_999.minor += 1
        XCTAssertEqual(versions.v2_1_999, SemVer(2,2,0))
        
        versions.v2_999_0.minor += 1
        XCTAssertEqual(versions.v2_999_0, SemVer(2,1000,0))
        
        versions.v2_999_1.minor += 1
        XCTAssertEqual(versions.v2_999_1, SemVer(2,1000,0))
        
        versions.v2_999_999.minor += 1
        XCTAssertEqual(versions.v2_999_999, SemVer(2,1000,0))
        
        
        versions.v999_0_0.minor += 1
        XCTAssertEqual(versions.v999_0_0, SemVer(999,1,0))
        
        versions.v999_0_1.minor += 1
        XCTAssertEqual(versions.v999_0_1, SemVer(999,1,0))
        
        versions.v999_0_999.minor += 1
        XCTAssertEqual(versions.v999_0_999, SemVer(999,1,0))
        
        versions.v999_1_0.minor += 1
        XCTAssertEqual(versions.v999_1_0, SemVer(999,2,0))
        
        versions.v999_1_999.minor += 1
        XCTAssertEqual(versions.v999_1_999, SemVer(999,2,0))
        
        versions.v999_999_0.minor += 1
        XCTAssertEqual(versions.v999_999_0, SemVer(999,1000,0))
        
        versions.v999_999_1.minor += 1
        XCTAssertEqual(versions.v999_999_1, SemVer(999,1000,0))
        
        versions.v999_999_999.minor += 1
        XCTAssertEqual(versions.v999_999_999, SemVer(999,1000,0))
    }
    
    
    func testIncrementPatchVersion() {
        
        var versions = Versions()
        
        versions.v0_0_0.patch += 1
        XCTAssertEqual(versions.v0_0_0, SemVer(0,0,1))
        
        versions.v0_0_1.patch += 1
        XCTAssertEqual(versions.v0_0_1, SemVer(0,0,2))
        
        versions.v0_0_999.patch += 1
        XCTAssertEqual(versions.v0_0_999, SemVer(0,0,1000))
        
        versions.v0_1_0.patch += 1
        XCTAssertEqual(versions.v0_1_0, SemVer(0,1,1))
        
        versions.v0_1_999.patch += 1
        XCTAssertEqual(versions.v0_1_999, SemVer(0,1,1000))
        
        versions.v0_999_0.patch += 1
        XCTAssertEqual(versions.v0_999_0, SemVer(0,999,1))
        
        versions.v0_999_1.patch += 1
        XCTAssertEqual(versions.v0_999_1, SemVer(0,999,2))
        
        versions.v0_999_999.patch += 1
        XCTAssertEqual(versions.v0_999_999, SemVer(0,999,1000))
        
        
        versions.v1_0_0.patch += 1
        XCTAssertEqual(versions.v1_0_0, SemVer(1,0,1))
        
        versions.v1_0_1.patch += 1
        XCTAssertEqual(versions.v1_0_1, SemVer(1,0,2))
        
        versions.v1_0_999.patch += 1
        XCTAssertEqual(versions.v1_0_999, SemVer(1,0,1000))
        
        versions.v1_1_0.patch += 1
        XCTAssertEqual(versions.v1_1_0, SemVer(1,1,1))
        
        versions.v1_1_999.patch += 1
        XCTAssertEqual(versions.v1_1_999, SemVer(1,1,1000))
        
        versions.v1_999_0.patch += 1
        XCTAssertEqual(versions.v1_999_0, SemVer(1,999,1))
        
        versions.v1_999_1.patch += 1
        XCTAssertEqual(versions.v1_999_1, SemVer(1,999,2))
        
        versions.v1_999_999.patch += 1
        XCTAssertEqual(versions.v1_999_999, SemVer(1,999,1000))
        
        
        versions.v2_0_0.patch += 1
        XCTAssertEqual(versions.v2_0_0, SemVer(2,0,1))
        
        versions.v2_0_1.patch += 1
        XCTAssertEqual(versions.v2_0_1, SemVer(2,0,2))
        
        versions.v2_0_999.patch += 1
        XCTAssertEqual(versions.v2_0_999, SemVer(2,0,1000))
        
        versions.v2_1_0.patch += 1
        XCTAssertEqual(versions.v2_1_0, SemVer(2,1,1))
        
        versions.v2_1_999.patch += 1
        XCTAssertEqual(versions.v2_1_999, SemVer(2,1,1000))
        
        versions.v2_999_0.patch += 1
        XCTAssertEqual(versions.v2_999_0, SemVer(2,999,1))
        
        versions.v2_999_1.patch += 1
        XCTAssertEqual(versions.v2_999_1, SemVer(2,999,2))
        
        versions.v2_999_999.patch += 1
        XCTAssertEqual(versions.v2_999_999, SemVer(2,999,1000))
        
        
        versions.v999_0_0.patch += 1
        XCTAssertEqual(versions.v999_0_0, SemVer(999,0,1))
        
        versions.v999_0_1.patch += 1
        XCTAssertEqual(versions.v999_0_1, SemVer(999,0,2))
        
        versions.v999_0_999.patch += 1
        XCTAssertEqual(versions.v999_0_999, SemVer(999,0,1000))
        
        versions.v999_1_0.patch += 1
        XCTAssertEqual(versions.v999_1_0, SemVer(999,1,1))
        
        versions.v999_1_999.patch += 1
        XCTAssertEqual(versions.v999_1_999, SemVer(999,1,1000))
        
        versions.v999_999_0.patch += 1
        XCTAssertEqual(versions.v999_999_0, SemVer(999,999,1))
        
        versions.v999_999_1.patch += 1
        XCTAssertEqual(versions.v999_999_1, SemVer(999,999,2))
        
        versions.v999_999_999.patch += 1
        XCTAssertEqual(versions.v999_999_999, SemVer(999,999,1000))
    }
    
    
    // MARK: - Set to identity
    
    func testIdentityMajorVersion() {
        
        var versions = Versions()
        
        versions.v0_0_0.major = 0
        XCTAssertEqual(versions.v0_0_0, SemVer(0,0,0))
        
        versions.v0_0_1.major = 0
        XCTAssertEqual(versions.v0_0_1, SemVer(0,0,1))
        
        versions.v0_0_999.major = 0
        XCTAssertEqual(versions.v0_0_999, SemVer(0,0,999))
        
        versions.v0_1_0.major = 0
        XCTAssertEqual(versions.v0_1_0, SemVer(0,1,0))
        
        versions.v0_1_999.major = 0
        XCTAssertEqual(versions.v0_1_999, SemVer(0,1,999))
        
        versions.v0_999_0.major = 0
        XCTAssertEqual(versions.v0_999_0, SemVer(0,999,0))
        
        versions.v0_999_1.major = 0
        XCTAssertEqual(versions.v0_999_1, SemVer(0,999,1))
        
        versions.v0_999_999.major = 0
        XCTAssertEqual(versions.v0_999_999, SemVer(0,999,999))
        
        
        versions.v1_0_0.major = 1
        XCTAssertEqual(versions.v1_0_0, SemVer(1,0,0))
        
        versions.v1_0_1.major = 1
        XCTAssertEqual(versions.v1_0_1, SemVer(1,0,1))
        
        versions.v1_0_999.major = 1
        XCTAssertEqual(versions.v1_0_999, SemVer(1,0,999))
        
        versions.v1_1_0.major = 1
        XCTAssertEqual(versions.v1_1_0, SemVer(1,1,0))
        
        versions.v1_1_999.major = 1
        XCTAssertEqual(versions.v1_1_999, SemVer(1,1,999))
        
        versions.v1_999_0.major = 1
        XCTAssertEqual(versions.v1_999_0, SemVer(1,999,0))
        
        versions.v1_999_1.major = 1
        XCTAssertEqual(versions.v1_999_1, SemVer(1,999,1))
        
        versions.v1_999_999.major = 1
        XCTAssertEqual(versions.v1_999_999, SemVer(1,999,999))
        
        
        versions.v2_0_0.major = 2
        XCTAssertEqual(versions.v2_0_0, SemVer(2,0,0))
        
        versions.v2_0_1.major = 2
        XCTAssertEqual(versions.v2_0_1, SemVer(2,0,1))
        
        versions.v2_0_999.major = 2
        XCTAssertEqual(versions.v2_0_999, SemVer(2,0,999))
        
        versions.v2_1_0.major = 2
        XCTAssertEqual(versions.v2_1_0, SemVer(2,1,0))
        
        versions.v2_1_999.major = 2
        XCTAssertEqual(versions.v2_1_999, SemVer(2,1,999))
        
        versions.v2_999_0.major = 2
        XCTAssertEqual(versions.v2_999_0, SemVer(2,999,0))
        
        versions.v2_999_1.major = 2
        XCTAssertEqual(versions.v2_999_1, SemVer(2,999,1))
        
        versions.v2_999_999.major = 2
        XCTAssertEqual(versions.v2_999_999, SemVer(2,999,999))
        
        
        versions.v999_0_0.major = 9
        XCTAssertEqual(versions.v999_0_0, SemVer(999,0,0))
        
        versions.v999_0_1.major = 9
        XCTAssertEqual(versions.v999_0_1, SemVer(999,0,1))
        
        versions.v999_0_999.major = 9
        XCTAssertEqual(versions.v999_0_999, SemVer(999,0,999))
        
        versions.v999_1_0.major = 9
        XCTAssertEqual(versions.v999_1_0, SemVer(999,1,0))
        
        versions.v999_1_999.major = 9
        XCTAssertEqual(versions.v999_1_999, SemVer(999,1,999))
        
        versions.v999_999_0.major = 9
        XCTAssertEqual(versions.v999_999_0, SemVer(999,999,0))
        
        versions.v999_999_1.major = 9
        XCTAssertEqual(versions.v999_999_1, SemVer(999,999,1))
        
        versions.v999_999_999.major = 9
        XCTAssertEqual(versions.v999_999_999, SemVer(999,999,999))
    }
    
    
    func testIdentityMinorVersion() {
        
        var versions = Versions()
        
        versions.v0_0_0.minor = 0
        XCTAssertEqual(versions.v0_0_0, SemVer(0,0,0))
        
        versions.v0_0_1.minor = 0
        XCTAssertEqual(versions.v0_0_1, SemVer(0,0,1))
        
        versions.v0_0_999.minor = 0
        XCTAssertEqual(versions.v0_0_999, SemVer(0,0,999))
        
        versions.v0_1_0.minor = 1
        XCTAssertEqual(versions.v0_1_0, SemVer(0,1,0))
        
        versions.v0_1_999.minor = 1
        XCTAssertEqual(versions.v0_1_999, SemVer(0,1,999))
        
        versions.v0_999_0.minor = 9
        XCTAssertEqual(versions.v0_999_0, SemVer(0,999,0))
        
        versions.v0_999_1.minor = 9
        XCTAssertEqual(versions.v0_999_1, SemVer(0,999,1))
        
        versions.v0_999_999.minor = 9
        XCTAssertEqual(versions.v0_999_999, SemVer(0,999,999))
        
        
        versions.v1_0_0.minor = 0
        XCTAssertEqual(versions.v1_0_0, SemVer(1,0,0))
        
        versions.v1_0_1.minor = 0
        XCTAssertEqual(versions.v1_0_1, SemVer(1,0,1))
        
        versions.v1_0_999.minor = 0
        XCTAssertEqual(versions.v1_0_999, SemVer(1,0,999))
        
        versions.v1_1_0.minor = 1
        XCTAssertEqual(versions.v1_1_0, SemVer(1,1,0))
        
        versions.v1_1_999.minor = 1
        XCTAssertEqual(versions.v1_1_999, SemVer(1,1,999))
        
        versions.v1_999_0.minor = 9
        XCTAssertEqual(versions.v1_999_0, SemVer(1,999,0))
        
        versions.v1_999_1.minor = 9
        XCTAssertEqual(versions.v1_999_1, SemVer(1,999,1))
        
        versions.v1_999_999.minor = 9
        XCTAssertEqual(versions.v1_999_999, SemVer(1,999,999))
        
        
        versions.v2_0_0.minor = 0
        XCTAssertEqual(versions.v2_0_0, SemVer(2,0,0))
        
        versions.v2_0_1.minor = 0
        XCTAssertEqual(versions.v2_0_1, SemVer(2,0,1))
        
        versions.v2_0_999.minor = 0
        XCTAssertEqual(versions.v2_0_999, SemVer(2,0,999))
        
        versions.v2_1_0.minor = 1
        XCTAssertEqual(versions.v2_1_0, SemVer(2,1,0))
        
        versions.v2_1_999.minor = 1
        XCTAssertEqual(versions.v2_1_999, SemVer(2,1,999))
        
        versions.v2_999_0.minor = 9
        XCTAssertEqual(versions.v2_999_0, SemVer(2,999,0))
        
        versions.v2_999_1.minor = 9
        XCTAssertEqual(versions.v2_999_1, SemVer(2,999,1))
        
        versions.v2_999_999.minor = 9
        XCTAssertEqual(versions.v2_999_999, SemVer(2,999,999))
        
        
        versions.v999_0_0.minor = 0
        XCTAssertEqual(versions.v999_0_0, SemVer(999,0,0))
        
        versions.v999_0_1.minor = 0
        XCTAssertEqual(versions.v999_0_1, SemVer(999,0,1))
        
        versions.v999_0_999.minor = 0
        XCTAssertEqual(versions.v999_0_999, SemVer(999,0,999))
        
        versions.v999_1_0.minor = 1
        XCTAssertEqual(versions.v999_1_0, SemVer(999,1,0))
        
        versions.v999_1_999.minor = 1
        XCTAssertEqual(versions.v999_1_999, SemVer(999,1,999))
        
        versions.v999_999_0.minor = 9
        XCTAssertEqual(versions.v999_999_0, SemVer(999,999,0))
        
        versions.v999_999_1.minor = 9
        XCTAssertEqual(versions.v999_999_1, SemVer(999,999,1))
        
        versions.v999_999_999.minor = 9
        XCTAssertEqual(versions.v999_999_999, SemVer(999,999,999))
    }
    
    
    func testIdentityPatchVersion() {
        
        var versions = Versions()
        
        versions.v0_0_0.patch = 0
        XCTAssertEqual(versions.v0_0_0, SemVer(0,0,0))
        
        versions.v0_0_1.patch = 1
        XCTAssertEqual(versions.v0_0_1, SemVer(0,0,1))
        
        versions.v0_0_999.patch = 999
        XCTAssertEqual(versions.v0_0_999, SemVer(0,0,999))
        
        versions.v0_1_0.patch = 0
        XCTAssertEqual(versions.v0_1_0, SemVer(0,1,0))
        
        versions.v0_1_999.patch = 999
        XCTAssertEqual(versions.v0_1_999, SemVer(0,1,999))
        
        versions.v0_999_0.patch = 0
        XCTAssertEqual(versions.v0_999_0, SemVer(0,999,0))
        
        versions.v0_999_1.patch = 1
        XCTAssertEqual(versions.v0_999_1, SemVer(0,999,1))
        
        versions.v0_999_999.patch = 999
        XCTAssertEqual(versions.v0_999_999, SemVer(0,999,999))
        
        
        versions.v1_0_0.patch = 0
        XCTAssertEqual(versions.v1_0_0, SemVer(1,0,0))
        
        versions.v1_0_1.patch = 1
        XCTAssertEqual(versions.v1_0_1, SemVer(1,0,1))
        
        versions.v1_0_999.patch = 999
        XCTAssertEqual(versions.v1_0_999, SemVer(1,0,999))
        
        versions.v1_1_0.patch = 0
        XCTAssertEqual(versions.v1_1_0, SemVer(1,1,0))
        
        versions.v1_1_999.patch = 999
        XCTAssertEqual(versions.v1_1_999, SemVer(1,1,999))
        
        versions.v1_999_0.patch = 0
        XCTAssertEqual(versions.v1_999_0, SemVer(1,999,0))
        
        versions.v1_999_1.patch = 1
        XCTAssertEqual(versions.v1_999_1, SemVer(1,999,1))
        
        versions.v1_999_999.patch = 999
        XCTAssertEqual(versions.v1_999_999, SemVer(1,999,999))
        
        
        versions.v2_0_0.patch = 0
        XCTAssertEqual(versions.v2_0_0, SemVer(2,0,0))
        
        versions.v2_0_1.patch = 1
        XCTAssertEqual(versions.v2_0_1, SemVer(2,0,1))
        
        versions.v2_0_999.patch = 999
        XCTAssertEqual(versions.v2_0_999, SemVer(2,0,999))
        
        versions.v2_1_0.patch = 0
        XCTAssertEqual(versions.v2_1_0, SemVer(2,1,0))
        
        versions.v2_1_999.patch = 999
        XCTAssertEqual(versions.v2_1_999, SemVer(2,1,999))
        
        versions.v2_999_0.patch = 0
        XCTAssertEqual(versions.v2_999_0, SemVer(2,999,0))
        
        versions.v2_999_1.patch = 1
        XCTAssertEqual(versions.v2_999_1, SemVer(2,999,1))
        
        versions.v2_999_999.patch = 999
        XCTAssertEqual(versions.v2_999_999, SemVer(2,999,999))
        
        
        versions.v999_0_0.patch = 0
        XCTAssertEqual(versions.v999_0_0, SemVer(999,0,0))
        
        versions.v999_0_1.patch = 1
        XCTAssertEqual(versions.v999_0_1, SemVer(999,0,1))
        
        versions.v999_0_999.patch = 999
        XCTAssertEqual(versions.v999_0_999, SemVer(999,0,999))
        
        versions.v999_1_0.patch = 0
        XCTAssertEqual(versions.v999_1_0, SemVer(999,1,0))
        
        versions.v999_1_999.patch = 999
        XCTAssertEqual(versions.v999_1_999, SemVer(999,1,999))
        
        versions.v999_999_0.patch = 0
        XCTAssertEqual(versions.v999_999_0, SemVer(999,999,0))
        
        versions.v999_999_1.patch = 1
        XCTAssertEqual(versions.v999_999_1, SemVer(999,999,1))
        
        versions.v999_999_999.patch = 999
        XCTAssertEqual(versions.v999_999_999, SemVer(999,999,999))
    }
    
    
    // MARK: - Decrement
    
    // I've commented-out tests which would cause a Swift runtime arithmetic overflow, since those always crash
    
    func testDecrementMajorVersion() {
        
        var versions = Versions()
        
//        versions.v0_0_0.major -= 1
//        XCTAssertEqual(versions.v0_0_0, SemVer(0,0,0))
//
//        versions.v0_0_1.major -= 1
//        XCTAssertEqual(versions.v0_0_1, SemVer(0,0,1))
//
//        versions.v0_0_999.major -= 1
//        XCTAssertEqual(versions.v0_0_999, SemVer(0,0,999))
//
//        versions.v0_1_0.major -= 1
//        XCTAssertEqual(versions.v0_1_0, SemVer(0,1,0))
//
//        versions.v0_1_999.major -= 1
//        XCTAssertEqual(versions.v0_1_999, SemVer(0,1,999))
//
//        versions.v0_999_0.major -= 1
//        XCTAssertEqual(versions.v0_999_0, SemVer(0,999,0))
//
//        versions.v0_999_1.major -= 1
//        XCTAssertEqual(versions.v0_999_1, SemVer(0,999,1))
//
//        versions.v0_999_999.major -= 1
//        XCTAssertEqual(versions.v0_999_999, SemVer(0,999,999))
        
        
        versions.v1_0_0.major -= 1
        XCTAssertEqual(versions.v1_0_0, SemVer(1,0,0))
        
        versions.v1_0_1.major -= 1
        XCTAssertEqual(versions.v1_0_1, SemVer(1,0,1))
        
        versions.v1_0_999.major -= 1
        XCTAssertEqual(versions.v1_0_999, SemVer(1,0,999))
        
        versions.v1_1_0.major -= 1
        XCTAssertEqual(versions.v1_1_0, SemVer(1,1,0))
        
        versions.v1_1_999.major -= 1
        XCTAssertEqual(versions.v1_1_999, SemVer(1,1,999))
        
        versions.v1_999_0.major -= 1
        XCTAssertEqual(versions.v1_999_0, SemVer(1,999,0))
        
        versions.v1_999_1.major -= 1
        XCTAssertEqual(versions.v1_999_1, SemVer(1,999,1))
        
        versions.v1_999_999.major -= 1
        XCTAssertEqual(versions.v1_999_999, SemVer(1,999,999))
        
        
        versions.v2_0_0.major -= 1
        XCTAssertEqual(versions.v2_0_0, SemVer(2,0,0))
        
        versions.v2_0_1.major -= 1
        XCTAssertEqual(versions.v2_0_1, SemVer(2,0,1))
        
        versions.v2_0_999.major -= 1
        XCTAssertEqual(versions.v2_0_999, SemVer(2,0,999))
        
        versions.v2_1_0.major -= 1
        XCTAssertEqual(versions.v2_1_0, SemVer(2,1,0))
        
        versions.v2_1_999.major -= 1
        XCTAssertEqual(versions.v2_1_999, SemVer(2,1,999))
        
        versions.v2_999_0.major -= 1
        XCTAssertEqual(versions.v2_999_0, SemVer(2,999,0))
        
        versions.v2_999_1.major -= 1
        XCTAssertEqual(versions.v2_999_1, SemVer(2,999,1))
        
        versions.v2_999_999.major -= 1
        XCTAssertEqual(versions.v2_999_999, SemVer(2,999,999))
        
        
        versions.v999_0_0.major -= 1
        XCTAssertEqual(versions.v999_0_0, SemVer(999,0,0))
        
        versions.v999_0_1.major -= 1
        XCTAssertEqual(versions.v999_0_1, SemVer(999,0,1))
        
        versions.v999_0_999.major -= 1
        XCTAssertEqual(versions.v999_0_999, SemVer(999,0,999))
        
        versions.v999_1_0.major -= 1
        XCTAssertEqual(versions.v999_1_0, SemVer(999,1,0))
        
        versions.v999_1_999.major -= 1
        XCTAssertEqual(versions.v999_1_999, SemVer(999,1,999))
        
        versions.v999_999_0.major -= 1
        XCTAssertEqual(versions.v999_999_0, SemVer(999,999,0))
        
        versions.v999_999_1.major -= 1
        XCTAssertEqual(versions.v999_999_1, SemVer(999,999,1))
        
        versions.v999_999_999.major -= 1
        XCTAssertEqual(versions.v999_999_999, SemVer(999,999,999))
    }
    
    
    func testDecrementMinorVersion() {
        
        var versions = Versions()
        
//        versions.v0_0_0.minor -= 1
//        XCTAssertEqual(versions.v0_0_0, SemVer(0,0,0))
//
//        versions.v0_0_1.minor -= 1
//        XCTAssertEqual(versions.v0_0_1, SemVer(0,0,1))
//
//        versions.v0_0_999.minor -= 1
//        XCTAssertEqual(versions.v0_0_999, SemVer(0,0,999))
        
        versions.v0_1_0.minor -= 1
        XCTAssertEqual(versions.v0_1_0, SemVer(0,1,0))
        
        versions.v0_1_999.minor -= 1
        XCTAssertEqual(versions.v0_1_999, SemVer(0,1,999))
        
        versions.v0_999_0.minor -= 1
        XCTAssertEqual(versions.v0_999_0, SemVer(0,999,0))
        
        versions.v0_999_1.minor -= 1
        XCTAssertEqual(versions.v0_999_1, SemVer(0,999,1))
        
        versions.v0_999_999.minor -= 1
        XCTAssertEqual(versions.v0_999_999, SemVer(0,999,999))
        
        
//        versions.v1_0_0.minor -= 1
//        XCTAssertEqual(versions.v1_0_0, SemVer(1,0,0))
//
//        versions.v1_0_1.minor -= 1
//        XCTAssertEqual(versions.v1_0_1, SemVer(1,0,1))
//
//        versions.v1_0_999.minor -= 1
//        XCTAssertEqual(versions.v1_0_999, SemVer(1,0,999))
        
        versions.v1_1_0.minor -= 1
        XCTAssertEqual(versions.v1_1_0, SemVer(1,1,0))
        
        versions.v1_1_999.minor -= 1
        XCTAssertEqual(versions.v1_1_999, SemVer(1,1,999))
        
        versions.v1_999_0.minor -= 1
        XCTAssertEqual(versions.v1_999_0, SemVer(1,999,0))
        
        versions.v1_999_1.minor -= 1
        XCTAssertEqual(versions.v1_999_1, SemVer(1,999,1))
        
        versions.v1_999_999.minor -= 1
        XCTAssertEqual(versions.v1_999_999, SemVer(1,999,999))
        
        
//        versions.v2_0_0.minor -= 1
//        XCTAssertEqual(versions.v2_0_0, SemVer(2,0,0))
//
//        versions.v2_0_1.minor -= 1
//        XCTAssertEqual(versions.v2_0_1, SemVer(2,0,1))
//
//        versions.v2_0_999.minor -= 1
//        XCTAssertEqual(versions.v2_0_999, SemVer(2,0,999))
        
        versions.v2_1_0.minor -= 1
        XCTAssertEqual(versions.v2_1_0, SemVer(2,1,0))
        
        versions.v2_1_999.minor -= 1
        XCTAssertEqual(versions.v2_1_999, SemVer(2,1,999))
        
        versions.v2_999_0.minor -= 1
        XCTAssertEqual(versions.v2_999_0, SemVer(2,999,0))
        
        versions.v2_999_1.minor -= 1
        XCTAssertEqual(versions.v2_999_1, SemVer(2,999,1))
        
        versions.v2_999_999.minor -= 1
        XCTAssertEqual(versions.v2_999_999, SemVer(2,999,999))
        
        
//        versions.v999_0_0.minor -= 1
//        XCTAssertEqual(versions.v999_0_0, SemVer(999,0,0))
//
//        versions.v999_0_1.minor -= 1
//        XCTAssertEqual(versions.v999_0_1, SemVer(999,0,1))
//
//        versions.v999_0_999.minor -= 1
//        XCTAssertEqual(versions.v999_0_999, SemVer(999,0,999))
        
        versions.v999_1_0.minor -= 1
        XCTAssertEqual(versions.v999_1_0, SemVer(999,1,0))
        
        versions.v999_1_999.minor -= 1
        XCTAssertEqual(versions.v999_1_999, SemVer(999,1,999))
        
        versions.v999_999_0.minor -= 1
        XCTAssertEqual(versions.v999_999_0, SemVer(999,999,0))
        
        versions.v999_999_1.minor -= 1
        XCTAssertEqual(versions.v999_999_1, SemVer(999,999,1))
        
        versions.v999_999_999.minor -= 1
        XCTAssertEqual(versions.v999_999_999, SemVer(999,999,999))
    }
    
    
    func testDecrementPatchVersion() {
        
        var versions = Versions()
        
//        versions.v0_0_0.patch -= 1
//        XCTAssertEqual(versions.v0_0_0, SemVer(0,0,0))
        
        versions.v0_0_1.patch -= 1
        XCTAssertEqual(versions.v0_0_1, SemVer(0,0,1))
        
        versions.v0_0_999.patch -= 1
        XCTAssertEqual(versions.v0_0_999, SemVer(0,0,999))
        
//        versions.v0_1_0.patch -= 1
//        XCTAssertEqual(versions.v0_1_0, SemVer(0,1,0))
        
        versions.v0_1_999.patch -= 1
        XCTAssertEqual(versions.v0_1_999, SemVer(0,1,999))
        
//        versions.v0_999_0.patch -= 1
//        XCTAssertEqual(versions.v0_999_0, SemVer(0,999,0))
        
        versions.v0_999_1.patch -= 1
        XCTAssertEqual(versions.v0_999_1, SemVer(0,999,1))
        
        versions.v0_999_999.patch -= 1
        XCTAssertEqual(versions.v0_999_999, SemVer(0,999,999))
        
        
//        versions.v1_0_0.patch -= 1
//        XCTAssertEqual(versions.v1_0_0, SemVer(1,0,0))
        
        versions.v1_0_1.patch -= 1
        XCTAssertEqual(versions.v1_0_1, SemVer(1,0,1))
        
        versions.v1_0_999.patch -= 1
        XCTAssertEqual(versions.v1_0_999, SemVer(1,0,999))
        
//        versions.v1_1_0.patch -= 1
//        XCTAssertEqual(versions.v1_1_0, SemVer(1,1,0))
        
        versions.v1_1_999.patch -= 1
        XCTAssertEqual(versions.v1_1_999, SemVer(1,1,999))
        
//        versions.v1_999_0.patch -= 1
//        XCTAssertEqual(versions.v1_999_0, SemVer(1,999,0))
        
        versions.v1_999_1.patch -= 1
        XCTAssertEqual(versions.v1_999_1, SemVer(1,999,1))
        
        versions.v1_999_999.patch -= 1
        XCTAssertEqual(versions.v1_999_999, SemVer(1,999,999))
        
        
//        versions.v2_0_0.patch -= 1
//        XCTAssertEqual(versions.v2_0_0, SemVer(2,0,0))
        
        versions.v2_0_1.patch -= 1
        XCTAssertEqual(versions.v2_0_1, SemVer(2,0,1))
        
        versions.v2_0_999.patch -= 1
        XCTAssertEqual(versions.v2_0_999, SemVer(2,0,999))
        
//        versions.v2_1_0.patch -= 1
//        XCTAssertEqual(versions.v2_1_0, SemVer(2,1,0))
        
        versions.v2_1_999.patch -= 1
        XCTAssertEqual(versions.v2_1_999, SemVer(2,1,999))
        
//        versions.v2_999_0.patch -= 1
//        XCTAssertEqual(versions.v2_999_0, SemVer(2,999,0))
        
        versions.v2_999_1.patch -= 1
        XCTAssertEqual(versions.v2_999_1, SemVer(2,999,1))
        
        versions.v2_999_999.patch -= 1
        XCTAssertEqual(versions.v2_999_999, SemVer(2,999,999))
        
        
//        versions.v999_0_0.patch -= 1
//        XCTAssertEqual(versions.v999_0_0, SemVer(999,0,0))
        
        versions.v999_0_1.patch -= 1
        XCTAssertEqual(versions.v999_0_1, SemVer(999,0,1))
        
        versions.v999_0_999.patch -= 1
        XCTAssertEqual(versions.v999_0_999, SemVer(999,0,999))
        
//        versions.v999_1_0.patch -= 1
//        XCTAssertEqual(versions.v999_1_0, SemVer(999,1,0))
        
        versions.v999_1_999.patch -= 1
        XCTAssertEqual(versions.v999_1_999, SemVer(999,1,999))
        
//        versions.v999_999_0.patch -= 1
//        XCTAssertEqual(versions.v999_999_0, SemVer(999,999,0))
        
        versions.v999_999_1.patch -= 1
        XCTAssertEqual(versions.v999_999_1, SemVer(999,999,1))
        
        versions.v999_999_999.patch -= 1
        XCTAssertEqual(versions.v999_999_999, SemVer(999,999,999))
    }
    
    
    // MARK: - Set extensions
    
    func testSetExtensions() {
        var allNumbers = SemVer(1,2,3, preRelease: [4, 5, 6], build: [7, 8, 9])!
        
        allNumbers.preRelease = [10, 11, 12]
        XCTAssertEqual(allNumbers, SemVer(1,2,3, preRelease: [10, 11, 12], build: [7, 8, 9])!)
        
        allNumbers.build = [13, 14, 15]
        XCTAssertEqual(allNumbers, SemVer(1,2,3, preRelease: [10, 11, 12], build: [13, 14, 15])!)
        
        allNumbers.preRelease = nil
        XCTAssertEqual(allNumbers, SemVer(1,2,3, build: [13, 14, 15])!)
        
        
        var stringy = SemVer(1,2,3, preRelease: ["fore", "5", "sicks"], build: ["heaven", "ate", "nein"])!
        
        stringy.preRelease = ["tin", "leaven", "dealve"]
        XCTAssertEqual(stringy, SemVer(1,2,3, preRelease: ["tin", "leaven", "dealve"], build: ["heaven", "ate", "nein"])!)
        
        stringy.build = ["hurting", "forting", "15"]
        XCTAssertEqual(stringy, SemVer(1,2,3, preRelease: ["tin", "leaven", "dealve"], build: ["hurting", "forting", "15"])!)
        
        stringy.build = nil
        XCTAssertEqual(stringy, SemVer(1,2,3, preRelease: ["tin", "leaven", "dealve"])!)
        
        
        var buildLater = SemVer(1,2,3, preRelease: "RC")!
        
        buildLater.build = "2021.10.12"
        XCTAssertEqual(buildLater, SemVer(1,2,3, preRelease: "RC", build: "2021.10.12")!)
        
        
        var preReleaseLater = SemVer(1,2,3, build: "567")!
        
        preReleaseLater.preRelease = ["Beta", 1]
        XCTAssertEqual(preReleaseLater, SemVer(1,2,3, preRelease: ["Beta", 1], build: "567")!)
    }
    
    
    func testInvalidPreRelease() {
        var semVer = SemVer(1,2,3)!
        
        semVer.preRelease = "00"
        XCTAssertEqual(semVer, SemVer(1,2,3))
        
        semVer.preRelease = ["", "", ""]
        XCTAssertEqual(semVer, SemVer(1,2,3))
        
        semVer.preRelease = "%"
        XCTAssertEqual(semVer, SemVer(1,2,3))
        
        semVer.preRelease = "⛔️"
        XCTAssertEqual(semVer, SemVer(1,2,3))
    }
    
    
    func testInvalidBuild() {
        var semVer = SemVer(1,2,3)!
        
        semVer.build = ["", "", ""]
        XCTAssertEqual(semVer, SemVer(1,2,3))
        
        semVer.build = "%"
        XCTAssertEqual(semVer, SemVer(1,2,3))
        
        semVer.build = "⛔️"
        XCTAssertEqual(semVer, SemVer(1,2,3))
    }
    
    
    // MARK: - Requirements
    
    static let allTests = [
        ("testIncrementMajorVersion", testIncrementMajorVersion),
        ("testIncrementMinorVersion", testIncrementMinorVersion),
        ("testIncrementPatchVersion", testIncrementPatchVersion),
        
        ("testIdentityMajorVersion", testIdentityMajorVersion),
        ("testIdentityMinorVersion", testIdentityMinorVersion),
        ("testIdentityPatchVersion", testIdentityPatchVersion),
        
        ("testDecrementMajorVersion", testDecrementMajorVersion),
        ("testDecrementMinorVersion", testDecrementMinorVersion),
        ("testDecrementPatchVersion", testDecrementPatchVersion),
        
        ("testSetExtensions", testSetExtensions),
    ]
}



// MARK: - Utilities for this test class

private struct Versions {
    var v0_0_0 = SemVer(0,0,0)
    var v0_0_1 = SemVer(0,0,1)
    var v0_0_999 = SemVer(0,0,999)
    var v0_1_0 = SemVer(0,1,0)
    var v0_1_999 = SemVer(0,1,999)
    var v0_999_0 = SemVer(0,999,0)
    var v0_999_1 = SemVer(0,999,1)
    var v0_999_999 = SemVer(0,999,999)
    
    var v1_0_0 = SemVer(1,0,0)
    var v1_0_1 = SemVer(1,0,1)
    var v1_0_999 = SemVer(1,0,999)
    var v1_1_0 = SemVer(1,1,0)
    var v1_1_999 = SemVer(1,1,999)
    var v1_999_0 = SemVer(1,999,0)
    var v1_999_1 = SemVer(1,999,1)
    var v1_999_999 = SemVer(1,999,999)
    
    var v2_0_0 = SemVer(2,0,0)
    var v2_0_1 = SemVer(2,0,1)
    var v2_0_999 = SemVer(2,0,999)
    var v2_1_0 = SemVer(2,1,0)
    var v2_1_999 = SemVer(2,1,999)
    var v2_999_0 = SemVer(2,999,0)
    var v2_999_1 = SemVer(2,999,1)
    var v2_999_999 = SemVer(2,999,999)
    
    var v999_0_0 = SemVer(999,0,0)
    var v999_0_1 = SemVer(999,0,1)
    var v999_0_999 = SemVer(999,0,999)
    var v999_1_0 = SemVer(999,1,0)
    var v999_1_999 = SemVer(999,1,999)
    var v999_999_0 = SemVer(999,999,0)
    var v999_999_1 = SemVer(999,999,1)
    var v999_999_999 = SemVer(999,999,999)
}
