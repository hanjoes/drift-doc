import XCTest
@testable import DriftRuntime

class TestMarkupConversion: XCTestCase {
    
    /// ------------------------------------------------
    func testMarkupConversionParameter() throws {
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
/// 
/// Noop.
/// 
/// - Parameter param: some parameter.
/// 
public static func noop(param: Int) {
}
"""
        let actual = try DriftConverter.rewrite(content: file)
        XCTAssertEqual(expected, actual)
    }
    
    /// ------------------------------------------------
    func testMarkupConversionReturns() throws {
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
/// 
/// Noop.
/// 
/// - Returns: returning nothing.
/// 
public static func noop(param: Int) -> Void {
}
"""
        let actual = try DriftConverter.rewrite(content: file)
        XCTAssertEqual(expected, actual)
    }
        
    /// ------------------------------------------------
    func testMarkupConversionThrows() throws {
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
/// 
/// Noop.
/// 
/// - Throws: some exception
/// 
public static func noop(param: Int) throws -> Void {
}
"""
        let actual = try DriftConverter.rewrite(content: file)
        XCTAssertEqual(expected, actual)
    }
    
    /// ------------------------------------------------
    func testMarkupMixedSections() throws {
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
/// 
/// Noop.
/// 
/// - Parameter param: dorky parameter
/// - Parameter param: dorky parameter brother
/// - Throws: some exception
/// - Throws: exception2
/// - Returns: void
/// 
public static func noop(param: Int) throws -> Void {
}
"""
        let actual = try DriftConverter.rewrite(content: file)
        XCTAssertEqual(expected, actual)
    }
    
    /// ------------------------------------------------
    func testMarkupAuthorAndParameter() throws {
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
/// 
/// Noop.
/// 
/// - Author: hanjoes
/// - Parameter param: dorky parameter
/// - Parameter param: dorky parameter brother
/// - Throws: some exception
/// - Throws: exception2
/// - Returns: void
/// 
public static func noop(param: Int) throws -> Void {
}
"""
        let actual = try DriftConverter.rewrite(content: file)
        XCTAssertEqual(expected, actual)
    }
    
    /// ------------------------------------------------
    func testMixedInlineAndDedicatedCallouts() throws {
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
 *  @param param dorky parameter {@link ParameterType#type}
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
/// 
/// Noop.
/// Comment line1.
/// 
/// 
/// - Version: 3.14159
/// - Author: hanjoes
/// - Since: epoch
/// - SeeAlso: some other code
/// - Parameter param: dorky parameter _ParameterType#type_
/// - Parameter param: dorky parameter brother
/// - Throws: some exception
/// - Throws: exception2
/// - Returns: void
/// 
public static func noop(param: Int) throws -> Void {
}
"""
        let actual = try DriftConverter.rewrite(content: file)
        XCTAssertEqual(expected, actual)
    }
    
    /// ------------------------------------------------
    func testMixedCalloutsWithCodeVoiceEmbedded() throws {
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
/// 
/// Noop.
/// Comment line1. `some code` is working!
/// 
/// 
/// - Version: 3.14159
/// "json" encoded
/// this API should not be used
/// - Author: hanjoes
/// - Throws: some exception `TestException` should `never be thrown.`
/// - Returns: void
/// 
public static func noop(param: Int) throws -> Void {
}
"""
        let actual = try DriftConverter.rewrite(content: file)
        XCTAssertEqual(expected, actual)
    }
    
    /// ------------------------------------------------
    func testMoreThanOneCommentBlock() throws {
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
/// 
/// Noop.
/// Comment line1. `some code` is working!
/// 
/// 
/// - Version: 3.14159
/// "json" encoded
/// this API should not be used
/// - Author: hanjoes
/// - Throws: some exception `TestException` should `never be thrown.`
/// - Returns: void
/// 
public static func noop(param: Int) throws -> Void {
}
/// 
/// Noop.
/// 
/// - Author: hanjoes
/// - Parameter param: dorky parameter
/// - Parameter param: dorky parameter brother
/// - Throws: some exception
/// - Throws: exception2
/// - Returns: void
/// 
public static func noop(param: Int) throws -> Void {
}
"""
        let actual = try DriftConverter.rewrite(content: file)
        XCTAssertEqual(expected, actual)
    }
    
    func testIndentedJavadoc() throws {
        let file =
"""
    /**
     * The type of a {@link org.antlr.v4.runtime.atn.LexerSkipAction} action.
     */
"""
        let expected =
"""
    /// 
    /// The type of a _org.antlr.v4.runtime.atn.LexerSkipAction_ action.
    /// 
"""
        let actual = try DriftConverter.rewrite(content: file)
        XCTAssertEqual(expected, actual)
    }
}
