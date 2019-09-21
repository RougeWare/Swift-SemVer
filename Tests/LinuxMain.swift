import XCTest

import SemVerTests

var tests = [XCTestCaseEntry]()
tests += SemVerTests.allTests()
XCTMain(tests)
