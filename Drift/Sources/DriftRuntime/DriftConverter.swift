import Foundation
import Antlr4

public struct DriftConverter {
    
    /// Emit Swift-style comment string from a file
    /// contains JAVA-style comments.
    ///
    /// - Parameter path: path to the file
    /// - Returns: the file content with only Swift-style comments.
    public func emitSwiftyComments(for file: URL) -> String {
        return ""
    }
    
}

extension DriftConverter {
    func emitSwiftComments(for content: String) -> String {
        let input = ANTLRInputStream(content)
        let lexer = JavadocLexer(input)
        let tokens = CommonTokenStream(lexer)
        if let parser = try? JavadocParser(tokens) {
            let scanner = JavadocScanner()
            let walker = ParseTreeWalker()
            guard let _ = try? walker.walk(scanner, parser.file()) else {
                return ""
            }
            return scanner.root.markup
        }
        return ""
    }
}
