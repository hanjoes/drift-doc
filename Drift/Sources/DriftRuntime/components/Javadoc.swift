import Foundation

struct Javadoc: ParentComponent {
    var children: [DocComponent] = [DocComponent]()
    
    /// Parent component of Javadoc is always nil.
    var parentComponent: ParentComponent? = nil
    
}

// MARK: SwiftMarkupConvertible
extension Javadoc {
    var markup: String {
        return childrenMarkup
    }
}

