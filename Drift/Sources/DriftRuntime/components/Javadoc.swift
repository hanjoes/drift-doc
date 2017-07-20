import Foundation

struct Javadoc: ParentComponent {
    var children: [DocComponent] = [DocComponent]()
    
    /// Parent component of Javadoc is always nil.
    var parentComponent: ParentComponent? = nil
    
}

