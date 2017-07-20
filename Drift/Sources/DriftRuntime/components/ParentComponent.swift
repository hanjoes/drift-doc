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

extension ParentComponent {
    var markup: SwiftMarkupOutputModel {
        return Noop(content: "", children: [SwiftMarkupOutputModel](), parent: nil)
    }
}

