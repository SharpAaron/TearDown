//
//  SearchTerm.swift
//  Indexsearch
//
//  Created by Aaron Wasserman on 7/31/15.
//  Copyright (c) 2015 Aaron Wasserman. All rights reserved.
//

import Foundation

class SearchTerm: NSObject {
    var text: String
    var dateModified: NSDate
    
    init(text: String, dateModified: NSDate) {
        self.text = text
        self.dateModified = dateModified
    }
}

