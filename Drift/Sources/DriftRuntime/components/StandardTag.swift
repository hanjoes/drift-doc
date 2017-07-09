import Foundation

struct StandardTag: TagComponent {
    var name: String
    var children = [DocComponent]()
    
    init(tagName: String) {
        self.name = tagName
    }
}
