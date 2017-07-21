//
//  SwiftQuickHelpDocument.swift
//  DriftRuntime
//
//  Created by Hanzhou Shi on 7/19/17.
//

import Foundation

struct SwiftQuickHelpDocument: SwiftMarkupOutputModel {
    /// Description.
    var descriptionSection = [SwiftMarkupDescription]()
    
    /// A series of parameters to put in parameter section.
    var parameterSection = [Parameter]()
    
    /// A series of throws callouts.
    var throwsSection = [Throws]()
    
    /// There should be only one returns callout, if any.
    var returnsSection: Returns?
}

extension SwiftQuickHelpDocument {
    var description: String {
        return ""
    }
}

