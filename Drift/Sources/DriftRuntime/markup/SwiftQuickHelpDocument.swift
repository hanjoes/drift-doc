//
//  SwiftQuickHelpDocument.swift
//  DriftRuntime
//
//  Created by Hanzhou Shi on 7/19/17.
//

import Foundation

struct SwiftQuickHelpDocument: SwiftMarkupOutputModel {
    /// Description.
    var descriptionSection: [SwiftMarkupDescription]
    
    /// A series of parameters to put in parameter section.
    var parameterSection: [Parameter]
    
    /// There should be only one throws callout.
    var throwsSection: Throws
    
    /// There should be only one returns callout.
    var returnsSection: Returns
    
    var children: [SwiftMarkupOutputModel]
    
    var parent: SwiftMarkupOutputModel?
}
