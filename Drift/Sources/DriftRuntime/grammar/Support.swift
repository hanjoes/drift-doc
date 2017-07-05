import Antlr4

class Support {
    
    
    /// Determines whether look ahead is a JavaDoc.
    ///
    /// - Parameter input: token steam input
    /// - Returns: boolean indicating whether lookahead is javadoc
    static func lookAheadJavaDoc(_ input: TokenStream) -> Bool {
        let nextToken = try! input.LT(1)
        let currentTokenStr = try! input.getText()
        print("currentToken: \(currentTokenStr) nextToken: \(nextToken!.getText()!)")
        return true
    }

}
