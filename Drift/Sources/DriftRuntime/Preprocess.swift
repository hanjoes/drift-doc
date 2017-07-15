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
    
    typealias CommentLine = (indent: String, startIndex: String.Index)
    
    struct CommentData {
        let file: String
        let comments: [[CommentLine]]
    }
    
    static let TripleSlash = "///"
    
    /// Takes the content of the file
    ///
    /// - Parameter file: content of the file
    /// - Returns: converted file
    static func convertComment(in file: String) -> String {
        guard file.count >= 3 else {
            return file
        }
        
        return rewrite(with: parse(file: file))
    }
    
}

private extension Preprocess {
    
    /// Rewrite the file to convert all it's triple-slash comment
    /// to Javadoc-style comment.
    ///
    /// - Parameter commentData: metadata about comments
    /// - Returns: converted comment
    static func rewrite(with commentData: CommentData) -> String {
        var file = commentData.file
        for blockComment in commentData.comments {
            for commentLine in blockComment {
                let start = commentLine.startIndex
                file = file.replacingCharacters(in: start..<file.index(start, offsetBy: 3), with: " * ")
            }
        }
        // finishing comments by adding "/**" and "*/", reversely
        for blockComment in commentData.comments.reversed() {
            guard !blockComment.isEmpty else {
                continue
            }
            
            let lastLine = blockComment.last!
            let lastIndex = consumeLine(in: file, from: lastLine.startIndex)
            if lastIndex == file.endIndex {
                file.insert(contentsOf: "\n\(lastLine.indent) */", at: lastIndex)
            }
            else {
                file.insert(contentsOf: "\(lastLine.indent) */\n", at: lastIndex)
            }
            
            let firstLine = blockComment.first!
            file.insert(contentsOf: "/**\n\(firstLine.indent)", at: firstLine.startIndex)
        }
        return file
    }
    
    /// Parse the file and return data about comment blocks.
    ///
    /// - Parameter content: the content to parse
    /// - Returns: CommentData struct regarding the comments
    static func parse(file content: String) -> CommentData {
        var blockComments = [[CommentLine]]()
        var index = content.startIndex
        var commentLine = [CommentLine]()
        var isInComment = false
        while index < content.endIndex {
            var indent = ""
            (indent, index) = consumeWS(in: content, at: index)
            
            if matchTripleSlashComment(in: content, at: index) {
                commentLine.append((indent, index))
                isInComment = true
            }
            else {
                if isInComment {
                    blockComments.append(commentLine)
                }
                commentLine = [CommentLine]()
                isInComment = false
            }
            
            index = consumeLine(in: content, from: index)
        }
        
        // Add last comment in case comment is at the last
        if isInComment {
            blockComments.append(commentLine)
        }
        
        return CommentData(file: content, comments: blockComments)
    }
    
    static func consumeLine(in content: String, from index: String.Index) -> String.Index {
        var currentIndex = index
//        print("currentIndex: \(currentIndex)")
//        print("content: \(content[currentIndex])")
        while currentIndex != content.endIndex && content[currentIndex] != "\n" {
            currentIndex = content.index(after: currentIndex)
        }
//        print("after currentIndex: \(currentIndex)")
        return currentIndex != content.endIndex ? content.index(after: currentIndex) : currentIndex
    }
    
    static func consumeWS(in line: String, at index: String.Index) -> (String, String.Index) {
        var currentIndex = index
        var indent = ""
        while currentIndex != line.endIndex && isWS(line[currentIndex]) {
            indent.append((line[currentIndex]))
            currentIndex = line.index(after: currentIndex)
        }
        return (indent, currentIndex)
    }
    
    static func matchTripleSlashComment(in line: String, at index: String.Index) -> Bool {
        return line[index...].starts(with: Preprocess.TripleSlash)
    }
    
    static func isNewline(_ chr: Character) -> Bool {
        return chr == "\n" || chr == "\r"
    }
    
    static func isWS(_ chr: Character) -> Bool {
        return chr == "\t" || chr == " "
    }
}
