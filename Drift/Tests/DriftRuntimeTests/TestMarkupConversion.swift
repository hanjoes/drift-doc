import XCTest
@testable import DriftRuntime

class TestMarkupConversion: XCTestCase {
    
    let converter = DriftConverter()
    
    /// test Swift markup conversion for author tag.
//    func testMarkupConversionAuthor() {
//        let file = Resources.sample5
//        let expected =
//"""
//
// *  Noop.
// *
// *  - Author: hanjoes
//
//"""
//        let actual = converter.emitSwiftComments(for: file)
//        XCTAssertEqual(expected, actual)
//    }
    
    func testMarkupConversionParameter() {
        let file =
"""
/**
 *  Noop.
 *
 *  @param param some parameter.
 */
public static func noop(param: Int) {
}
"""
        let expected =
"""

  Noop.

  - Parameter: param some parameter.
 
"""
        let actual = converter.emitSwiftComments(for: file)
        XCTAssertEqual(expected, actual)
    }
    
    func testMarkupConversionReturns() {
        let file =
"""
/**
 *  Noop.
 *
 *  @return returning nothing.
 */
public static func noop(param: Int) -> Void {
}
"""
        let expected =
"""

  Noop.

  - Returns: returning nothing.
 
"""
        let actual = converter.emitSwiftComments(for: file)
        XCTAssertEqual(expected, actual)
    }
//
//    func testMarkupConversionSince() {
//        let file = Resources.sample8
//        let expected =
//"""
//
// *  Noop.
// *
// *  - Since: first introduced in end of time.
//
//"""
//        let actual = converter.emitSwiftComments(for: file)
//        XCTAssertEqual(expected, actual)
//    }
//
//    func testMarkupConversionThrows() {
//        let file = Resources.sample9
//        let expected =
//"""
//
// *  Noop.
// *
// *  - Throws: some exception
//
//"""
//        let actual = converter.emitSwiftComments(for: file)
//        XCTAssertEqual(expected, actual)
//    }
//
//    func testMarkupConversionVersion() {
//        let file = Resources.sample10
//        let expected =
//"""
//
// *  Noop.
// *
// *  - Version: version 3.1415926
//
//"""
//        let actual = converter.emitSwiftComments(for: file)
//        XCTAssertEqual(expected, actual)
//    }
}
