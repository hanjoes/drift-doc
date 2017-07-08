import Foundation

protocol ParentComponent: DocComponent {
    var children: [DocComponent] { get }
}
