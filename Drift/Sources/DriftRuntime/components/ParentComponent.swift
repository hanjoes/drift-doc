import Foundation

protocol ParentComponent: DocComponent {
    var children: [DocComponent] { get set }
}

// MARK: - CustomStringConvertible
extension ParentComponent {
    var description: String {
        return "|:\(children.map {$0.description}.joined(separator: "")):|"
    }
}

