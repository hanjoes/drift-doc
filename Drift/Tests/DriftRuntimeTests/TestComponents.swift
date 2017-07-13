import XCTest
import Antlr4
@testable import DriftRuntime

class TestComponents: XCTestCase {
    ///
    /// A relatively comprehensive test sample with Javadoc.
    ///
    func testScanningSample1() {
        let expected = """
        |:|:
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
         :|:|:|
        """
        checkDocComponents(expecting: expected, input: MockTest.sample1)
    }
    
    ///
    /// Yet another test sample with Javadoc in it.
    ///
    func testScanningSample2() {
        let expected = """
        |:|: How should a token be displayed in an error message? The default
         *  is to display just the text, but during development you might
         *  want to have a lot of information spit out.  Override in that case
         *  to use t.toString() (which, for CommonToken, dumps everything about
         *  the token). This is better than forcing you to override a method in
         *  your token objects because you don't have to go modify your lexer
         *  so that it creates a new Java type.
         *
         * :||:@deprecated|: This method is not called by the ANTLR 4 Runtime. Specific
         * implementations of :||:{@link|: org.antlr.v4.runtime.ANTLRErrorStrategy:|}:||: may provide a similar
         * feature when necessary. For example, see
         * :||:{@link|: org.antlr.v4.runtime.DefaultErrorStrategy#getTokenErrorDisplay:|}:||:.
         :|:|:|
        """
        checkDocComponents(expecting: expected, input: MockTest.sample2)
    }
    
    /// Test sample that's not containing any Javadoc in comment.
    func testScanningSample3() {
        let expected = """
        |:|: Creates the CORS middleware from the values contained in the settings config json file.

             - Parameter configuration: The settings configuration.
             - Throws: Exception if the `CORSConfiugration` couldn't be parsed out of `Configs.Config`.
         :|:|
        """
        checkDocComponents(expecting: expected, input: MockTest.sample3)
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
