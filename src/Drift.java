import org.antlr.runtime.tree.ParseTree;
import org.antlr.v4.runtime.ANTLRFileStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URL;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Drift {

	public static final String TMP_DIR = "/tmp";

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
			ConvertDocListener converter = new ConvertDocListener(tokenStream);
			walker.walk(converter, root);

			writeConvertedFile(pathname, converter.getResult());
		} catch (IOException e) {
			e.printStackTrace();
		}
		return true;
	}

	private void writeConvertedFile(String pathname, String result) {
		File file = new File(pathname);
		assert(file.exists());
		Path originalPath = Paths.get(pathname);
		String originalFilename = originalPath.getFileName().toString();
		Path bakPath = Paths.get(TMP_DIR + "/" + originalFilename + "_bak_" + System.currentTimeMillis());
		File bakFile = new File(bakPath.toString());
		boolean res = file.renameTo(bakFile);
		if (res) {
			System.out.println("Backup file for: " + pathname + " created at " + bakPath.toString());
			try (PrintWriter pw = new PrintWriter(pathname)) {
				pw.write(result);
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			}
		}
		else {
			System.out.println("Backup file creation failed. Aborted.");
		}
	}
}
