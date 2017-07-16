import Foundation

/// Test Resources.
struct Resources {
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
    
    static let sample4 =
"""
/// Copyright (c) 2012-2017 The ANTLR Project. All rights reserved.
/// Use of this file is governed by the BSD 3-clause license that
/// can be found in the LICENSE.txt file in the project root.


import Foundation

open class ATNSimulator {
    /// -  Use {@link org.antlr.v4.runtime.atn.ATNDeserializer#SERIALIZED_VERSION} instead.
    public static let SERIALIZED_VERSION: Int = {
        return ATNDeserializer.SERIALIZED_VERSION
    }()


    /// This is the current serialized UUID.
    /// -  Use {@link org.antlr.v4.runtime.atn.ATNDeserializer#checkCondition(boolean)} instead.
    public static let SERIALIZED_UUID: UUID = {
        return (ATNDeserializer.SERIALIZED_UUID as UUID)
    }()


    /// Must distinguish between missing edge and edge we know leads nowhere

    public static let ERROR: DFAState = {
        let error = DFAState(ATNConfigSet())
        error.stateNumber = Int.max
        return error
    }()

    public var atn: ATN
    
    /// The context cache maps all PredictionContext objects that are equals()
    /// to a single cached copy. This cache is shared across all contexts
    /// in all ATNConfigs in all DFA states.  We rebuild each ATNConfigSet
    /// to use only cached nodes/graphs in addDFAState(). We don't want to
    /// fill this during closure() since there are lots of contexts that
    /// pop up but are not used ever again. It also greatly slows down closure().
    ///
    /// <p>This cache makes a huge difference in memory and a little bit in speed.
    /// For the Java grammar on java.*, it dropped the memory requirements
    /// at the end from 25M to 16M. We don't store any of the full context
    /// graphs in the DFA because they are limited to local context only,
    /// but apparently there's a lot of repetition there as well. We optimize
    /// the config contexts before storing the config set in the DFA states
    /// by literally rebuilding them with cached subgraphs only.</p>
    ///
    /// <p>I tried a cache for use during closure operations, that was
    /// whacked after each adaptivePredict(). It cost a little bit
    /// more time I think and doesn't save on the overall footprint
    /// so it's not worth the complexity.</p>
    internal final var sharedContextCache: PredictionContextCache?

    //static; {
    //ERROR = DFAState(ATNConfigSet());
    // ERROR.stateNumber = Integer.MAX_VALUE;
    //}

    public init(_ atn: ATN,
                _ sharedContextCache: PredictionContextCache) {

        self.atn = atn
        self.sharedContextCache = sharedContextCache
    }

    open func reset() {
        RuntimeException(" must overriden ")
    }

    /// Clear the DFA cache used by the current instance. Since the DFA cache may
    /// be shared by multiple ATN simulators, this method may affect the
    /// performance (but not accuracy) of other parsers which are being used
    /// concurrently.
    ///
    /// -  UnsupportedOperationException if the current instance does not
    /// support clearing the DFA.
    ///
    /// -  4.3
    open func clearDFA() throws {
        throw ANTLRError.unsupportedOperation(msg: "This ATN simulator does not support clearing the DFA. ")
    }

    open func getSharedContextCache() -> PredictionContextCache? {
        return sharedContextCache
    }

    open func getCachedContext(_ context: PredictionContext) -> PredictionContext {
        if sharedContextCache == nil {
            return context
        }

        //TODO: synced (sharedContextCache!)
        //synced (sharedContextCache!) {
        let visited: HashMap<PredictionContext, PredictionContext> =
        HashMap<PredictionContext, PredictionContext>()

        return PredictionContext.getCachedContext(context,
                sharedContextCache!,
                visited)
        //}
    }

    /// -  Use {@link org.antlr.v4.runtime.atn.ATNDeserializer#deserialize} instead.
    ////@Deprecated
    public static func deserialize(_ data: [Character]) throws -> ATN {
        return try ATNDeserializer().deserialize(data)
    }

    /// -  Use {@link org.antlr.v4.runtime.atn.ATNDeserializer#checkCondition(boolean)} instead.
    ////@Deprecated
    public static func checkCondition(_ condition: Bool) throws {
        try ATNDeserializer().checkCondition(condition)
    }

    /// -  Use {@link org.antlr.v4.runtime.atn.ATNDeserializer#checkCondition(boolean, String)} instead.
    ////@Deprecated
    public static func checkCondition(_ condition: Bool, _ message: String) throws {
        try ATNDeserializer().checkCondition(condition, message)
    }

    /// -  Use {@link org.antlr.v4.runtime.atn.ATNDeserializer#toInt} instead.
    ////@Deprecated
    public func toInt(_ c: Character) -> Int {
        return toInt(c)
    }

    /// -  Use {@link org.antlr.v4.runtime.atn.ATNDeserializer#toInt32} instead.
    ////@Deprecated
    public func toInt32(_ data: [Character], _ offset: Int) -> Int {
        return toInt32(data, offset)
    }

    /// -  Use {@link org.antlr.v4.runtime.atn.ATNDeserializer#toLong} instead.
    ////@Deprecated
    public func toLong(_ data: [Character], _ offset: Int) -> Int64 {
        return toLong(data, offset)
    }

    /// -  Use {@link org.antlr.v4.runtime.atn.ATNDeserializer#toUUID} instead.
    ////@Deprecated
    //public class func toUUID(data : [Character], _ offset : Int) -> NSUUID {
    //return ATNDeserializer.toUUID(data, offset);
    //}

    /// -  Use {@link org.antlr.v4.runtime.atn.ATNDeserializer#edgeFactory} instead.
    ////@Deprecated

    public static func edgeFactory(_ atn: ATN,
                                  _ type: Int, _ src: Int, _ trg: Int,
                                  _ arg1: Int, _ arg2: Int, _ arg3: Int,
                                  _ sets: Array<IntervalSet>) throws -> Transition {
        return try ATNDeserializer().edgeFactory(atn, type, src, trg, arg1, arg2, arg3, sets)
    }

    /// -  Use {@link org.antlr.v4.runtime.atn.ATNDeserializer#stateFactory} instead.
    ////@Deprecated
    public static func stateFactory(_ type: Int, _ ruleIndex: Int) throws -> ATNState {
        return try ATNDeserializer().stateFactory(type, ruleIndex)!
    }

}

"""
    
    static let sample5 =
"""
/**
 *  Noop.
 *
 *  @author hanjoes
 */
public static func noop() {
}
"""
}
