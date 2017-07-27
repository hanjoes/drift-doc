import Foundation
import Antlr4

public struct DriftConverter {
    
    /// Prevent from using initializer.
    private init() {
    }
    
    public static func rewrite(content: String) throws -> String {
        let input = ANTLRInputStream(content)
        let lexer = JavadocLexer(input)
        let tokens = CommonTokenStream(lexer)
        try tokens.fill()
        let rewriter = TokenStreamRewriter(tokens)
        let javadocs = emitJavaDocs(from: tokens)
        try javadocs.forEach {
            let range = $0.range
            let markupDesc = $0.markup.description
            let markupLines = markupDesc.split(separator: "\n", maxSplits: Int.max, omittingEmptySubsequences: false)
            let replacement = markupLines.map { "/// \($0)" }.joined(separator: "\n")
            try rewriter.replace(range.lowerBound, range.upperBound, replacement)
        }
        return try rewriter.getText()
    }
    
}

private extension DriftConverter {
    
    static func makeANTLRTokenStream(from content: String) -> TokenStream {
        let input = ANTLRInputStream(content)
        let lexer = JavadocLexer(input)
        return CommonTokenStream(lexer)
    }
    
    static func emitJavaDocs(from tokens: TokenStream) -> [Javadoc] {
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
}
