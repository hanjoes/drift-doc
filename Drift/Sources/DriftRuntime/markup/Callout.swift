import Foundation

protocol Callout: Named {
    var content: String { get }
}

// MARK: Named
extension Callout {
    var name: String {
        return String(describing: type(of: self))
    }
}
