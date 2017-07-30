import XCTest
@testable import DriftRuntime

class TestMarkupConversion: XCTestCase {
    
    /// ------------------------------------------------
    func testMarkupConversionParameter() throws {
        let file =
"""
/**
 *  Noop.
 *
 *  @param param some parameter.
 */
public static func noop(param: Int) {
}
"""
        let expected =
"""
/// 
/// Noop.
/// 
/// - Parameter param: some parameter.
/// 
public static func noop(param: Int) {
}
"""
        let actual = try DriftConverter.rewrite(content: file)
        XCTAssertEqual(expected, actual)
    }
    
    /// ------------------------------------------------
    func testMarkupConversionReturns() throws {
        let file =
"""
/**
 *  Noop.
 *
 *  @return returning nothing.
 */
public static func noop(param: Int) -> Void {
}
"""
        let expected =
"""
/// 
/// Noop.
/// 
/// - Returns: returning nothing.
/// 
public static func noop(param: Int) -> Void {
}
"""
        let actual = try DriftConverter.rewrite(content: file)
        XCTAssertEqual(expected, actual)
    }
        
    /// ------------------------------------------------
    func testMarkupConversionThrows() throws {
        let file =
"""
/**
 *  Noop.
 *
 *  @throws some exception
 */
public static func noop(param: Int) throws -> Void {
}
"""
        let expected =
"""
/// 
/// Noop.
/// 
/// - Throws: some exception
/// 
public static func noop(param: Int) throws -> Void {
}
"""
        let actual = try DriftConverter.rewrite(content: file)
        XCTAssertEqual(expected, actual)
    }
    
    /// ------------------------------------------------
    func testMarkupMixedSections() throws {
        let file =
"""
/**
 *  Noop.
 *
 *  @return void
 *  @exception some exception
 *  @param param dorky parameter
 *  @param param dorky parameter brother
 *  @throws exception2
 */
public static func noop(param: Int) throws -> Void {
}
"""
        let expected =
"""
/// 
/// Noop.
/// 
/// - Parameter param: dorky parameter
/// - Parameter param: dorky parameter brother
/// - Throws: some exception
/// - Throws: exception2
/// - Returns: void
/// 
public static func noop(param: Int) throws -> Void {
}
"""
        let actual = try DriftConverter.rewrite(content: file)
        XCTAssertEqual(expected, actual)
    }
    
    /// ------------------------------------------------
    func testMarkupAuthorAndParameter() throws {
        let file =
"""
/**
 *  Noop.
 *
 *  @return void
 *  @throws some exception
 *  @author hanjoes
 *  @param param dorky parameter
 *  @param param dorky parameter brother
 *  @throws exception2
 */
public static func noop(param: Int) throws -> Void {
}
"""
        let expected =
"""
/// 
/// Noop.
/// 
/// - Author: hanjoes
/// - Parameter param: dorky parameter
/// - Parameter param: dorky parameter brother
/// - Throws: some exception
/// - Throws: exception2
/// - Returns: void
/// 
public static func noop(param: Int) throws -> Void {
}
"""
        let actual = try DriftConverter.rewrite(content: file)
        XCTAssertEqual(expected, actual)
    }
    
    /// ------------------------------------------------
    func testMixedInlineAndDedicatedCallouts() throws {
        let file =
"""
/**
 *  Noop.
 *  Comment line1.
 *
 *
 *  @version 3.14159
 *  @return void
 *  @throws some exception
 *  @author hanjoes
 *  @param param dorky parameter {@link ParameterType#type}
 *  @param param dorky parameter brother
 *  @since epoch
 *  @throws exception2
 *  @see some other code
 */
public static func noop(param: Int) throws -> Void {
}
"""
        let expected =
"""
/// 
/// Noop.
/// Comment line1.
/// 
/// 
/// - Version: 3.14159
/// - Author: hanjoes
/// - Since: epoch
/// - SeeAlso: some other code
/// - Parameter param: dorky parameter _ParameterType#type_
/// - Parameter param: dorky parameter brother
/// - Throws: some exception
/// - Throws: exception2
/// - Returns: void
/// 
public static func noop(param: Int) throws -> Void {
}
"""
        let actual = try DriftConverter.rewrite(content: file)
        XCTAssertEqual(expected, actual)
    }
    
