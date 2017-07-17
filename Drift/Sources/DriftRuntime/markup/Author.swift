import Foundation

struct Author: Callout {
    var authorName: String
}

extension Author {
    var description: String {
        return "- Author:\(authorName)"
    }
}
