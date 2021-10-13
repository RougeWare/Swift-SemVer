//
//  Testing tools.swift
//  
//
//  Created by Ky Leggiero on 2021-10-12.
//

import Foundation



/// A bodge to change behavior based on whether a test suite is running.
///
/// Ideally, this would be a compile-time flag. However, it seems that isn't being respected with my current setup, so I don't trust it.
internal var isTesting = false



/// In non-test runs, this indicates that an internal sanity check failed.
///
/// To perform an assertion in test runs as well, use `Swift.assertionFailure` instead.
///
/// - Parameter message: _optional_ - A string to print in a playground or `-Onone` non-test build. Defaults to an empty string.
@inline(__always)
internal func assertionFailure(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    guard !isTesting else { return }
    Swift.assertionFailure(message(), file: file, line: line)
}
