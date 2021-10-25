import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    isTesting = true
    
    return [
        testCase(SemVerTests.allTests),
        testCase(SemVerHashableTests.allTests),
        testCase(SemVerMutationTests.allTests),
        testCase(SemVerCodableTests.allTests),
        testCase(SemVerComparableTests.allTests),
    ]
}
#endif
