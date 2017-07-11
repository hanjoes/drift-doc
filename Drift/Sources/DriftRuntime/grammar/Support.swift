import Antlr4

class Support {
    
    static let htmlTags = ["a", "abbr", "address", "area", "article", "aside", "audio", "b", "base", "bdi", "bdo",
                           "blockquote", "body", "br", "button", "canvas", "caption", "cite", "code", "col", "colgroup",
                           "command", "datalist", "dd", "del", "details", "dfn", "div", "dl", "dt", "em", "embed",
                           "fieldset", "figcaption", "figure", "footer", "form", "h1", "h2", "h3", "h4", "h5", "h6",
                           "head", "header", "hgroup", "hr", "html", "i", "iframe", "img", "input", "ins", "kbd",
                           "keygen", "label", "legend", "li", "link", "map", "mark", "menu", "meta", "meter", "nav",
                           "noscript", "object", "ol", "optgroup", "option", "output", "p", "param", "pre", "progress",
                           "q", "rp", "rt", "ruby", "s", "samp", "script", "section", "select", "small", "source",
                           "span", "strong", "style", "sub", "summary", "sup", "table", "tbody", "td", "textarea", 
                           "tfoot", "th", "thead", "time", "title", "tr", "track", "u", "ul", "var", "video", "wbr"]
                           

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
    
    public static func isHTMLElement(_ input: TokenStream) -> Bool {
        return true
    }
}
