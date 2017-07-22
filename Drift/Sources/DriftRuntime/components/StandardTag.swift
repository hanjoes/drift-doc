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
    
    var markup: SwiftMarkupOutputModel {
        switch name {
        case "param":
            print("is parameter")
            return Parameter(childrenMarkups: children.map{$0.markup})
        default:
            return SwiftMarkupDescription.text(children.map{$0.markup.description}.joined(separator: ""))
        }
    //        var callout: Callout
    //        switch name {
    //        case "author":
    //            callout = Author(content: childrenMarkup)
    //        case "deprecated":
    //            break
    //        case "exception":
    //            break
    //        case "param":
    //            callout = Parameter(content: childrenMarkup)
    //        case "return":
    //            callout = Returns(content: childrenMarkup)
    //        case "see":
    //            break
    //        case "serial":
    //            break
    //        case "serialData":
    //            break
    //        case "serialField":
    //            break
    //        case "since":
    //            callout = Since(content: childrenMarkup)
    //        case "throws":
    //            callout = Throws(content: childrenMarkup)
    //        case "version":
    //            callout = Version(content: childrenMarkup)
    //        default:
    //            callout = Noop(content: childrenMarkup)
    //        }
    //        return "\(callout)"
    }
}


// MARK: SwiftMarkupConvertible
//extension StandardTag {
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
//    var markup: String {
//        var callout: Callout
//        switch name {
//        case "author":
//            callout = Author(content: childrenMarkup)
//        case "deprecated":
//            break
//        case "exception":
//            break
//        case "param":
//            callout = Parameter(content: childrenMarkup)
//        case "return":
//            callout = Returns(content: childrenMarkup)
//        case "see":
//            break
//        case "serial":
//            break
//        case "serialData":
//            break
//        case "serialField":
//            break
//        case "since":
//            callout = Since(content: childrenMarkup)
//        case "throws":
//            callout = Throws(content: childrenMarkup)
//        case "version":
//            callout = Version(content: childrenMarkup)
//        default:
//            callout = Noop(content: childrenMarkup)
//        }
//        return "\(callout)"
//    }
//}

