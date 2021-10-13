import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    isTesting = true
    
    return [
        testCase(SemVerTests.allTests),
        testCase(SemVerHashableTests.allTests),
        testCase(SemVerMutationTests.allTests),
    ]
}
#endif
