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


extension StandardTag {
    var childrenMarkups: [SwiftMarkupOutputModel] {
        return children.map {
            $0.markup
        }
    }
    
    /// Available Javadoc tags.
    /// Although we don't use all of them.
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
    var markup: SwiftMarkupOutputModel {
        switch name {
        case "param":
            return Parameter(childrenMarkups: childrenMarkups)
        case "return":
            return Returns(childrenMarkups: childrenMarkups)
        case "throws": fallthrough
        case "exception":
            return Throws(childrenMarkups: childrenMarkups)
        case "see":
            return SeeAlso(childrenMarkups: childrenMarkups)
        case "author":
            return SwiftMarkupDescription.callout(Author(childrenMarkups: childrenMarkups))
        case "since":
            return SwiftMarkupDescription.callout(Since(childrenMarkups: childrenMarkups))
        case "version":
            return SwiftMarkupDescription.callout(Version(childrenMarkups: childrenMarkups))
        default:
            return SwiftMarkupDescription.text(children.map{$0.markup.description}.joined(separator: ""))
        }
    //        case "deprecated":
    //            break
    //        case "see":
    }
}

