import GenericBitSet
import Antlr4

class SwiftSupport {
    
    ///
    /// operator-head : /  =  -  +  !  *  %  <  >  &  |  ^  ~  ?
    /// | [\u00A1-\u00A7]
    /// | [\u00A9\u00AB]
    /// | [\u00AC\u00AE]
    /// | [\u00B0-\u00B1\u00B6\u00BB\u00BF\u00D7\u00F7]
    /// | [\u2016-\u2017\u2020-\u2027]
    /// | [\u2030-\u203E]
    /// | [\u2041-\u2053]
    /// | [\u2055-\u205E]
    /// | [\u2190-\u23FF]
    /// | [\u2500-\u2775]
    /// | [\u2794-\u2BFF]
    /// | [\u2E00-\u2E7F]
    /// | [\u3001-\u3003]
    /// | [\u3008-\u3030]
    /// 
    ///
    public static var operatorHeadUnicodeSet: GenericBitSet.BitSet<UInt64> = {
        let result = GenericBitSet.BitSet<UInt64>(numBits: 0x10000)
        // operator-head → /  =­  -­  +­  !­  *­  %­  <­  >­  &­  |­  ^­  ~­  ?­
        result.set(at: unicode(of: "/"))
        result.set(at: unicode(of: "="))
        result.set(at: unicode(of: "-"))
        result.set(at: unicode(of: "+"))
        result.set(at: unicode(of: "!"))
        result.set(at: unicode(of: "*"))
        result.set(at: unicode(of: "%"))
        result.set(at: unicode(of: "<"))
        result.set(at: unicode(of: ">"))
        result.set(at: unicode(of: "&"))
        result.set(at: unicode(of: "|"))
        result.set(at: unicode(of: "^"))
        result.set(at: unicode(of: "~"))
        result.set(at: unicode(of: "?"))
        
        // operator-head → U+00A1–U+00A7
        result.set(range: 0x00A1...0x00A7)
        
        // operator-head → U+00A9 or U+00AB
        result.set(at: 0x00A9)
        result.set(at: 0x00AB)
        
        // operator-head → U+00AC or U+00AE
        result.set(at: 0x00AC)
        result.set(at: 0x00AE)
        
        // operator-head → U+00A9 or U+00AB
        result.set(at: 0x00A9)
        result.set(at: 0x00AB)
        
        // operator-head → U+00B0–U+00B1, U+00B6, U+00BB, U+00BF, U+00D7, or U+00F7
        result.set(range: 0x00B0...0x00B1)
        result.set(at: 0x00B6)
        result.set(at: 0x00BB)
        result.set(at: 0x00BF)
        result.set(at: 0x00D7)
        result.set(at: 0x00F7)
        
        // operator-head → U+2016–U+2017 or U+2020–U+2027
        result.set(range: 0x2016...0x2017)
        result.set(range: 0x2020...0x2027)
        
        // operator-head → U+2030–U+203E
        result.set(range: 0x2030...0x203E)
        
        // operator-head → U+2041–U+2053
        result.set(range: 0x2041...0x2053)
        
        // operator-head → U+2055–U+205E
        result.set(range: 0x2055...0x205E)
        
        // operator-head → U+2190–U+23FF
        result.set(range: 0x2190...0x23FF)
        
        // operator-head → U+2500–U+2775
        result.set(range: 0x2500...0x2775)
        
        // operator-head → U+2794–U+2BFF
        result.set(range: 0x2794...0x2BFF)
        
        // operator-head → U+2E00–U+2E7F
        result.set(range: 0x2E00...0x2E7F)
        
        // operator-head → U+3001–U+3003
        result.set(range: 0x3001...0x3003)
        
        // operator-head → U+3008–U+3030
        result.set(range: 0x3008...0x3030)
        return result
    }()
    
    public static var operatorCharacterUnicodeSet: GenericBitSet.BitSet<UInt64> = {
        let result = GenericBitSet.BitSet<UInt64>(numBits: 0x10000)
        // operator-character → operator-head­
        result.union(with: SwiftSupport.operatorHeadUnicodeSet)
        
        // operator-character → U+0300–U+036F
        result.set(range: 0x0300...0x036F)
        // operator-character → U+1DC0–U+1DFF
        result.set(range: 0x1DC0...0x1DFF)
        // operator-character → U+20D0–U+20FF
        result.set(range: 0x20D0...0x20FF)
        // operator-character → U+FE00–U+FE0F
        result.set(range: 0xFE00...0xFE0F)
        // operator-character → U+FE20–U+FE2F
        result.set(range: 0xFE20...0xFE2F)
        
        // TODO:
        // operator-character → U+E0100–U+E01EF
        // Java works with 16-bit unicode chars. However, it can work for targets in other languages, e.g. in Swift
        // operatorCharacter.set(0xE0100,0xE01EF+1)
        
        return result
    }()
    
