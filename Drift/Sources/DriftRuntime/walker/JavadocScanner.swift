import Antlr4

class JavadocScanner: JavadocParserBaseListener {
    
    var enclosingComponent: ParentComponent! = nil
    
    var docs = [Javadoc]()
    
    override func enterJavadoc(_ ctx: JavadocParser.JavadocContext) {
        let javadoc = Javadoc(range: ctx.getStart()!.getTokenIndex()...ctx.getStop()!.getTokenIndex())
        enclosingComponent = javadoc
    }
    
    override func exitJavadoc(_ ctx: JavadocParser.JavadocContext) {
        docs.append(enclosingComponent as! Javadoc)
    }
    
    override func enterHtml_element(_ ctx: JavadocParser.Html_elementContext) {
        let contents = ctx.html_content()
        let contentText = contents.map { $0.getText() }
        var htmlElement = HTMLElement(content: contentText.joined(separator: ""))
        htmlElement.parentComponent = enclosingComponent
        enclosingComponent.children.append(htmlElement)
    }
    
    override func enterInline_tag(_ ctx: JavadocParser.Inline_tagContext) {
        if let tagStr = ctx.tag.getText() {
            let nameStart = tagStr.index(tagStr.startIndex, offsetBy: 1)
            let tagName = String(tagStr.suffix(from: nameStart))
//            print("inlineTagName: \(tagName)")
            var inlineTag = InlineTag(tagName: tagName)
            inlineTag.parentComponent = enclosingComponent
            enclosingComponent.children.append(inlineTag)
            enclosingComponent = inlineTag
        }
    }
    
    override func exitInline_tag(_ ctx: JavadocParser.Inline_tagContext) {
        let inlineTag = enclosingComponent as! InlineTag
        enclosingComponent = enclosingComponent.parentComponent
        enclosingComponent.children.append(inlineTag)
    }
    
    override func enterStandard_tag(_ ctx: JavadocParser.Standard_tagContext) {
        if let tagStr = ctx.tag.getText() {
            let nameStart = tagStr.index(tagStr.startIndex, offsetBy: 1)
            let tagName = String(tagStr.suffix(from: nameStart))
//            print("standardTagName: \(tagName)")
            var standardTag = StandardTag(tagName: tagName)
            standardTag.parentComponent = enclosingComponent
            enclosingComponent.children.append(standardTag)
            enclosingComponent = standardTag
        }
    }
    
    override func exitStandard_tag(_ ctx: JavadocParser.Standard_tagContext) {
        let standardTag = enclosingComponent as! StandardTag
        enclosingComponent = enclosingComponent.parentComponent
        enclosingComponent.children.append(standardTag)
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
        let textComponent = Text(data: text)
        if let lastComponent = enclosingComponent.children.last {
            if let lastTextComponent = lastComponent as? Text {
                enclosingComponent.children[enclosingComponent.children.count-1] = lastTextComponent.merged(with: textComponent)
//                print("Merged text: \(enclosingComponent.children[enclosingComponent.children.count-1])")
                return
            }
        }
        enclosingComponent.children.append(textComponent)
//        print("Text: \(textComponent)")
    }
}
