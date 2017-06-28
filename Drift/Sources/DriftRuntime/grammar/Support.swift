import Antlr4

class Support {
    
    
    /// Determines whether look ahead is a JavaDoc.
    ///
    /// - Parameter input: token steam input
    /// - Returns: boolean indicating whether lookahead is javadoc
    static func lookAheadJavaDoc(_ input: TokenStream) -> Bool {
        return false
    }
}