    /// ------------------------------------------------
    func testMixedCalloutsWithCodeVoiceEmbedded() throws {
        let file =
"""
/**
 *  Noop.
 *  Comment line1. {@code some code} is working!
 *
 *
 *  @version 3.14159
 *  @serial "json" encoded
 *  @deprecated this API should not be used 
 *  @return void
 *  @throws some exception {@code TestException} should {@literal never be thrown.}
 *  @author hanjoes
 */
public static func noop(param: Int) throws -> Void {
}
"""
        let expected =
"""
/// 
/// Noop.
/// Comment line1. `some code` is working!
/// 
/// 
/// - Version: 3.14159
/// "json" encoded
/// this API should not be used
/// - Author: hanjoes
/// - Throws: some exception `TestException` should `never be thrown.`
/// - Returns: void
/// 
public static func noop(param: Int) throws -> Void {
}
"""
        let actual = try DriftConverter.rewrite(content: file)
        XCTAssertEqual(expected, actual)
    }
    
    /// ------------------------------------------------
    func testMoreThanOneCommentBlock() throws {
        let file =
"""
/**
 *  Noop.
 *  Comment line1. {@code some code} is working!
 *
 *
 *  @version 3.14159
 *  @serial "json" encoded
 *  @deprecated this API should not be used
 *  @return void
 *  @throws some exception {@code TestException} should {@literal never be thrown.}
 *  @author hanjoes
 */
public static func noop(param: Int) throws -> Void {
}
/**
 *  Noop.
 *
 *  @return void
 *  @throws some exception
 *  @author hanjoes
 *  @param param dorky parameter
 *  @param param dorky parameter brother
 *  @throws exception2
 */
public static func noop(param: Int) throws -> Void {
}
"""
        let expected =
"""
/// 
/// Noop.
/// Comment line1. `some code` is working!
/// 
/// 
/// - Version: 3.14159
/// "json" encoded
/// this API should not be used
/// - Author: hanjoes
/// - Throws: some exception `TestException` should `never be thrown.`
/// - Returns: void
/// 
public static func noop(param: Int) throws -> Void {
}
/// 
/// Noop.
/// 
/// - Author: hanjoes
/// - Parameter param: dorky parameter
/// - Parameter param: dorky parameter brother
/// - Throws: some exception
/// - Throws: exception2
/// - Returns: void
/// 
public static func noop(param: Int) throws -> Void {
}
"""
        let actual = try DriftConverter.rewrite(content: file)
        XCTAssertEqual(expected, actual)
    }
    
    func testOneLineJavadoc() throws {
        let file =
"""
    /** The type of a {@link org.antlr.v4.runtime.atn.LexerSkipAction} action. */
"""
        let expected =
        """
    /// The type of a _org.antlr.v4.runtime.atn.LexerSkipAction_ action.
"""
        let actual = try DriftConverter.rewrite(content: file)
        XCTAssertEqual(expected, actual)
    }
    
    func testIndentedJavadoc() throws {
        let file =
"""
    /**
     * The type of a {@link org.antlr.v4.runtime.atn.LexerSkipAction} action.
     */
"""
        let expected =
"""
    /// 
    /// The type of a _org.antlr.v4.runtime.atn.LexerSkipAction_ action.
    /// 
"""
        let actual = try DriftConverter.rewrite(content: file)
        XCTAssertEqual(expected, actual)
    }

