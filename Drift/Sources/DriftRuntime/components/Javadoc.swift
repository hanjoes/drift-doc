import Foundation

struct Javadoc: ParentComponent {
    var children: [DocComponent] = [DocComponent]()
    
    /// Parent component of Javadoc is always nil.
    var parentComponent: ParentComponent? = nil
}

extension Javadoc: SwiftMarkupConvertible {
    var markup: SwiftMarkupOutputModel {
        // Traverse children and get markup.
        // Use the markup's injection method to inject into specific fields.
        return SwiftQuickHelpDocument()
    }
}

