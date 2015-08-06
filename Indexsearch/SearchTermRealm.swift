//
//  SearchTerms.swift
//  Indexsearch
//
//  Created by Aaron Wasserman on 7/22/15.
//  Copyright (c) 2015 Aaron Wasserman. All rights reserved.
//

import UIKit
import RealmSwift

class SearchTermRealm: Object {
    dynamic var text: NSString = ""
    dynamic var dateModified = NSDate()
}