    public static var leftWSTokenSet: GenericBitSet.BitSet<UInt64> = {
        let result = GenericBitSet.BitSet<UInt64>(numBits: 255)
        result.set(at: Swift3Parser.Tokens.WS.rawValue)
        result.set(at: Swift3Parser.Tokens.LPAREN.rawValue)
        result.set(at: Swift3Parser.Tokens.LBRACK.rawValue)
        result.set(at: Swift3Parser.Tokens.LCURLY.rawValue)
        result.set(at: Swift3Parser.Tokens.COMMA.rawValue)
        result.set(at: Swift3Parser.Tokens.COLON.rawValue)
        result.set(at: Swift3Parser.Tokens.SEMI.rawValue)
        return result
    }()
    
    public static var rightWSTokenSet: GenericBitSet.BitSet<UInt64> = {
        let result = GenericBitSet.BitSet<UInt64>(numBits: 255)
        result.set(at: Swift3Parser.Tokens.WS.rawValue)
        result.set(at: Swift3Parser.Tokens.RPAREN.rawValue)
        result.set(at: Swift3Parser.Tokens.RBRACK.rawValue)
        result.set(at: Swift3Parser.Tokens.RCURLY.rawValue)
        result.set(at: Swift3Parser.Tokens.COMMA.rawValue)
        result.set(at: Swift3Parser.Tokens.COLON.rawValue)
        result.set(at: Swift3Parser.Tokens.SEMI.rawValue)
        result.set(at: Swift3Parser.Tokens.Line_comment.rawValue)
        result.set(at: Swift3Parser.Tokens.Block_comment.rawValue)
        return result
    }()
    
    private static func isCharacter(_ token: Token, fromSet bitSet: GenericBitSet.BitSet<UInt64>) -> Bool {
        if (token.getType() == ANTLRInputStream.EOF) {
            return false
        } else {
            let text = token.getText()
            return bitSet.one(at: Int(text!.unicodeScalars.first!.value))
        }
    }
    
    public static func isOperatorHead(_ token: Token) -> Bool {
        return SwiftSupport.isCharacter(token, fromSet: self.operatorHeadUnicodeSet)
    }
    
    public static func isOperatorCharacter(_ token: Token) -> Bool {
        return SwiftSupport.isCharacter(token, fromSet: SwiftSupport.operatorCharacterUnicodeSet)
    }
    
    public static func isOpNext(_ tokens: TokenStream) throws -> Bool {
        let stop = try SwiftSupport.getLastOpTokenIndex(tokens)
        return stop != -1
    }
    
    /// Find stop token index of next operator return -1 if not operator.
    public static func getLastOpTokenIndex(_ tokens: TokenStream) throws -> Int{
        var currentTokenIndex = tokens.index() // current on-channel lookahead token index
        var currentToken = try tokens.get(currentTokenIndex)
        let rightAfterCurrentToken = try tokens.get(currentTokenIndex + 1)

        // operator → dot-operator-head­ dot-operator-characters

        if (currentToken.getType() == Swift3Parser.Tokens.DOT.rawValue &&
            rightAfterCurrentToken.getType() == Swift3Parser.Tokens.DOT.rawValue) {
            
            // dot-operator
            currentTokenIndex += 2 // point at token after ".."
            currentToken = try tokens.get(currentTokenIndex)
            
            // dot-operator-character → .­ | operator-character­
            while (currentToken.getType() == Swift3Parser.Tokens.DOT.rawValue || isOperatorCharacter(currentToken)) {
                currentTokenIndex += 1
                currentToken = try tokens.get(currentTokenIndex)
            }
            
            return currentTokenIndex - 1
        }
        
        // operator → operator-head­ operator-characters­?
        
        if (isOperatorHead(currentToken)) {
            while (isOperatorCharacter(currentToken)) {
                currentTokenIndex += 1
                currentToken = try tokens.get(currentTokenIndex)
            }
            return currentTokenIndex - 1
        }
    
        return -1
    }
    
