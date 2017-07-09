import Antlr4

class Support {
    public static func isNotInlineTagStart(_ input: TokenStream) -> Bool {
        if let nextToken = try! input.LT(1) {
            if (nextToken.getText())! == "{" {
                if let afterNextToken = try! input.LT(2) {
                    if let tagStr = afterNextToken.getText() {
                        return !tagStr.starts(with: "@")
                    }
                }
            }
        }
        
        return true
    }
}
