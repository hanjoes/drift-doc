import Foundation

protocol ParentComponent: DocComponent {
    var children: [DocComponent] { get set }
    var childrenMarkup: String { get }
}

extension ParentComponent {
    var childrenMarkup: String {
        return children.map {$0.markup}.joined(separator: "")
    }
}

// MARK: - CustomStringConvertible
extension ParentComponent {
    var description: String {
        return "|:\(children.map {$0.description}.joined(separator: "")):|"
    }
}
