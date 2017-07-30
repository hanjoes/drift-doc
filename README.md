# Drift-doc

## Info

This package contains two parts.

- The Swift Package that offers API to convert Javadoc to Swift markup.
```
import DriftRuntime
```
- A commandline executable can convert one file or files recursively down in the folder.
```
$ ./.build/debug/DriftTransform

DriftTransform: Transforms any document that contains Javadoc to Swift documentation.

    Usage: DriftTransform <directory or file> <output directory>

    The tool will detect the type of the second argument.
    If it's a directory, we will transform all files under the directory recursively.
    If it's a file, we will transform the file.

    Note: This tool does not follow symbolic links.
```

## Feature

- It converts Java docstring following [this spec](http://www.oracle.com/technetwork/articles/java/index-137868.html). One caveat is we can only handle comment style "/** ... */".
- We have limited support for Javadoc "standard tags" (tags appears in a separate section), and "inline tags" (tags can appear in description). And we are mapping those tags to simliar markup with similar semantic in Swift markup. Supported tags: (javadoc tag -> swift markup )
```
// Standard tags:
"param" -> Parameter
"return" -> Returns
"throws" -> Throws
"exception" -> Throws
"see" -> SeeAlso
"author" -> Author
"since" -> Since
"version" -> Version

// Inline tags:
"code" -> CodeVoice
"literal" -> CodeVoice
"link" -> Italic
 ```
 - HTML tags are ignored. But may be added in the future.

 ## Sample output
 
 __Javadoc__
 ```
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
 ```

__Swift Markup__
 ```
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
 ```

 This allows us to display swift markup in Xcode Quick Help.

