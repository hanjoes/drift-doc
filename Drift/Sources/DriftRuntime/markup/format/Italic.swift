import Foundation

struct Italic: InlineCallout {
    var childrenMarkups: [SwiftMarkupOutputModel]
}

extension Italic {
    var description: String {
        let childrenMarkupDescription = childrenMarkups.map {$0.description}.joined(separator: "")
        let trimmedChildrenMarkupDesc = childrenMarkupDescription.trimmingCharacters(in: CharacterSet.whitespaces)
        return "_\(trimmedChildrenMarkupDesc)_"
    }
}