     func testCanProcessTrippleSlash() throws {
         let file =
 """
     /// This UUID indicates an extension of {@link #ADDED_PRECEDENCE_TRANSITIONS}
     /// for the addition of lexer actions encoded as a sequence of
     /// {@link org.antlr.v4.runtime.atn.LexerAction} instances.
     private static let ADDED_LEXER_ACTIONS: UUID = UUID(uuidString: "AADB8D7E-AEEF-4415-AD2B-8204D6CF042E")!

     /**
     * This list contains all of the currently supported UUIDs, ordered by when
     * the feature first appeared in this branch.
     */
     private static let SUPPORTED_UUIDS: Array<UUID> = {
         var suuid = Array<UUID>()
         suuid.append(ATNDeserializer.BASE_SERIALIZED_UUID)
         suuid.append(ATNDeserializer.ADDED_PRECEDENCE_TRANSITIONS)
         suuid.append(ATNDeserializer.ADDED_LEXER_ACTIONS)
         suuid.append(ATNDeserializer.ADDED_UNICODE_SMP)
         return suuid

     }()

     /// Determines if a particular serialized representation of an ATN supports
     /// a particular feature, identified by the {@link java.util.UUID} used for serializing
     /// the ATN at the time the feature was first introduced.
     ///
     /// - parameter feature: The {@link java.util.UUID} marking the first time the feature was
     /// supported in the serialized ATN.
     /// - parameter actualUuid: The {@link java.util.UUID} of the actual serialized ATN which is
     /// currently being deserialized.
     /// - returns: {@code true} if the {@code actualUuid} value represents a
     /// serialized ATN at or after the feature identified by {@code feature} was
     /// introduced; otherwise, {@code false}.
     internal func isFeatureSupported(_ feature: UUID, _ actualUuid: UUID) -> Bool {
         let featureIndex: Int = ATNDeserializer.SUPPORTED_UUIDS.index(of: feature)!
         if featureIndex < 0 {
             return false
         }

         return ATNDeserializer.SUPPORTED_UUIDS.index(of: actualUuid)! >= featureIndex
     }
 """
         let expected =
 """
     /// 
     /// This UUID indicates an extension of _#ADDED_PRECEDENCE_TRANSITIONS_
     /// for the addition of lexer actions encoded as a sequence of
     /// _org.antlr.v4.runtime.atn.LexerAction_ instances.
     /// 
     private static let ADDED_LEXER_ACTIONS: UUID = UUID(uuidString: "AADB8D7E-AEEF-4415-AD2B-8204D6CF042E")!

     /// 
     /// This list contains all of the currently supported UUIDs, ordered by when
     /// the feature first appeared in this branch.
     /// 
     private static let SUPPORTED_UUIDS: Array<UUID> = {
         var suuid = Array<UUID>()
         suuid.append(ATNDeserializer.BASE_SERIALIZED_UUID)
         suuid.append(ATNDeserializer.ADDED_PRECEDENCE_TRANSITIONS)
         suuid.append(ATNDeserializer.ADDED_LEXER_ACTIONS)
         suuid.append(ATNDeserializer.ADDED_UNICODE_SMP)
         return suuid

     }()

     /// 
     /// Determines if a particular serialized representation of an ATN supports
     /// a particular feature, identified by the _java.util.UUID_ used for serializing
     /// the ATN at the time the feature was first introduced.
     /// 
     /// - parameter feature: The _java.util.UUID_ marking the first time the feature was
     /// supported in the serialized ATN.
     /// - parameter actualUuid: The _java.util.UUID_ of the actual serialized ATN which is
     /// currently being deserialized.
     /// - returns: `true` if the `actualUuid` value represents a
     /// serialized ATN at or after the feature identified by `feature` was
     /// introduced; otherwise, `false`.
     /// 
     internal func isFeatureSupported(_ feature: UUID, _ actualUuid: UUID) -> Bool {
         let featureIndex: Int = ATNDeserializer.SUPPORTED_UUIDS.index(of: feature)!
         if featureIndex < 0 {
             return false
         }

         return ATNDeserializer.SUPPORTED_UUIDS.index(of: actualUuid)! >= featureIndex
     }
 """
         let actual = try DriftConverter.rewrite(content: file)
         XCTAssertEqual(expected, actual)
     }
}
