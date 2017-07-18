import Foundation

protocol Callout: CustomStringConvertible, Named {
    var content: String { get }
}

// MARK: CustomStringConvertible
extension Callout {
    var description: String {
        return "- \(name):\(content)"
    }
}

extension Callout {
    var name: String {
        return String(describing: type(of: self))
    }
}
