import Foundation

public struct InlineTag: TagComponent {
    var name: String
    var children = [DocComponent]()
    
    init(tagName: String) {
        self.name = tagName
    }
}
