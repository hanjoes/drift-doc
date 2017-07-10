import Antlr4

class JavadocScanner: JavadocParserBaseListener {
    
    var currentParent: ParentComponent! = nil
    
    var root = Javadoc()
    
    override func enterJavadoc(_ ctx: JavadocParser.JavadocContext) {
        currentParent = root
    }
    
    override func enterHtml_element(_ ctx: JavadocParser.Html_elementContext) {
        let contents = ctx.html_content()
        let contentText = contents.map { $0.getText() }
        let htmlElement = HTMLElement(content: contentText.joined(separator: ""))
        currentParent.children.append(htmlElement)
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
    
    override func enterOpenBrace(_ ctx: JavadocParser.OpenBraceContext) {
        process(text: ctx.getText())
    }
    
    override func enterCloseBrace(_ ctx: JavadocParser.CloseBraceContext) {
        process(text: ctx.getText())
    }
    
    override func enterHTMLOpen(_ ctx: JavadocParser.HTMLOpenContext) {
        process(text: ctx.getText())
    }
    
    override func enterHTMLClose(_ ctx: JavadocParser.HTMLCloseContext) {
        process(text: ctx.getText())
    }
    
    override func enterDocText(_ ctx: JavadocParser.DocTextContext) {
        process(text: ctx.getText())
    }
    
    override func enterInlineTagOpenBrace(_ ctx: JavadocParser.InlineTagOpenBraceContext) {
        process(text: ctx.getText())
    }
    
    override func enterInlineTagCloseBrace(_ ctx: JavadocParser.InlineTagCloseBraceContext) {
        process(text: ctx.getText())
    }
    
    override func enterInlineTagHTMLOpen(_ ctx: JavadocParser.InlineTagHTMLOpenContext) {
        process(text: ctx.getText())
    }
    
    override func enterInlineTagHTMLClose(_ ctx: JavadocParser.InlineTagHTMLCloseContext) {
        process(text: ctx.getText())
    }
    
    override func enterInlineTagDocText(_ ctx: JavadocParser.InlineTagDocTextContext) {
        process(text: ctx.getText())
    }
    
    override func enterDocWS(_ ctx: JavadocParser.DocWSContext) {
        process(text: ctx.getText())
    }
    
    override func enterInlineTagDocWS(_ ctx: JavadocParser.InlineTagDocWSContext) {
        process(text: ctx.getText())
    }
}

// MARK: - Helper Methods
private extension JavadocScanner {
    func process(text: String) {
        if let lastComponent = currentParent.children.last {
            let textComponent = Text(data: text)
            if let lastTextComponent = lastComponent as? Text {
                currentParent.children[currentParent.children.count-1] = lastTextComponent.merged(with: textComponent)
//                print("Merged text: \(currentParent.children[currentParent.children.count-1])")
            }
            else {
                currentParent.children.append(textComponent)
//                print("Text: \(textComponent)")
            }
        }
    }
}
