//
//  SemVer+Comparable Tests.swift
//  SemVerTests
//
//  Created by Ky Leggiero on 2021-10-25.
//

import XCTest
import SemVer



class SemVerComparableTests: SemVerTestClass {
    
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
    
    
    
    // MARK: - Equivalence
    
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
    
    
    func testAdvancedEquality() {
        XCTAssertEqual(SemVer(1,2,3), SemVer("1.2.3"))
        XCTAssertEqual(SemVer(1,2,3), SemVer("1.2.3+12"))
        XCTAssertEqual(SemVer(1,2,3, build: 12), SemVer("1.2.3"))
        XCTAssertEqual(SemVer(1,2,3, build: 12), SemVer(1,2,3))
        XCTAssertEqual(SemVer(1,2,3, build: 12), SemVer("1.2.3+12"))
    }
    
    
    
    // MARK: - Ignoring components
    
    // MARK: Pre-Release
    
    func testCompareIgnoringPreRelease() {
        XCTAssertTrue(SemVer(0,0,3).matches(SemVer(0,0,3), ignoring: .preRelease))
        XCTAssertTrue(SemVer(0,2,3).matches(SemVer(0,2,3), ignoring: .preRelease))
        XCTAssertTrue(SemVer(1,2,3).matches(SemVer(1,2,3), ignoring: .preRelease))
        XCTAssertTrue(SemVer("1.2.3-Beta")!.matches(SemVer(1,2,3), ignoring: .preRelease))
        XCTAssertTrue(SemVer("1.2.3-Beta")!.matches(SemVer("1.2.3-Alpha")!, ignoring: .preRelease))
    }
    
    
    func testCompareIgnoringPatch() {
        XCTAssertTrue(SemVer(0,0,3).matches(SemVer(0,0,3), ignoring: .patchAndPreRelease))
        XCTAssertTrue(SemVer(0,2,3).matches(SemVer(0,2,3), ignoring: .patchAndPreRelease))
        XCTAssertTrue(SemVer(1,2,3).matches(SemVer(1,2,3), ignoring: .patchAndPreRelease))
        
        XCTAssertTrue(SemVer(1,2,3,  preRelease: "Beta")!.matches(SemVer(1,2,0),  ignoring: .patchAndPreRelease))
        XCTAssertTrue(SemVer(1,2,3,  preRelease: "Beta")!.matches(SemVer(1,2,3),  ignoring: .patchAndPreRelease))
        XCTAssertTrue(SemVer(1,2,3,  preRelease: "Beta")!.matches(SemVer(1,2,99), ignoring: .patchAndPreRelease))
        XCTAssertTrue(SemVer(1,2,99, preRelease: "Beta")!.matches(SemVer(1,2,3),  ignoring: .patchAndPreRelease))
        
        XCTAssertTrue(SemVer(1,2,3, preRelease: "Beta")!.matches(SemVer(1,2,0, preRelease: "Alpha")!, ignoring: .patchAndPreRelease))
        XCTAssertTrue(SemVer(1,2,3, preRelease: "Beta")!.matches(SemVer(1,2,3, preRelease: "Alpha")!, ignoring: .patchAndPreRelease))
    }
    
    
    func testCompareIgnoringMinor() {
        XCTAssertTrue(SemVer(0,0,3).matches(SemVer(0,0,3), ignoring: .minorAndPatchAndPreRelease))
        XCTAssertTrue(SemVer(0,2,3).matches(SemVer(0,2,3), ignoring: .minorAndPatchAndPreRelease))
        XCTAssertTrue(SemVer(1,2,3).matches(SemVer(1,2,3), ignoring: .minorAndPatchAndPreRelease))
        
        XCTAssertTrue(SemVer(1,2,3,   preRelease: "Beta")!.matches(SemVer(1,0,0),   ignoring: .minorAndPatchAndPreRelease))
        XCTAssertTrue(SemVer(1,2,3,   preRelease: "Beta")!.matches(SemVer(1,2,0),   ignoring: .minorAndPatchAndPreRelease))
        XCTAssertTrue(SemVer(1,2,3,   preRelease: "Beta")!.matches(SemVer(1,2,3),   ignoring: .minorAndPatchAndPreRelease))
        XCTAssertTrue(SemVer(1,2,3,   preRelease: "Beta")!.matches(SemVer(1,99,99), ignoring: .minorAndPatchAndPreRelease))
        XCTAssertTrue(SemVer(1,99,99, preRelease: "Beta")!.matches(SemVer(1,2,3),   ignoring: .minorAndPatchAndPreRelease))
        
        XCTAssertTrue(SemVer(1,2,3, preRelease: "Beta")!.matches(SemVer(1,0,0, preRelease: "Alpha")!, ignoring: .minorAndPatchAndPreRelease))
        XCTAssertTrue(SemVer(1,2,3, preRelease: "Beta")!.matches(SemVer(1,2,0, preRelease: "Alpha")!, ignoring: .minorAndPatchAndPreRelease))
        XCTAssertTrue(SemVer(1,2,3, preRelease: "Beta")!.matches(SemVer(1,2,3, preRelease: "Alpha")!, ignoring: .minorAndPatchAndPreRelease))
    }
    
    
    
    static let allTests = [
        ("testPrecedence", testPrecedence),
        ("testEquivalence", testEquivalence),
        ("testAdvancedEquality", testAdvancedEquality),
        ("testCompareIgnoringPreRelease", testCompareIgnoringPreRelease),
        ("testCompareIgnoringPatch", testCompareIgnoringPatch),
        ("testCompareIgnoringMinor", testCompareIgnoringMinor),
    ]
}

