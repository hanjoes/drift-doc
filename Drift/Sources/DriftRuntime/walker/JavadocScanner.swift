import Antlr4

class JavadocScanner: JavadocParserBaseListener {
    
    var currentParent: ParentComponent! = nil
    
    override func enterJavadoc(_ ctx: JavadocParser.JavadocContext) {
        currentParent = Javadoc()
    }
    
    override func enterHtml_element(_ ctx: JavadocParser.Html_elementContext) {
        if let htmlContent = ctx.Doc_text()?.getText() {
            let htmlElement = HTMLElement(content: htmlContent)
            currentParent.children.append(htmlElement)
        }
    }
    
    override func enterInline_tag(_ ctx: JavadocParser.Inline_tagContext) {
        if let tagStr = ctx.tag.getText() {
            let nameStart = tagStr.index(tagStr.startIndex, offsetBy: 1)
            let tagName = String(tagStr.suffix(from: nameStart))
//            print("inlineTagName: \(tagName)")
            let inlineTag = InlineTag(tagName: tagName)
            currentParent.children.append(inlineTag)
        }
    }
    
    override func enterStandard_tag(_ ctx: JavadocParser.Standard_tagContext) {
        if let tagStr = ctx.tag.getText() {
            let nameStart = tagStr.index(tagStr.startIndex, offsetBy: 1)
            let tagName = String(tagStr.suffix(from: nameStart))
//            print("standardTagName: \(tagName)")
            let standardTag = StandardTag(tagName: tagName)
            currentParent.children.append(standardTag)
        }
    }
    
}
