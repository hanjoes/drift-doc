import Foundation

struct InlineTag: TagComponent {
    var name: String
    
    var children = [DocComponent]()
    
    var parentComponent: ParentComponent?
    
    init(tagName: String) {
        self.name = tagName
    }
}

// MARK: CustomStringConvertible
extension InlineTag {
    var description: String {
        return "|:{@\(name)\(children.map{$0.description}.joined(separator: ""))}:|"
    }
}

//// MARK: SwiftMarkupConvertible
extension InlineTag {
    var childrenMarkups: [SwiftMarkupOutputModel] {
        return children.map {
            $0.markup
        }
    }

    /// Available Javadoc inline tags.
    /// only few of them are supported in this implementation.
    /// +--------------+-------------+
    /// |{@code}       | 1.5         |
    /// |{@docRoot}    | 1.3         |
    /// |{@inheritDoc} | 1.4         |
    /// |{@link}       | 1.2         |
    /// |{@linkplain}  | 1.4         |
    /// |{@literal}    | 1.5         |
    /// |{@value}      | 1.4         |
    /// +--------------+-------------+
    var markup: SwiftMarkupOutputModel {
        switch name {
        case "code": fallthrough
        case "literal":
            // FIXME: Content here should be handled as-is.
            return CodeVoice(childrenMarkups: childrenMarkups)
        case "link":
            return Italic(childrenMarkups: childrenMarkups)
        default:
            return SwiftMarkupDescription.text(children.map{$0.description}.joined(separator: ""))
        }
    }
}

