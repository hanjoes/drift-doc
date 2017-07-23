import Foundation

protocol InlineCallout: Callout {
}

// MARK: CustomStringConvertible
extension InlineCallout {
    var description: String {
        return "- \(name):\(childrenMarkups.map{$0.description}.joined(separator: ""))"
    }
}
