import Foundation

struct Text: MergingComponent {
    var data: String
    
    var parentComponent: ParentComponent?
    
    var description: String {
        return "|:\(data):|"
    }
    
    init(data: String) {
        self.data = data
    }
    
    func merged<T>(with component: T) -> Text where T : MergingComponent, Text.DataType == T.DataType {
        return Text(data: data + component.data)
    }
}
