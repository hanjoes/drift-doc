import Foundation
///
/// Preprocess the file.
///
/// We need to do some preprocessing on the file so it
/// can be parsed by our grammar.
///
/// For example: The original Javadoc could use different
/// commenting style "///" for example. we need to convert
/// that to the standard Javadoc commenting style which
/// starts with "/**(*)*" and ends with "(*)**/".
///
struct Preprocess {
    
    struct CommentData {
        let file: String
        let comments: [[String.Index]]
    }
    
    static let TripleSlash = "///"
    
    /// Takes the content of the file
    ///
    /// - Parameter content: content of the file
    /// - Returns: converted string
    static func convertComment(forFile content: String) -> String {
        guard content.count >= 3 else {
            return content
        }
        
        return rewrite(with: parse(file: content))
    }
    
    static func rewrite(with commentData: CommentData) -> String {
        return ""
    }

    static func parse(file content: String) -> CommentData {
        let lines = content.components(separatedBy: "\n")
        var indexes = [[String.Index]]()
        var previousIsComment = false
        var commentBlock = [String.Index]()
        for line in lines {
            if let tripleSlashRange = line.range(of: Preprocess.TripleSlash) {
                previousIsComment = true
                commentBlock.append(tripleSlashRange.lowerBound)
            }
            else if previousIsComment {
                previousIsComment = false
                indexes.append(commentBlock)
                commentBlock = [String.Index]()
            }
        }
        return CommentData(file: content, comments: indexes)
    }
}
