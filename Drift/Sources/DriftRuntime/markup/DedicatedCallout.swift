import Foundation

protocol DedicatedCallout: Callout {
}

extension DedicatedCallout {
    var description: String {
        return "- \(name):\(content)"
    }
}
