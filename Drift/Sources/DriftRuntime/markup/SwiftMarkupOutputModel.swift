import Foundation

protocol SwiftMarkupOutputModel {
    var children: [SwiftMarkupOutputModel] { get set }
    var parent: SwiftMarkupOutputModel? { get set }
}
