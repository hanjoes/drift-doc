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
            let childMarkup = $0.markup
            if childMarkup is Parameter {
                resultModel.parameterSection.append(childMarkup)
            }
            else if childMarkup is SwiftMarkupDescription {
                resultModel.descriptionSection.append(childMarkup)
            }
        }
        return resultModel
    }
}

