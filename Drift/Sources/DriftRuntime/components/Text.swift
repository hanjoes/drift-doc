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

// MARK: - Helper methods
private extension Text {
    var prunedData: String {
        // FIXME: what if leading asterisk has semantic (e.g. multiply)?
        let lines = self.data.split(separator: "\n", maxSplits: Int.max, omittingEmptySubsequences: false)
        let prunedLines: [String] = lines.map {
            var index = $0.startIndex
            while index < $0.endIndex {
                if $0[index] == " " || $0[index] == "\t" {
                    index = $0.index(after: index)
                }
                else if $0[index] == "*" {
                    return String($0.suffix(from: $0.index(after: index)))
                }
                else {
                    return String($0)
                }
            }
            return String($0)
        }
        return prunedLines.joined(separator: "\n")
    }
}

// MARK: CustomStringConvertible
extension Text {
    var description: String {
        return "|:\( prunedData):|"
    }
}

// MARK: SwiftMarkupConvertible
extension Text {
    var markup: SwiftMarkupOutputModel {
        return SwiftMarkupDescription.text(prunedData)
    }
}

