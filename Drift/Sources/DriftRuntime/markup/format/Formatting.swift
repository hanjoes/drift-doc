import Foundation

protocol Formatting: SwiftMarkupOutputModel {
    var childrenMarkups: [SwiftMarkupOutputModel] { get }
}

// MARK: CustomStringConvertible
extension Formatting {
    var description: String {
        return childrenMarkups.map { $0.description }.joined(separator: "")
    }
}