import Foundation

struct InlineTag: TagComponent {
    var name: String
    
    var children = [DocComponent]()
    
    var description: String {
        return "|:{@\(name)\(children.map{$0.description}.joined(separator: "")):|"
    }
    
    init(tagName: String) {
        self.name = tagName
    }
}
