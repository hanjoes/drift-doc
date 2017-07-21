import Foundation

struct Noop: Callout, SwiftMarkupOutputModel {
    var content: String
}

extension Noop {
    var description: String {
        return content
    }
}
