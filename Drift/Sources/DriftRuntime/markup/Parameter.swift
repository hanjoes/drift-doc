import Foundation

struct Parameter: Callout {
    var content: String
}

extension Parameter {
    var description: String {
        return "- Parameter:\(content)"
    }
}
