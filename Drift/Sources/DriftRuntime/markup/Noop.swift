import Foundation

struct Noop: Callout {
    var content: String
}

extension Noop {
    var description: String {
        return content
    }
}
