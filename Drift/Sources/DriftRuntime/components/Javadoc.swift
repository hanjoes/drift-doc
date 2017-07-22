import Foundation

struct Javadoc: ParentComponent {
    var children: [DocComponent] = [DocComponent]()
    
    /// Parent component of Javadoc is always nil.
    var parentComponent: ParentComponent? = nil
}

extension Javadoc: SwiftMarkupConvertible {
    var markup: SwiftMarkupOutputModel {
        var resultModel = SwiftQuickHelpDocument()
        // Traverse children and get markup.
        // TODO: What is the direct child of JAVADOC?
        _ = children.map {
            if $0 is Parameter {
                resultModel.parameterSection.append($0.markup)
            }
            else if $0 is SwiftMarkupDescription {
                resultModel.descriptionSection.append($0.markup)
            }
        }
        return resultModel
    }
}

