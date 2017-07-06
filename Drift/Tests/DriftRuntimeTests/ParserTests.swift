import XCTest
import GitRuntime
import Antlr4
import DriftRuntime

class ParserTests: XCTestCase {
    
    private static let EMPTY_COMMENT =
    "/** */"
    
    private static let PLAIN_TEXT_ONLY =
    "/** Comment here. */"
    
    private static let HTML =
    "/** Comment here. <p> */"
    
    private static let HTML_INLINE_TAG =
    "/** Comment here. <p> {@code some code here} */"
    
    private static let INLINE_TAG_STANDARD_TAG =
    "/** Comment here. <p> {@code some code here} " +
    "  *                                          " +
    "  * @param parameter1 parameter1 description " +
    "  */                                         "

    private static let INLINE_TAG_WITH_HTML =
    "/** Comment here. <p> {@code <head></head>}  " +
    "  *                                          " +
    "  * @param parameter1 parameter1 description " +
    "  */                                         "
    
    private static let STANDARD_TAG_WITH_HTML =
    "/** Comment here. <p> {@code <head></head>}  " +
    "  *                                          " +
    "  * @param parameter1 parameter1 description " +
    "  * @param parameter2 <h1>description</h1>   " +
    "  */                                         "

    private static let STANDARD_TAG_WITH_INLINE_TAG =
    "/** Comment here. <p> {@code <head></head>}  " +
    "  *                                          " +
    "  * @param parameter1 parameter1 {@code code}" +
    "  */                                         "
    
    private static let META_CHARACTER =
    "/** Comment here. <p> {@code <head></head>}  " +
    "  * In case value < 2 but > 3. {rare}        " +
    "  * @param parameter1 parameter1 {@code code}" +
    "  * @param param2 < 2 > some value { weird! }" +
    "  */                                         "
    
    private static let TESTS = [
        EMPTY_COMMENT,
        PLAIN_TEXT_ONLY,
        HTML,
        HTML_INLINE_TAG,
        INLINE_TAG_STANDARD_TAG,
        INLINE_TAG_WITH_HTML,
        STANDARD_TAG_WITH_HTML,
        STANDARD_TAG_WITH_INLINE_TAG,
        META_CHARACTER
    ]
    
    func testParsingWithNoError() throws {
        _ = ParserTests.TESTS.map {
            createParserAndCheck(input: $0)
        }
    }
    
    /// Parses a given input string and make sure there is no error.
    ///
    /// - Parameter input: input string to be parsed.
    func createParserAndCheck(input: String) {
        let stream = ANTLRInputStream(ParserTests.EMPTY_COMMENT)
        let lexer = JavadocLexer(stream)
        let tokenStream = CommonTokenStream(lexer)
        let parser = try! JavadocParser(tokenStream)
        try! parser.file()
        XCTAssertEqual(0, parser.getNumberOfSyntaxErrors())
    }

}
