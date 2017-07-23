//
//  SwiftQuickHelpDocument.swift
//  DriftRuntime
//
//  Created by Hanzhou Shi on 7/19/17.
//

import Foundation

struct SwiftQuickHelpDocument: SwiftMarkupOutputModel {
    /// Description.
    var descriptionSection = [SwiftMarkupOutputModel]()
    
    /// A series of parameters to put in parameter section.
    var parameterSection = [SwiftMarkupOutputModel]()
    
    /// A series of throws callouts.
    var throwsSection = [SwiftMarkupOutputModel]()
    
    /// There should be only one returns callout, if any.
    var returnsSection: SwiftMarkupOutputModel?
}

extension SwiftQuickHelpDocument {
    var description: String {
        var results = [String]()
        results.append("\(descriptionSection.map { $0.description }.joined(separator: ""))")
        results.append("\(parameterSection.map { $0.description }.joined(separator: ""))")
        results.append("\(throwsSection.map { $0.description }.joined(separator: ""))")
        if let returnsSection = self.returnsSection {
            results.append("\(returnsSection.description)")
        }
        return results.map {
            pruned(description: $0)
        }.joined(separator: "")
    }
}

private extension SwiftQuickHelpDocument {
    func pruned(description: String) -> String {
        // further prune, get rid of extra spaces at the end of the last line
        var lines = description.split(separator: "\n", maxSplits: Int.max, omittingEmptySubsequences: false).map{
            String($0)
        }
        var lineIndex = lines.startIndex
        while lineIndex != lines.endIndex {
            let currentLine = lines[lineIndex]
            if !currentLine.isEmpty {
                lines[lineIndex] = currentLine.trimmingCharacters(in: CharacterSet.whitespaces)
            }
            lineIndex = lines.index(after: lineIndex)
        }
        return lines.joined(separator: "\n")
    }
}

