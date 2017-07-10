import XCTest
import Antlr4
@testable import DriftRuntime

class TestComponents: XCTestCase {
    
    func testScannedComponents() throws {
        let expected = """
        /**|:
         * Sample file.
         * :||:p:||:some text:||:p:||:
         *
         * :||:@param|: howdy! :||:p:||:should break:||:p:||:
         * :|:||:@param|: hanzhou :||:{@version|: 12345 :||:head:||:sometext:||:head:|}:||:
         * :||:pre:||:
         * ctorBody
         *   : '{' superCall? stat* '}'
         *   ;
         * :||:pre:||:
         *
         * :||:p:||:
         * Or, you might see something like:||:p:||:
         *
         * :||:pre:||:
         * stat
         *   : superCall ';'
         *   | expression ';'
         *   | ...
         *   ;
         * :||:pre:||:
         *
         * a should be < 2 but > 3
         :|:|*/
        """
        checkDocComponents(expecting: expected, input: MockTest.file)
    }
    
    func checkDocComponents(expecting expected: String, input: String) {
        let stream = ANTLRInputStream(input)
        let lexer = JavadocLexer(stream)
        let tokenStream = CommonTokenStream(lexer)
        let parser = try! JavadocParser(tokenStream)
        let walker = ParseTreeWalker()
        let parseTree = try! parser.file()
        let scanner = JavadocScanner()
        if let _ = try? walker.walk(scanner, parseTree) {
            XCTAssertEqual(expected, scanner.root.description)
        }
    }

}
