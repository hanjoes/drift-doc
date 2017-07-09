import Foundation

protocol MergingComponent: DocComponent {
    associatedtype DataType
    var data: DataType { get set }
    func merged<T: MergingComponent>(with component: T) -> Self where T.DataType == Self.DataType
}
