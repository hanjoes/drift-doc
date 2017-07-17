//
//  TestMarkupConversion.swift
//  DriftRuntime
//
//  Created by Hanzhou Shi on 7/16/17.
//

import XCTest
@testable import DriftRuntime

class TestMarkupConversion: XCTestCase {
    
    let converter = DriftConverter()
    
    /// test Swift markup conversion for author tag.
    func testMarkupConversionAuthor() {
        let file = Resources.sample5
        let expected =
"""

 *  Noop.
 *
 *  - Author: hanjoes
 
"""
        let actual = converter.emitSwiftComments(for: file)
        XCTAssertEqual(expected, actual)
    }
    
    func testMarkupConversionParameter() {
        let file = Resources.sample6
        let expected =
"""

 *  Noop.
 *
 *  - Parameter: param some parameter.
 
"""
        let actual = converter.emitSwiftComments(for: file)
        XCTAssertEqual(expected, actual)
    }
}
