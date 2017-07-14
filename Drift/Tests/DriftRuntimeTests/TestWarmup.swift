//
//  TestWarmup.swift
//  DriftRuntimeTests
//
//  Created by Hanzhou Shi on 7/13/17.
//

import XCTest
@testable import DriftRuntime

class TestWarmup: XCTestCase {
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
        print(fileComments.comments)
    }
}
