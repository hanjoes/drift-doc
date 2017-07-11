import Foundation

struct HTMLElement: DocComponent {
    var content: String
    
    var parentComponent: ParentComponent?
    
    var description: String {
        return "|:\(content):|"
    }
    
    init(content: String) {
        self.content = content
    }
}