    ///
    /// "If an operator has whitespace around both sides or around neither side,
    /// it is treated as a binary operator. As an example, the + operator in a+b
    /// and a + b is treated as a binary operator."
    ///
    public static func isBinaryOp(_ tokens: TokenStream) throws -> Bool {
        let stop = try SwiftSupport.getLastOpTokenIndex(tokens)
        
        guard stop != -1 else {
            return false
        }
        
        let start = tokens.index()
        let prevToken = try tokens.get(start-1) // includes hidden-channel tokens
        let nextToken = try tokens.get(stop+1)
        let prevIsWS = SwiftSupport.isLeftOperatorWS(prevToken)
        let nextIsWS = SwiftSupport.isRightOperatorWS(nextToken)
        let result = (prevIsWS && nextIsWS) || (!prevIsWS && !nextIsWS)
        return result
    }
    
    ///
    /// "If an operator has whitespace on the left side only, it is treated as a
    /// prefix unary operator. As an example, the ++ operator in a ++b is treated
    /// as a prefix unary operator."
    ///
    public static func isPrefixOp(_ tokens: TokenStream) throws -> Bool {
        let stop = try SwiftSupport.getLastOpTokenIndex(tokens)
        
        guard stop != -1 else {
            return false
        }
        
        let start = tokens.index()
        let prevToken = try tokens.get(start-1)
        let nextToken = try tokens.get(stop+1)
        let prevIsWS = SwiftSupport.isLeftOperatorWS(prevToken)
        let nextIsWS = SwiftSupport.isRightOperatorWS(nextToken)
        return prevIsWS && !nextIsWS
    }
    
    ///
    /// "If an operator has whitespace on the right side only, it is treated as a
    /// postfix unary operator. As an example, the ++ operator in a++ b is treated
    /// as a postfix unary operator."
    ///
    /// "If an operator has no whitespace on the left but is followed immediately
    /// by a dot (.), it is treated as a postfix unary operator. As an example,
    /// the ++ operator in a++.b is treated as a postfix unary operator (a++ .b
    /// rather than a ++ .b)."
    ///
    public static func isPostfixOp(_ tokens: TokenStream) throws -> Bool {
        let stop = try SwiftSupport.getLastOpTokenIndex(tokens)
        
        guard stop != -1 else {
            return false
        }
        
        let start = tokens.index()
        let prevToken = try tokens.get(start-1) // includes hidden-channel tokens
        let nextToken = try tokens.get(stop+1)
        let prevIsWS = SwiftSupport.isLeftOperatorWS(prevToken)
        let nextIsWS = SwiftSupport.isRightOperatorWS(nextToken)
        let result = (!prevIsWS && nextIsWS) ||
            (!prevIsWS && nextToken.getType()==Swift3Parser.Tokens.DOT.rawValue)
        return result
    }

    public static func isOperator(_ tokens: TokenStream, _ op: String) throws -> Bool {
        let stop = try SwiftSupport.getLastOpTokenIndex(tokens)
        
        guard stop != -1 else {
            return false
        }
        let start = tokens.index()
        let text = try tokens.getText(Interval.of(start, stop))
        return text == op
    }

    public static func isLeftOperatorWS(_ t: Token) -> Bool {
        return SwiftSupport.leftWSTokenSet.one(at: t.getType())
    }

    public static func isRightOperatorWS(_ t: Token) -> Bool {
        return SwiftSupport.rightWSTokenSet.one(at: t.getType()) || t.getType()==ANTLRInputStream.EOF
    }

    public static func isSeparatedStatement(_ tokens: TokenStream, _ indexOfPreviousStatement: Int) throws -> Bool {
        var indexFrom = indexOfPreviousStatement - 1
        let indexTo = tokens.index() - 1
        
        // Stupid check for new line and semicolon, can be optimized
        guard indexFrom >= 0 else {
            return true
        }
        
        let currentToken = try tokens.get(indexFrom)
        while (indexFrom >= 0 && currentToken.getType() == CommonToken.HIDDEN_CHANNEL) {
            indexFrom -= 1
        }
        
        return try tokens.getText(Interval.of(indexFrom, indexTo)).range(of: "\n") != nil
    }
}

// MARK: - Helper Methods


fileprivate func unicode(of singleCharString: String) -> Int {
    return Int(UnicodeScalar(singleCharString)!.value)
}
