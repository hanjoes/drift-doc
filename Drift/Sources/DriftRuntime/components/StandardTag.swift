import Foundation

struct StandardTag: TagComponent {
    var name: String
    
    var children = [DocComponent]()
    
    var description: String {
        return ""
    }
    
    init(tagName: String) {
        self.name = tagName
    }
}
