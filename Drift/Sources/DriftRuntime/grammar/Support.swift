import Antlr4

class Support {
    
    static let htmlTags: Set<String> = ["a", "abbr", "address", "area", "article", "aside", "audio", "b", "base", "bdi",
                           "blockquote", "body", "br", "button", "canvas", "caption", "cite", "code", "col", "colgroup",
                           "command", "datalist", "dd", "del", "details", "dfn", "div", "dl", "dt", "em", "embed",
                           "fieldset", "figcaption", "figure", "footer", "form", "h1", "h2", "h3", "h4", "h5", "h6",
                           "head", "header", "hgroup", "hr", "html", "i", "iframe", "img", "input", "ins", "kbd", "bdo",
                           "keygen", "label", "legend", "li", "link", "map", "mark", "menu", "meta", "meter", "nav",
                           "noscript", "object", "ol", "optgroup", "option", "output", "p", "param", "pre", "progress",
                           "q", "rp", "rt", "ruby", "s", "samp", "script", "section", "select", "small", "source",
                           "span", "strong", "style", "sub", "summary", "sup", "table", "tbody", "td", "textarea", 
                           "tfoot", "th", "thead", "time", "title", "tr", "track", "u", "ul", "var", "video", "wbr"]
                           

    public static func isInlineTag(_ input: TokenStream) -> Bool {
        guard let nextTokenText = Support.getLookAheadText(at: 1, in: input) else {
            return false
        }
        
        if nextTokenText == "{" {
            guard let afterNextTokenText = Support.getLookAheadText(at: 2, in: input) else {
                return false
            }
            
            return afterNextTokenText.starts(with: "@")
        }
        
        return false
    }
    
    public static func isHTMLElement(_ input: TokenStream) -> Bool {
        guard let nextTokenText = Support.getLookAheadText(at: 1, in: input) else {
            return false
        }
        
        if nextTokenText == "<" || nextTokenText == "</" {
            guard let afterNextTokenText = Support.getLookAheadText(at: 2, in: input) else {
                return false
            }
            
            return Support.htmlTags.contains(afterNextTokenText)
        }
        return false
    }
    
}

private extension Support {
    static func getLookAheadText(at lookAhead: Int, in tokenStream: TokenStream) -> String? {
        guard let lookAheadAttempt = try? tokenStream.LT(lookAhead) else {
            return nil
        }
        
        guard let lookAheadToken = lookAheadAttempt else {
            return nil
        }
        
        return lookAheadToken.getText()
    }
}
