import Foundation

struct Parameter: DedicatedCallout {
    var childrenMarkups: [SwiftMarkupOutputModel]
}

// MARK: CustomStringConvertible
extension Parameter {
    var description: String {
        let childrenDescription = childrenMarkups.map {
            $0.description
        }.joined(separator: "").trimmingCharacters(in: CharacterSet.whitespaces)
        let words = childrenDescription.split(separator: " ", maxSplits: Int.max, omittingEmptySubsequences: false)
        let paramName = String(words.first ?? "")
        return "- \(name) \(paramName): \(String(words.dropFirst().joined(separator: " ")))"
    }
}
