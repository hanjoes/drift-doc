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

extension InlineTag {
    var childrenMarkups: [SwiftMarkupOutputModel] {
        return children.map {
            $0.markup
        }
    }

    var markup: SwiftMarkupOutputModel {
        switch name {
        case "code":
            return CodeVoice(childrenMarkups: childrenMarkups)
        default:
            return SwiftMarkupDescription.text(children.map{$0.description}.joined(separator: ""))
        }
    }
}
//
//// MARK: SwiftMarkupConvertible
//extension InlineTag {
//    /// Available Javadoc tags.
//    ///
//    /// +--------------+-------------+
//    /// |{@code}       | 1.5         |
//    /// |{@docRoot}    | 1.3         |
//    /// |{@inheritDoc} | 1.4         |
//    /// |{@link}       | 1.2         |
//    /// |{@linkplain}  | 1.4         |
//    /// |{@literal}    | 1.5         |
//    /// |{@value}      | 1.4         |
//    /// +--------------+-------------+
//    ///
//    func injected(to markup: SwiftMarkupOutput) -> SwiftMarkupOutput {
//        var callout: Callout
//        switch name {
//        case "code":
//            break
//        case "docRoot":
//            break
//        case "inheritDoc":
//            break
//        case "link":
//            break
//        case "linkplain":
//            break
//        case "literal":
//            break
//        case "value":
//            break
//        default:
//            break
//        }
//        return markup
//    }
//}

