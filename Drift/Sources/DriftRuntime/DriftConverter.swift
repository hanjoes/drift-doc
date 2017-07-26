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
    
    func makeANTLRTokenStream(from content: String) -> TokenStream {
        let input = ANTLRInputStream(content)
        let lexer = JavadocLexer(input)
        return CommonTokenStream(lexer)
    }
    
    func rewrite(content: String) throws -> String {
        let input = ANTLRInputStream(content)
        let lexer = JavadocLexer(input)
        let tokens = CommonTokenStream(lexer)
        try tokens.fill()
        let rewriter = TokenStreamRewriter(tokens)
        let javadocs = emitJavaDocs(for: content)
        try javadocs.forEach {
            let range = $0.range
            let markupDesc = $0.markup.description
            let markupLines = markupDesc.split(separator: "\n", maxSplits: Int.max, omittingEmptySubsequences: false)
            let replacement = markupLines.map { "/// \($0)" }.joined(separator: "\n")
            try rewriter.replace(range.lowerBound, range.upperBound, replacement)
        }
        return try rewriter.getText()
    }
    
    func emitJavaDocs(for content: String) -> [Javadoc] {
        let tokens = makeANTLRTokenStream(from: content)
        if let parser = try? JavadocParser(tokens) {
            let scanner = JavadocScanner()
            let walker = ParseTreeWalker()
            guard let _ = try? walker.walk(scanner, parser.file()) else {
                return [Javadoc]()
            }
            
            return scanner.docs
        }
        return [Javadoc]()
    }
    
    func emitSwiftComments(for content: String) -> String {
        return self.emitJavaDocs(for: content).map {
            $0.markup.description
        }.joined(separator: "").split(separator: "\n", maxSplits: Int.max, omittingEmptySubsequences: false).map {
            "/// \($0)"
        }.joined(separator: "\n")
    }
}
