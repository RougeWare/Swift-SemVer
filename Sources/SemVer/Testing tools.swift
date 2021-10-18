//
//  Testing tools.swift
//  SemVer
//
//  Created by Ky Leggiero on 2021-10-12.
//  Copyright © 2021 Ben Leggiero BH-1-PS.
//

import Foundation



/// Some tools to help us better-test this module
internal enum TestingTools {
    // Empty on-purpose; all members are in static extensions
}



internal extension TestingTools {
    
    /// A bodge to change behavior based on whether a test suite is running.
    ///
    /// Ideally, this would be a compile-time flag. However, it seems that isn't being respected with my current setup, so I don't trust it.
    static var isTesting = false
    
    
    /// In non-test runs, this indicates that an internal sanity check failed.
    ///
    /// To perform an assertion in test runs as well, use `Swift.assertionFailure` instead.
    ///
    /// - Parameter message: _optional_ - A string to print in a playground or `-Onone` non-test build. Defaults to an empty string.
    @inline(__always)
    static func assertionFailure(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
        guard !isTesting else { return }
        Swift.assertionFailure(message(), file: file, line: line)
    }
}



/// In non-test runs, this indicates that an internal sanity check failed.
///
/// To perform an assertion in test runs as well, use `Swift.assertionFailure` instead.
///
/// - Parameter message: _optional_ - A string to print in a playground or `-Onone` non-test build. Defaults to an empty string.
@inline(__always)
internal func assertionFailure(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    TestingTools.assertionFailure(message(), file: file, line: line)
}
