import Foundation

protocol ParentComponent: DocComponent {
    var children: [DocComponent] { get set }
}

extension ParentComponent {
    var description: String {
        return "|:\(children.map {$0.description}.joined(separator: "")):|"
    }
}
