import XCTest
import GitRuntime
import Antlr4
import DriftRuntime

class ParserTests: XCTestCase {
    
    private static let EmptyComment = "/** abcde */"
    
    func testParsingWithNoError() throws {
        createParserAndCheck(input: ParserTests.EmptyComment)
    }
    
    /// Parses a given input string and make sure there is no error.
    ///
    /// - Parameter input: input string to be parsed.
    func createParserAndCheck(input: String) {
        let stream = ANTLRInputStream(ParserTests.EmptyComment)
        let lexer = JavadocLexer(stream)
        let tokenStream = CommonTokenStream(lexer)
        let parser = try! JavadocParser(tokenStream)
        try! parser.file()
        XCTAssertEqual(0, parser.getNumberOfSyntaxErrors())
    }

}
