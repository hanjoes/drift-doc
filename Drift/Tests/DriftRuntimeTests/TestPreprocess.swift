//
//  TestWarmup.swift
//  DriftRuntimeTests
//
//  Created by Hanzhou Shi on 7/13/17.
//

import XCTest
@testable import DriftRuntime

class TestPreprocess: XCTestCase {
    func testParseFileContainsTripleSlashComments() {
        let file = """

        /// This class is a test class
        class Test {
            /// Test method.
            /// This method does nothing.
            func testMethod() {
            }
        }
        """
        let fileComments = Preprocess.parse(file: file)
        XCTAssertEqual([file.index(file.startIndex, offsetBy: 1)], fileComments.comments[0])
        XCTAssertEqual([file.index(file.startIndex, offsetBy: 49),
                        file.index(file.startIndex, offsetBy: 70)], fileComments.comments[1])
    }
}
