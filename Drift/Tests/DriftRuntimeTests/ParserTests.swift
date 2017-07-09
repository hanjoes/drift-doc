import XCTest
import Antlr4
@testable import DriftRuntime

class ParserTests: XCTestCase {
    
    func testParsingWithNoError() throws {
        try checkDocComponents(input: MockTest.file)
    }
    
    func checkDocComponents(input: String) throws {
        let stream = ANTLRInputStream(input)
        let lexer = JavadocLexer(stream)
        let tokenStream = CommonTokenStream(lexer)
        let parser = try! JavadocParser(tokenStream)
        let walker = ParseTreeWalker()
        let parseTree = try! parser.file()
        try walker.walk(JavadocScanner(), parseTree)
    }

}
