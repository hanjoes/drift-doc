import Foundation

struct HTMLElement: DocComponent {
    
    var content: String
    
    var parentComponent: ParentComponent?
    
    init(content: String) {
        self.content = content
    }
}

// MARK: CustomStringConvertible
extension HTMLElement {
    var description: String {
        return "|:\(content):|"
    }
}

// MARK: SwiftMarkupConvertible
extension HTMLElement {
    var markup: SwiftMarkupOutputModel {
        return Noop(content: "", children: [SwiftMarkupOutputModel](), parent: nil)
    }
}
