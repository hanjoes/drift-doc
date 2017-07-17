import Foundation

struct StandardTag: TagComponent {
    var name: String
    
    var children = [DocComponent]()
    
    var parentComponent: ParentComponent?
    
    init(tagName: String) {
        self.name = tagName
    }
}

// MARK: CustomStringConvertible
extension StandardTag {
    var description: String {
        return "|:@\(name)\(children.map{$0.description}.joined(separator: "")):|"
    }
}

// MARK: SwiftMarkupConvertible
extension StandardTag {
    /// Available Javadoc tags.
    ///
    /// +--------------+-------------+
    /// |@author       | 1.0         |
    /// |@deprecated   | 1.0         |
    /// |@exception    | 1.0         |
    /// |@param        | 1.0         |
    /// |@return       | 1.0         |
    /// |@see          | 1.0         |
    /// |@serial       | 1.2         |
    /// |@serialData   | 1.2         |
    /// |@serialField  | 1.2         |
    /// |@since        | 1.1         |
    /// |@throws       | 1.2         |
    /// |@version      | 1.0         |
    /// +--------------+-------------+
    ///
    var markup: String {
        var swiftMarkup: SwiftMarkup
        switch name {
        case "author":
            swiftMarkup = Author(authorName: childrenMarkup)
//        case "deprecated":
//            break
//        case "exception":
//            break
        case "param":
            swiftMarkup = Parameter(content: childrenMarkup)
//        case "return":
//            break
//        case "see":
//            break
//        case "serial":
//            break
//        case "serialData":
//            break
//        case "serialField":
//            break
//        case "since":
//            break
//        case "throws":
//            break
//        case "version":
//            break
        default:
            swiftMarkup = Noop(content: childrenMarkup)
        }
        return "\(swiftMarkup)"
    }
}
