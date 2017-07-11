import Foundation

struct StandardTag: TagComponent {
    var name: String
    
    var children = [DocComponent]()
    
    var parentComponent: ParentComponent?
    
    var description: String {
        return "|:@\(name)\(children.map{$0.description}.joined(separator: "")):|"
    }
    
    init(tagName: String) {
        self.name = tagName
    }
}
