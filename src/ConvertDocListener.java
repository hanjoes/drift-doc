import org.antlr.v4.runtime.BufferedTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStreamRewriter;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class ConvertDocListener extends SwiftBaseListener {

	private Set<Token> commentTokens = new HashSet<>();

	private BufferedTokenStream tokens;
	private TokenStreamRewriter rewriter;

	ConvertDocListener(BufferedTokenStream tokenStream) {
		this.tokens = tokenStream;
		this.rewriter = new TokenStreamRewriter(tokenStream);
	}

	@Override
	public void enterStatement(SwiftParser.StatementContext ctx) {
		grabCommentBeforeContext(ctx);
	}

	@Override
	public void exitStatement(SwiftParser.StatementContext ctx) {
		grabCommentAfterContext(ctx);
	}

	// We need declaration also since "class_body" is composed of declarations
	// and need to skip those declaration that are statements
	@Override
	public void enterDeclaration(SwiftParser.DeclarationContext ctx) {
		if (ctx.getParent() instanceof SwiftParser.StatementContext) {
			return;
		}
		grabCommentBeforeContext(ctx);
	}

	@Override
	public void exitDeclaration(SwiftParser.DeclarationContext ctx) {
		if (ctx.getParent() instanceof SwiftParser.StatementContext) {
			return;
		}
		grabCommentAfterContext(ctx);
	}

	@Override
	public void exitTop_level(SwiftParser.Top_levelContext ctx) {
		for (Token token : commentTokens) {
			System.out.println("comment: " + token.getText());
		}
	}

	private void grabCommentAfterContext(ParserRuleContext ctx) {
		Token stopToken = ctx.getStop();
		int stopIndex = stopToken.getTokenIndex();
		List<Token> blockComments = tokens.getHiddenTokensToRight(stopIndex, SwiftLexer.BLOCK_COMMENT);
		if (blockComments != null) {
			blockComments.forEach(blockComment -> {
				commentTokens.add(blockComment);
			});
		}
	}

	private void grabCommentBeforeContext(ParserRuleContext ctx) {
		Token startToken = ctx.getStart();
		int startIndex = startToken.getTokenIndex();
		List<Token> blockComments = tokens.getHiddenTokensToLeft(startIndex, SwiftLexer.BLOCK_COMMENT);
		if (blockComments != null) {
			blockComments.forEach(blockComment -> {
				commentTokens.add(blockComment);
			});
		}
	}
}
