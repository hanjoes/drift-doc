import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.BufferedTokenStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStreamRewriter;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

// Gets a Javadoc and convert to Swift markup.
public class Javadoc2SwiftMarkup extends JavadocParserBaseListener {

	public static String getSwiftMarkupFromJavadoc(String javadoc) {
		ANTLRInputStream inputStream = new ANTLRInputStream(javadoc);
		CommonTokenStream tokenStream = new CommonTokenStream(new JavadocLexer(inputStream));
		JavadocParser parser = new JavadocParser(tokenStream);
		ParserRuleContext doc = parser.documentation();

		// walk the tree and convert doc
		ParseTreeWalker walker = new ParseTreeWalker();
		Javadoc2SwiftMarkup converter = new Javadoc2SwiftMarkup(tokenStream);
		walker.walk(converter, doc);

		return converter.getResult();
	}

	private BufferedTokenStream tokenStream;
	private TokenStreamRewriter rewriter;
	private Map<String, String> tagNameMap;

	public String getResult() {
		return rewriter.getText();
	}

	public Javadoc2SwiftMarkup(BufferedTokenStream tokenStream) {
		this.tokenStream = tokenStream;
		this.rewriter = new TokenStreamRewriter(tokenStream);
		initializeTagNameMap();
	}

	@Override
	public void enterBlockTag(JavadocParser.BlockTagContext ctx) {
		Token atToken = ctx.AT().getSymbol();
		rewriter.replace(atToken, "- ");

		Token tagName = ctx.blockTagName().NAME().getSymbol();
		rewriter.replace(tagName, tagNameMap.get(tagName.getText()));

		// need to process parameter name specifically
		if (tagName.getText().equals("param")) {
			rewriteParameterName(ctx);
		}
	}

	private void rewriteParameterName(JavadocParser.BlockTagContext ctx) {
		List<JavadocParser.BlockTagContentContext> content = ctx.blockTagContent();
		if (!content.isEmpty()) {
			JavadocParser.BlockTagContentContext contentContext = content.get(0);
			JavadocParser.BlockTagTextContext textContext = contentContext.blockTagText();
			List<JavadocParser.BlockTagTextElementContext> elementContext = textContext.blockTagTextElement();
			if (!elementContext.isEmpty()) {
				Token parameterName = elementContext.get(0).NAME().getSymbol();
				rewriter.replace(parameterName, parameterName.getText() + ":");
			}
		}
	}

	private void initializeTagNameMap() {
		this.tagNameMap = new HashMap<>();
		this.tagNameMap.put("param", "parameter");
		this.tagNameMap.put("return", "returns:");
		this.tagNameMap.put("see", "seealso:");
	}
}
