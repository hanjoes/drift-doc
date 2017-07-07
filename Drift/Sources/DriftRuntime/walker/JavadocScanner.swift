import Antlr4

class JavadocScanner: JavadocParserBaseListener {
    
    var symbolTable: SymbolTable
    
    init(withSymbolTable symtab: SymbolTable) {
        self.symbolTable = symtab
        super.init()
    }
    
    override func enterJavadoc(_ ctx: JavadocParser.JavadocContext) {
    }
}
