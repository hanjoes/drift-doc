import Foundation

struct Text: MergingComponent {
    var data: String
    
    var description: String {
        return data
    }
    
    func merged<T>(with component: T) -> Text where T : MergingComponent, Text.DataType == T.DataType {
        return Text(data: data + component.data)
    }
}
