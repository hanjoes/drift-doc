import Foundation

struct TextComponent: MergingComponent {
    var data: String
    
    var description: String {
        return data
    }
    
    func merged<T>(with component: T) -> TextComponent where T : MergingComponent, TextComponent.DataType == T.DataType {
        return TextComponent(data: data + component.data)
    }
}
