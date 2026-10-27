//
//  SemVerTests.swift
//  SemVer
//
//  Created by Ben Leggiero on 2018-01-09.
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
    
    
    func testInvalidSemVer() {
        XCTAssertNil(SemVer("Obviously Bad"))
        XCTAssertNil(SemVer("1"))
        XCTAssertNil(SemVer("1.2"))
        XCTAssertNil(SemVer("1.2-RC.4"))
        XCTAssertNil(SemVer("1.2-RC.4+567.8"))
        XCTAssertNil(SemVer("1.2-RC.4+567"))
        XCTAssertNil(SemVer("1.2-RC+567.8"))
        XCTAssertNil(SemVer("-2.0"))
        XCTAssertNil(SemVer("-2.0.0"))
        XCTAssertNil(SemVer("2.0-β"))
        XCTAssertNil(SemVer("2.0-beta_1"))
        XCTAssertNil(SemVer("1.-2"))
        XCTAssertNil(SemVer("1.2.-3"))
        XCTAssertNil(SemVer("1.2.3.4"))
        XCTAssertNil(SemVer("1.2.3-😱"))
        XCTAssertNil(SemVer("1.2.3-semántice"))
        
        // Proof of fix of #14: https://github.com/RougeWare/Swift-SemVer/issues/14
        XCTAssertNil(SemVer(1,0,0, preRelease: "01"))
        XCTAssertNil(SemVer("1.0.0-01"))
        XCTAssertNil(SemVer("1.0.0-01.02.03"))
        
        XCTAssertNil(SemVer("01.2.3"))
        XCTAssertNil(SemVer("1.02.3"))
        XCTAssertNil(SemVer("1.2.03"))
    }
    
    
    func testInvalidPreRelease() {
        XCTAssertNil(SemVer.PreRelease.init("2026.01.01"))
        XCTAssertNil(SemVer.PreRelease.init("β3"))
        
        let _1: SemVer.PreRelease = "Black sphinx of quartz, judge my vow!"
        let _2: SemVer.PreRelease = "007"
        let _3: SemVer.PreRelease = ["$67"]
        let _4: SemVer.PreRelease = [""]
        let _5: SemVer.PreRelease.Identifier = "🫪"
        
        XCTAssertEqual("", _1.description)
        
        XCTAssertTrue(_1.identifiers.isEmpty)
        
        XCTAssertEqual("", _2.description)
        XCTAssertTrue(_2.identifiers.isEmpty)
        
        XCTAssertEqual("", _3.description)
        XCTAssertTrue(_3.identifiers.isEmpty)
        
        XCTAssertEqual("", _4.description)
        XCTAssertTrue(_4.identifiers.isEmpty)
        
        XCTAssertEqual("", _5.description)
        XCTAssertTrue(_5.isEmpty)
    }
    
    
    func testInvalidBuild() {
        XCTAssertNil(SemVer.Build.init("/watch"))
        XCTAssertNil(SemVer.Build.init("?v=mOvhHim78YA"))
        
        let _1: SemVer.Build = "2026/10/26"
        let _2: SemVer.Build = ".."
        let _3: SemVer.Build = ["#20261026"]
        let _4: SemVer.Build = ["00:00:00:00", "00:00:00:04"]
        let _5: SemVer.Build.Identifier = "🫪"
        
        XCTAssertEqual("", _1.description)
        XCTAssertTrue(_1.identifiers.isEmpty)
        
        XCTAssertEqual("", _2.description)
        XCTAssertTrue(_2.identifiers.isEmpty)
        
        XCTAssertEqual("", _3.description)
        XCTAssertTrue(_3.identifiers.isEmpty)
        
        XCTAssertEqual("", _4.description)
        XCTAssertTrue(_4.identifiers.isEmpty)
        
        XCTAssertEqual("", _5.description)
        XCTAssertTrue(_5.isEmpty)
    }
    
    
    func testCustomSemverCompatibleScheme() {
        XCTAssertEqual("0.0.0-ERROR.foobar", SemVer.error(title: "foobar").description)
        XCTAssertEqual("0.0.0-ERROR.foobar.ouppy", SemVer.error(title: "foobar", details: "ouppy").description)
        XCTAssertEqual("0.0.0-ERROR.foobar.ouppy.yay", SemVer.error(title: "foobar", details: "ouppy", "yay").description)
    }
    
    
    /// Pins which initializer an integer-literal call selects.
    ///
    /// The `UInt` initializers can never fail, while the `Major`/`Minor`/`Patch` initializers are failable. Both accept
    /// `SemVer(1,2,3)`, so if overload resolution ever starts preferring the failable one, the result silently becomes
    /// an `Optional` and callers' code changes meaning.
    func testIntegerLiteralInitializersAreNotFailable() {
        let unlabeled = SemVer(1,2,3)
        let labeled = SemVer(major: 1, minor: 2, patch: 3)
        
        // If a failable initializer was chosen, these would be `Optional<SemVer>`
        XCTAssertTrue(SemVer.self == type(of: unlabeled))
        XCTAssertTrue(SemVer.self == type(of: labeled))
        
        // The same pin at compile time: this stops compiling if only a failable initializer can match
        let nonOptional: SemVer = SemVer(1,2,3)
        
        XCTAssertEqual(unlabeled, labeled)
        XCTAssertEqual(unlabeled, nonOptional)
        XCTAssertEqual(unlabeled.description, "1.2.3")
        
        // Extensions are what make an initializer failable, since they might not be valid
        XCTAssertNotNil(SemVer(1,2,3, preRelease: "RC.4"))
        XCTAssertNotNil(SemVer(1,2,3, build: 567))
        XCTAssertNotNil(SemVer(major: 1, minor: 2, patch: 3, preRelease: "RC.4", build: 567))
    }
}


private extension SemVer {
    static func error(title: String, details: String...) -> Self {
        self.init(0,0,0, preRelease: .init(["ERROR", title] + details))
            ?? .init(0,0,0)
    }
}
