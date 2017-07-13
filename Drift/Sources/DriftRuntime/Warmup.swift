import Foundation
///
/// Warming up the file.
///
/// We need to do some preprocessing on the file so it
/// can be parsed by our grammar.
///
/// For example: The original Javadoc could use different
/// commenting style "///" for example. we need to convert
/// that to the standard Javadoc commenting style which
/// starts with "/**(*)*" and ends with "(*)**/".
///
struct Warmup {
    
    /// Takes the content of the file
    ///
    /// - Parameter content: content of the file
    /// - Returns: converted string
    static func standardizeCommentStyle(forFile content: String) -> String {
        return ""
    }
}
