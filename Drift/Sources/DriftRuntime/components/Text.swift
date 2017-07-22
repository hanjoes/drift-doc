import Foundation

struct Text: MergingComponent {
    var data: String
    
    var parentComponent: ParentComponent?
    
    init(data: String) {
        self.data = data
        // pruning leading asterisks
        // FIXME: how about multiply?
        self.data = self.data.replacingOccurrences(of: "\n *", with: "\n")
    }
    
    func merged<T: MergingComponent>(with component: T) -> Text where Text.DataType == T.DataType {
        return Text(data: data + component.data)
    }
}

// MARK: CustomStringConvertible
extension Text {
    var description: String {
        return "|:\(data):|"
    }
}

extension Text {
    var markup: SwiftMarkupOutputModel {
        return SwiftMarkupDescription.text(data)
    }
}

