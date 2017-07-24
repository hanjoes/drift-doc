import XCTest
@testable import DriftRuntime

class TestMarkupConversion: XCTestCase {
    
    let converter = DriftConverter()
    
    /// ------------------------------------------------
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

- Parameter param: some parameter.

"""
        let actual = converter.emitSwiftComments(for: file)
        XCTAssertEqual(expected, actual)
    }
    
    /// ------------------------------------------------
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
        
    /// ------------------------------------------------
    func testMarkupConversionThrows() {
        let file =
"""
/**
 *  Noop.
 *
 *  @throws some exception
 */
public static func noop(param: Int) throws -> Void {
}
"""
        let expected =
"""

Noop.

- Throws: some exception

"""
        let actual = converter.emitSwiftComments(for: file)
        XCTAssertEqual(expected, actual)
    }
    
    /// ------------------------------------------------
    func testMarkupMixedSections() {
        let file =
"""
/**
 *  Noop.
 *
 *  @return void
 *  @exception some exception
 *  @param param dorky parameter
 *  @param param dorky parameter brother
 *  @throws exception2
 */
public static func noop(param: Int) throws -> Void {
}
"""
        let expected =
"""

Noop.

- Parameter param: dorky parameter
- Parameter param: dorky parameter brother
- Throws: some exception
- Throws: exception2
- Returns: void

"""
        let actual = converter.emitSwiftComments(for: file)
        XCTAssertEqual(expected, actual)
    }
    
    /// ------------------------------------------------
    func testMarkupAuthorAndParameter() {
        let file =
"""
/**
 *  Noop.
 *
 *  @return void
 *  @throws some exception
 *  @author hanjoes
 *  @param param dorky parameter
 *  @param param dorky parameter brother
 *  @throws exception2
 */
public static func noop(param: Int) throws -> Void {
}
"""
        let expected =
"""

Noop.

- Author: hanjoes
- Parameter param: dorky parameter
- Parameter param: dorky parameter brother
- Throws: some exception
- Throws: exception2
- Returns: void

"""
        let actual = converter.emitSwiftComments(for: file)
        XCTAssertEqual(expected, actual)
    }
    
    /// ------------------------------------------------
    func testMixedInlineAndDedicatedCallouts() {
        let file =
"""
/**
 *  Noop.
 *  Comment line1.
 *
 *
 *  @version 3.14159
 *  @return void
 *  @throws some exception
 *  @author hanjoes
 *  @param param dorky parameter
 *  @param param dorky parameter brother
 *  @since epoch
 *  @throws exception2
 *  @see some other code
 */
public static func noop(param: Int) throws -> Void {
}
"""
        let expected =
"""

Noop.
Comment line1.


- Version: 3.14159
- Author: hanjoes
- Since: epoch
- SeeAlso: some other code
- Parameter param: dorky parameter
- Parameter param: dorky parameter brother
- Throws: some exception
- Throws: exception2
- Returns: void

"""
        let actual = converter.emitSwiftComments(for: file)
        XCTAssertEqual(expected, actual)
    }
    
    /// ------------------------------------------------
    func testMixedCalloutsWithCodeVoiceEmbedded() {
        let file =
        """
/**
 *  Noop.
 *  Comment line1. {@code some code} is working!
 *
 *
 *  @version 3.14159
 *  @serial "json" encoded
 *  @deprecated this API should not be used 
 *  @return void
 *  @throws some exception {@code TestException} should {@literal never be thrown.}
 *  @author hanjoes
 */
public static func noop(param: Int) throws -> Void {
}
"""
        let expected =
        """

Noop.
Comment line1. `some code` is working!


- Version: 3.14159
"json" encoded
this API should not be used
- Author: hanjoes
- Throws: some exception `TestException` should `never be thrown.`
- Returns: void

"""
        let actual = converter.emitSwiftComments(for: file)
        XCTAssertEqual(expected, actual)
    }
}
