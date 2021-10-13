//
//  SemVer+Hashable Tests.swift
//  SemVer
//
//  Created by Ben Leggiero on 2020-04-19.
//  Copyright © 2021 Ben Leggiero BH-1-PS.
//

import XCTest
@testable import SemVer



class SemVerHashableTests: XCTestCase {
    
    override func setUp() {
        isTesting = true
    }
    
    
    func testHashable() {
        let v0_0_0 =       SemVer(0,0,0)!
        let v0_0_0__0 =    SemVer(0,0,0, preRelease: 0)!
        let v0_0_0__0__0 = SemVer(0,0,0, preRelease: 0, build: 0)!
        let v0_0_0__0__1 = SemVer(0,0,0, preRelease: 0, build: 1)!
        let v0_0_0__1__0 = SemVer(0,0,0, preRelease: 1, build: 0)!
        let v0_0_0__1__1 = SemVer(0,0,0, preRelease: 1, build: 1)!
        
        let v0_0_1 =       SemVer(0,0,1)!
        let v0_0_1__0 =    SemVer(0,0,1, preRelease: 0)!
        let v0_0_1__0__0 = SemVer(0,0,1, preRelease: 0, build: 0)!
        let v0_0_1__0__1 = SemVer(0,0,1, preRelease: 0, build: 1)!
        let v0_0_1__1__0 = SemVer(0,0,1, preRelease: 1, build: 0)!
        let v0_0_1__1__1 = SemVer(0,0,1, preRelease: 1, build: 1)!
        
        let v0_1_0 =       SemVer(0,1,0)!
        let v0_1_0__0 =    SemVer(0,1,0, preRelease: 0)!
        let v0_1_0__0__0 = SemVer(0,1,0, preRelease: 0, build: 0)!
        let v0_1_0__0__1 = SemVer(0,1,0, preRelease: 0, build: 1)!
        let v0_1_0__1__0 = SemVer(0,1,0, preRelease: 1, build: 0)!
        let v0_1_0__1__1 = SemVer(0,1,0, preRelease: 1, build: 1)!
        
        let v0_1_1 =       SemVer(0,1,1)!
        let v0_1_1__0 =    SemVer(0,1,1, preRelease: 0)!
        let v0_1_1__0__0 = SemVer(0,1,1, preRelease: 0, build: 0)!
        let v0_1_1__0__1 = SemVer(0,1,1, preRelease: 0, build: 1)!
        let v0_1_1__1__0 = SemVer(0,1,1, preRelease: 1, build: 0)!
        let v0_1_1__1__1 = SemVer(0,1,1, preRelease: 1, build: 1)!
        
        let v1_0_0 =       SemVer(1,0,0)!
        let v1_0_0__0 =    SemVer(1,0,0, preRelease: 0)!
        let v1_0_0__0__0 = SemVer(1,0,0, preRelease: 0, build: 0)!
        let v1_0_0__0__1 = SemVer(1,0,0, preRelease: 0, build: 1)!
        let v1_0_0__1__0 = SemVer(1,0,0, preRelease: 1, build: 0)!
        let v1_0_0__1__1 = SemVer(1,0,0, preRelease: 1, build: 1)!
        
        let v1_0_1 =       SemVer(1,0,1)!
        let v1_0_1__0 =    SemVer(1,0,1, preRelease: 0)!
        let v1_0_1__0__0 = SemVer(1,0,1, preRelease: 0, build: 0)!
        let v1_0_1__0__1 = SemVer(1,0,1, preRelease: 0, build: 1)!
        let v1_0_1__1__0 = SemVer(1,0,1, preRelease: 1, build: 0)!
        let v1_0_1__1__1 = SemVer(1,0,1, preRelease: 1, build: 1)!
        
        let v2_0_0 =       SemVer(2,0,0)!
        let v2_0_0__0 =    SemVer(2,0,0, preRelease: 0)!
        let v2_0_0__0__0 = SemVer(2,0,0, preRelease: 0, build: 0)!
        let v2_0_0__0__1 = SemVer(2,0,0, preRelease: 0, build: 1)!
        let v2_0_0__1__0 = SemVer(2,0,0, preRelease: 1, build: 0)!
        let v2_0_0__1__1 = SemVer(2,0,0, preRelease: 1, build: 1)!
        
        let v2_0_1 =       SemVer(2,0,1)!
        let v2_0_1__0 =    SemVer(2,0,1, preRelease: 0)!
        let v2_0_1__0__0 = SemVer(2,0,1, preRelease: 0, build: 0)!
        let v2_0_1__0__1 = SemVer(2,0,1, preRelease: 0, build: 1)!
        let v2_0_1__1__0 = SemVer(2,0,1, preRelease: 1, build: 0)!
        let v2_0_1__1__1 = SemVer(2,0,1, preRelease: 1, build: 1)!
        
        
        let all: Set<SemVer> = [
            v0_0_0,       // +1 = 1
            v0_0_0__0,    // +1 = 2
            v0_0_0__0__0, // +0 = 2
            v0_0_0__0__1, // +0 = 2
            v0_0_0__1__0, // +1 = 3
            v0_0_0__1__1, // +0 = 3
            
            v0_0_1,       // +1 = 4
            v0_0_1__0,    // +1 = 5
            v0_0_1__0__0, // +0 = 5
            v0_0_1__0__1, // +0 = 5
            v0_0_1__1__0, // +1 = 6
            v0_0_1__1__1, // +0 = 6
            
            v0_1_0,       // +1 = 7
            v0_1_0__0,    // +1 = 7
            v0_1_0__0__0, // +0 = 8
            v0_1_0__0__1, // +0 = 8
            v0_1_0__1__0, // +1 = 9
            v0_1_0__1__1, // +0 = 9
            
            v0_1_1,       // +1 = 10
            v0_1_1__0,    // +1 = 11
            v0_1_1__0__0, // +0 = 11
            v0_1_1__0__1, // +0 = 11
            v0_1_1__1__0, // +1 = 12
            v0_1_1__1__1, // +0 = 12
            
            v1_0_0,       // +1 = 13
            v1_0_0__0,    // +1 = 14
            v1_0_0__0__0, // +0 = 14
            v1_0_0__0__1, // +0 = 14
            v1_0_0__1__0, // +1 = 15
            v1_0_0__1__1, // +0 = 15
            
            v1_0_1,       // +1 = 16
            v1_0_1__0,    // +1 = 17
            v1_0_1__0__0, // +0 = 17
            v1_0_1__0__1, // +0 = 17
            v1_0_1__1__0, // +1 = 18
            v1_0_1__1__1, // +0 = 18
            
            v2_0_0,       // +1 = 19
            v2_0_0__0,    // +1 = 20
            v2_0_0__0__0, // +0 = 20
            v2_0_0__0__1, // +0 = 20
            v2_0_0__1__0, // +1 = 21
            v2_0_0__1__1, // +0 = 21
            
            v2_0_1,       // +1 = 22
            v2_0_1__0,    // +1 = 23
            v2_0_1__0__0, // +0 = 23
            v2_0_1__0__1, // +0 = 23
            v2_0_1__1__0, // +1 = 24
            v2_0_1__1__1, // +0 = 24
        ]
        XCTAssertEqual(all.count, 24)
        
        XCTAssertTrue(all.allPairsSatisfy { $0.hashValue != $1.hashValue })
    }
    
    
    static let allTests = [
        ("testHashable", testHashable),
    ]
}



private extension Collection {
    func allPairsSatisfy(predicate: (Element, Element) -> Bool) -> Bool {
        for indexA in indices {
            for indexB in indices
                where indexA != indexB
            {
                if !predicate(self[indexA], self[indexB]) {
                    return false
                }
            }
        }
        return true
    }
}
