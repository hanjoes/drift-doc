//
//  MockTestFile.swift
//  DriftRuntimeTests
//
//  Created by Hanzhou Shi on 7/6/17.
//

import Foundation

struct MockTest {
    static let sample1 =
"""
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;

import java.util.Collections;
import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

/**
 * Sample file.
 * <p>some text</p>
 *
 * @param howdy! <p>should break</p>
 * @param hanzhou {@version 12345 <head>sometext</head>}
 * <pre>
 * ctorBody
 *   : '{' superCall? stat* '}'
 *   ;
 * </pre>
 *
 * <p>
 * Or, you might see something like</p>
 *
 * <pre>
 * stat
 *   : superCall ';'
 *   | expression ';'
 *   | ...
 *   ;
 * </pre>
 *
 * a should be < 2 but > 3
 */
public class Support {
    private static final String[] TAGS = new String[]{
        "author",
        "code",
        "docRoot",
        "deprecated",
        "exception",
        "inheritDoc",
        "link",
        "linkplain",
        "literal",
        "param",
        "return",
        "see",
        "serial",
        "serialData",
        "serialField",
        "since",
        "throws",
        "value",
        "version"
    };

    private static Set<String> TAG_SET = new HashSet<>();

    static {
        Collections.addAll(TAG_SET, TAGS);
    }

    public static boolean isNotTag(String input) {
        String stripped = input.replaceAll("\\\\s+", "");
        System.out.println("Decision making on: " + stripped);
        if (stripped.startsWith("@") || stripped.startsWith("{@")) {
            int prefixLen = stripped.startsWith("@") ? 1 : 2;
            if (TAG_SET.contains(stripped.substring(prefixLen))) {
                System.out.println("Desicion made: false");
                return false;
            }
        }
        System.out.println("Desicion made: true");
        return true;
    }

    public static boolean openBrace(String input) {
        System.out.println("Open brace checking: " + input);
        return true;
    }
}
"""
    static let sample2 =
"""
open func getErrorHeader(_ e: AnyObject) -> String {
    let line: Int = (e as! RecognitionException).getOffendingToken().getLine()
    let charPositionInLine: Int = (e as! RecognitionException).getOffendingToken().getCharPositionInLine()
    return "line " + String(line) + ":" + String(charPositionInLine)
}
/** How should a token be displayed in an error message? The default
 *  is to display just the text, but during development you might
 *  want to have a lot of information spit out.  Override in that case
 *  to use t.toString() (which, for CommonToken, dumps everything about
 *  the token). This is better than forcing you to override a method in
 *  your token objects because you don't have to go modify your lexer
 *  so that it creates a new Java type.
 *
 * @deprecated This method is not called by the ANTLR 4 Runtime. Specific
 * implementations of {@link org.antlr.v4.runtime.ANTLRErrorStrategy} may provide a similar
 * feature when necessary. For example, see
 * {@link org.antlr.v4.runtime.DefaultErrorStrategy#getTokenErrorDisplay}.
 */
open func getTokenErrorDisplay(_ t: Token?) -> String {
    guard let t = t else {
        return "<no token>"
    }
    var s: String
    
    if let text = t.getText() {
        s = text
    } else {
        if t.getType() == CommonToken.EOF {
            s = "<EOF>"
        } else {
            s = "<\\(t.getType())>"
        }
    }
    s = s.replacingOccurrences(of: "\n", with: "\\n")
    s = s.replacingOccurrences(of: "\r", with: "\\r")
    s = s.replacingOccurrences(of: "\t", with: "\\t")
    return "\\(s)"
}
"""
    static let sample3 =
"""
/** Creates the CORS middleware from the values contained in the settings config json file.

     - Parameter configuration: The settings configuration.
     - Throws: Exception if the `CORSConfiugration` couldn't be parsed out of `Configs.Config`.
 */
"""
}
