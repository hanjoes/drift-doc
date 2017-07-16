import Foundation

/// Something can be converted to a Swift markup object.
protocol SwiftMarkupConvertible {
    var markup: String { get }
}
