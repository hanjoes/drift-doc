import Foundation

protocol DedicatedCallout: Callout {
}

// MARK: CustomStringConvertible
extension DedicatedCallout {
    var description: String {
        return "- \(name):\(childrenMarkups.map{$0.description}.joined(separator: ""))"
    }
}
