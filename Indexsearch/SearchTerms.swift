//
//  SearchTerms.swift
//  Indexsearch
//
//  Created by Aaron Wasserman on 7/22/15.
//  Copyright (c) 2015 Aaron Wasserman. All rights reserved.
//

import UIKit
import RealmSwift

class SearchTerms: Object {
    dynamic var searchTerm: String = ""
    //dynamic var existingTerm: String = ""
    dynamic var alphabetOrder: NSString = ""
}
