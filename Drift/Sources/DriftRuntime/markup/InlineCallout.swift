import Foundation

protocol InlineCallout: Callout {
}

extension InlineCallout {
    var description: String {
        return content
    }
}
