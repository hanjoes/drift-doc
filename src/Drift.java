import org.antlr.runtime.tree.ParseTree;
import org.antlr.v4.runtime.ANTLRFileStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

public class Drift {

	// Recursively search a directory for ".swift" files and
	// convert any java-like doc to swift doc.
	public static void main(String[] args) {
		if (args.length < 1) {
			System.out.println("Usage: Drift folder.");
			return;
		}

		Drift d = new Drift();
		d.recursiveConvertDoc(args[0]);
	}

	private void recursiveConvertDoc(String path) {
		System.out.println("Looking for all swift files under " + path + "...");
		List<String> swiftFilePaths = recursiveFindSwiftFile(path);
		for (String swiftFilePath : swiftFilePaths) {
			System.out.println(swiftFilePath);
		}
		long count = swiftFilePaths.stream().filter(this::convertFile).count();
		System.out.println("Found " + swiftFilePaths.size() + " converted " + count);
	}

	private List<String> recursiveFindSwiftFile(String root) {
		List<String> result = new ArrayList<>();
		File currentFolder = new File(root);
		String[] children = currentFolder.list();
		if (children == null) {
			return result;
		}

		for (String child : children) {
			// skip hidden folders
			if (child.startsWith(".")) {
				continue;
			}

			String childPath = root + "/" + child;
			File childFile = new File(childPath);
			if (childFile.isDirectory()) {
				result.addAll(recursiveFindSwiftFile(childPath));
			}
			else if (child.endsWith(".swift")) {
				result.add(childPath);
			}
		}
		return result;
	}

	private boolean convertFile(String pathname) {
		System.out.println("Converting " + pathname);
		try {
			ANTLRFileStream fileStream = new ANTLRFileStream(pathname);
			CommonTokenStream tokenStream = new CommonTokenStream(new SwiftLexer(fileStream));
			SwiftParser parser = new SwiftParser(tokenStream);
			ParserRuleContext root = parser.top_level();
			// Walk the tree
			ParseTreeWalker walker = new ParseTreeWalker();
			walker.walk(new ConvertDocListener(), root);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return true;
	}
}
