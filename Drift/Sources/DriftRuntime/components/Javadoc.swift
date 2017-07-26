import Foundation

struct Javadoc: ParentComponent {
    var children: [DocComponent] = [DocComponent]()
    
    var range: ClosedRange<Int>
    
    /// Parent component of Javadoc is always nil.
    var parentComponent: ParentComponent? = nil
    
    init(range: ClosedRange<Int>) {
        self.range = range
    }
}

extension Javadoc: SwiftMarkupConvertible {
    var markup: SwiftMarkupOutputModel {
        var resultModel = SwiftQuickHelpDocument()
        // Traverse children and get markup.
        _ = children.map {
            let childMarkup = $0.markup
            if childMarkup is Parameter {
                resultModel.parameterSection.append(childMarkup)
            }
            else if childMarkup is Returns {
                resultModel.returnsSection = childMarkup
            }
            else if childMarkup is Throws {
                resultModel.throwsSection.append(childMarkup)
            }
            else {
                resultModel.descriptionSection.append(childMarkup)
            }
        }
        return resultModel
    }
}

