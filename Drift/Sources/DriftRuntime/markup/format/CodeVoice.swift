import Foundation

struct CodeVoice: InlineCallout {
    var childrenMarkups: [SwiftMarkupOutputModel]
}


extension CodeVoice {
    var description: String {
        let childrenMarkupDescription = childrenMarkups.map {$0.description}.joined(separator: "")
        let trimmedChildrenMarkupDesc = childrenMarkupDescription.trimmingCharacters(in: CharacterSet.whitespaces)
        return "`\(trimmedChildrenMarkupDesc)`"
    }
}
