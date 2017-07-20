import Foundation

struct Noop: Callout, SwiftMarkupOutputModel {
    var content: String
    var children: [SwiftMarkupOutputModel]
    var parent: SwiftMarkupOutputModel?
}
