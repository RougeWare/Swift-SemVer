//
//  Testing tools.swift
//  SemVerTests
//
//  Created by Ky Leggiero on 2021-10-18.
//

import XCTest
@testable import SemVer



internal class SemVerTestClass: XCTestCase {
    override func setUp() {
        isTesting = true
        super.setUp()
    }
}



/// A bodge to change behavior based on whether a test suite is running.
///
/// Ideally, this would be a compile-time flag. However, it seems that isn't being respected with my current setup, so I don't trust it.
@inline(__always)
var isTesting: Bool {
    get { TestingTools.isTesting }
    set { TestingTools.isTesting = newValue }
}


/// In non-test runs, this indicates that an internal sanity check failed.
///
/// To perform an assertion in test runs as well, use `Swift.assertionFailure` instead.
///
/// - Parameter message: _optional_ - A string to print in a playground or `-Onone` non-test build. Defaults to an empty string.
@inline(__always)
func assertionFailure(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    TestingTools.assertionFailure(message(), file: file, line: line)
}
