import Antlr4

class Support {
    public static func isNotInlineTagStart(_ input: TokenStream) -> Bool {
        let maybeNextToken = try! input.LT(1)
        
        guard let nextToken = maybeNextToken else {
            return true
        }
        guard (nextToken.getText())! == "{" else {
            return true
        }
        guard let afterNextToken = try! input.LT(2) else {
            return true
        }
        
        return (afterNextToken.getText())! != "@"
    }
}
