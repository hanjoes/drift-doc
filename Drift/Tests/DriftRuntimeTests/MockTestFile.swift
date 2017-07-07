//
//  MockTestFile.swift
//  DriftRuntimeTests
//
//  Created by Hanzhou Shi on 7/6/17.
//

import Foundation

struct MockTest {
    static let file =
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
 * @param hanzhou {@version 12345}
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
}
