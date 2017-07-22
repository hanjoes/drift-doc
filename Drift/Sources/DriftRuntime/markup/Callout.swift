import Foundation

protocol Callout: Named, SwiftMarkupOutputModel {
    var childrenMarkups: [SwiftMarkupOutputModel] { get }
}

// MARK: Named
extension Callout {
    var name: String {
        return String(describing: type(of: self))
    }
}

// MARK: CustomStringConvertible
extension Callout {
    var description: String {
        return childrenMarkups.map { $0.description }.joined(separator: "")
    }
}
