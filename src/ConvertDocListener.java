import org.antlr.v4.runtime.BufferedTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStreamRewriter;

import java.util.*;

public class ConvertDocListener extends SwiftBaseListener {

	private Set<Token> commentTokens = new HashSet<>();

	private BufferedTokenStream tokens;
	private TokenStreamRewriter rewriter;

	ConvertDocListener(BufferedTokenStream tokenStream) {
		this.tokens = tokenStream;
		this.rewriter = new TokenStreamRewriter(tokenStream);
	}

	public String getResult() {
		return rewriter.getText();
	}

	@Override
	public void enterStatement(SwiftParser.StatementContext ctx) {
		grabCommentBeforeContext(ctx);
	}

	@Override
	public void exitStatement(SwiftParser.StatementContext ctx) {
		grabCommentAfterContext(ctx);
	}

	@Override
	public void enterProtocol_member_declaration(SwiftParser.Protocol_member_declarationContext ctx) {
		grabCommentBeforeContext(ctx);
	}

	@Override
	public void exitProtocol_member_declaration(SwiftParser.Protocol_member_declarationContext ctx) {
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
			rewriteComment(token);
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

	// rewrite token, assuming no nesting
	private void rewriteComment(final Token token) {
		String comment = token.getText();
		// get rid of ws for whole comment
		comment = comment.trim();

		// remove comment block symbol
		comment = trimBlock(comment);
		comment = comment.trim();

		// handle those lines begin with '*'
		comment = trimLine(comment);

		// prepend each line with '// '
		comment = prependLineCommentSymbol(comment);

		// insert it back
		rewriter.replace(token, comment);
	}

	private String trimBlock(final String comment) {
		assert(comment.startsWith("/*"));
		assert(comment.endsWith("*/"));
		// beginning of the content.
		int i = 2;
		while (comment.charAt(i) == '*') ++i;
		int j = comment.length() - 2;
		while (comment.charAt(j) == '*' && j > i) --j;
		return comment.substring(i, j);
	}

	// Trim each line (in case it's beginning with '*'.
	// Assuming the beginning '*' is trivial. (e.g. not multiplication, etc.)
	private String trimLine(final String comment) {
		String[] lines = comment.split("\n");

		StringBuilder sb = new StringBuilder();
		for (String line : lines) {
			line = line.trim();
			if (line.startsWith("*")) {
				line = line.trim();
				int i = 0;
				while (i < line.length() && line.charAt(i) == '*') ++i;
				line = line.substring(i);
			}
			sb.append(line.trim()).append('\n');
		}
		return sb.toString();
	}

	private String prependLineCommentSymbol(final String comment) {
		String[] lines = comment.split("\n");
		return Arrays.stream(lines)
				.map(s -> "// " + s)
				.reduce("", ((tmp, s) -> tmp + (tmp.length() > 0 ? "\n" : "") + s));
	}
}
