import Foundation

struct Text: MergingComponent {
    var data: String
    
    var parentComponent: ParentComponent?
    
    init(data: String) {
        self.data = data
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
        return Noop(content: "", children: [SwiftMarkupOutputModel](), parent: nil)
    }
}

