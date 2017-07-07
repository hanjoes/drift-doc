import XCTest
import Antlr4
import DriftRuntime

class ParserTests: XCTestCase {
    
    func testParsingWithNoError() throws {
        createParserAndCheck(input: MockTest.file)
    }
    
    /// Parses a given input string and make sure there is no error.
    ///
    /// - Parameter input: input string to be parsed.
    func createParserAndCheck(input: String) {
        let stream = ANTLRInputStream(input)
        let lexer = JavadocLexer(stream)
        let tokenStream = CommonTokenStream(lexer)
        let parser = try! JavadocParser(tokenStream)
        try! parser.file()
        XCTAssertEqual(0, parser.getNumberOfSyntaxErrors())
    }

}
