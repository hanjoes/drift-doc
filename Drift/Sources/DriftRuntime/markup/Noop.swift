import Foundation

struct Noop: Callout, SwiftMarkupOutputModel {
    var childrenMarkups: [SwiftMarkupOutputModel]
}

extension Noop {
    var description: String {
        return ""
    }
}
