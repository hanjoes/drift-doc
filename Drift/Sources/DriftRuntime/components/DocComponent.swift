import Foundation

protocol DocComponent: CustomStringConvertible, SwiftMarkupConvertible {
    var parentComponent: ParentComponent? { get set }
}
