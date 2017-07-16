//
//  Author.swift
//  DriftRuntime
//
//  Created by Hanzhou Shi on 7/16/17.
//

import Foundation

struct Author: Callout {
    var authorName: String
}

extension Author {
    var description: String {
        return "- Author:\(authorName)"
    }
}
