import Foundation

public protocol DocComponent {
    var children: [DocComponent] { get }
}
