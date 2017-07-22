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
        let descriptionSectionOutput = "\(descriptionSection.map { $0.description }.joined(separator: ""))"
        let parameterSectionOutput = "\(parameterSection.map { $0.description }.joined(separator: ""))"
        let throwsSectionOutput = "\(throwsSection.map { $0.description }.joined(separator: ""))"
//        let returnsSectionOutput = "\(returnsSection.map { $0.description }.joined(separator: ""))"
        
        return "\(descriptionSectionOutput)\(parameterSectionOutput)\(throwsSectionOutput)"
    }
}

