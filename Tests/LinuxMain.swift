import XCTest

import SemVerTests

isTesting = true
    
XCTMain(SemVerTests.allTests
        + SemVerHashableTests.allTests
        + SemVerMutationTests.allTests
        + SemVerCodableTests.allTests
        + SemVerComparableTests.allTests)
