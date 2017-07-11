import Foundation

protocol DocComponent: CustomStringConvertible {
    var parentComponent: ParentComponent? { get set }
}
