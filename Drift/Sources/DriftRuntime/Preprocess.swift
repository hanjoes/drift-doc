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
    static func convertComment(inFile content: String) -> String {
        guard content.count >= 3 else {
            return content
        }
        
        return rewrite(with: parse(file: content))
    }
    
    static func rewrite(with commentData: CommentData) -> String {
        return ""
    }

    /// Parse the file and return data about comment blocks.
    ///
    /// - Parameter content: the content to parse
    /// - Returns: CommentData struct regarding the comments
    static func parse(file content: String) -> CommentData {
        var commentIndexes = [[String.Index]]()
        var index = content.startIndex
        var comments = [String.Index]()
        while index < content.endIndex {
            if index == content.startIndex || content[index] == "\n" {
                index = consumeWS(in: content, at: index)
            }
            
            if matchTripleSlashComment(in: content, at: index) {
                comments.append(index)
            }
            else {
                commentIndexes.append(comments)
                comments = [String.Index]()
            }
            
            index = consumeLine(in: content, from: index)
            
        }
        return CommentData(file: content, comments: commentIndexes)
    }
    
    
}

private extension Preprocess {
    static func consumeLine(in content: String, from index: String.Index) -> String.Index {
        var currentIndex = index
//        print("currentIndex: \(currentIndex)")
//        print("content: \(content[currentIndex])")
        while currentIndex != content.endIndex && content[currentIndex] != "\n" {
            currentIndex = content.index(after: currentIndex)
        }
//        print("after currentIndex: \(currentIndex)")
        return currentIndex
    }
    
    static func consumeWS(in line: String, at index: String.Index) -> String.Index {
        var currentIndex = index
        while currentIndex != line.endIndex && isWS(line[currentIndex]) {
            currentIndex = line.index(after: currentIndex)
        }
        return currentIndex
    }
    
    static func matchTripleSlashComment(in line: String, at index: String.Index) -> Bool {
        return line[index...].starts(with: Preprocess.TripleSlash)
    }
    
    static func isWS(_ chr: Character) -> Bool {
        return chr == "\t" || chr == " " || chr == "\n"
    }
}
