import Foundation

enum SwiftMarkupDescription {
    case text(String)
    case callout(InlineCallout)
}

// MARK: SwiftMarkupOutputModel
extension SwiftMarkupDescription: SwiftMarkupOutputModel {
    var description: String {
        switch self {
        case .text(let str):
            return str
        case .callout(let callout):
            return "\(callout)"
        }
    }
}
