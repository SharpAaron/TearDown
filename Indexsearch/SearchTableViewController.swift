//
//  SearchTableViewController.swift
//  Indexsearch
//
//  Created by Aaron Wasserman on 7/27/15.
//  Copyright (c) 2015 Aaron Wasserman. All rights reserved.
//

import UIKit
import RealmSwift

class SearchTableViewController: UITableViewController, UITableViewDataSource {
    
    
    var searchResultsArray: [SearchTerm]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultsArray?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("something", forIndexPath: indexPath) as! UITableViewCell
        var returnedSearchObjects = searchResultsArray[indexPath.row] as SearchTerm
        cell.textLabel?.text = returnedSearchObjects.text
//        cell.detailTextLabel?.text = NSDate<--  grab date here
        
        return cell
    }
    
//    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        var searchText = searchController.searchBar.text
//        searchResultsArray.removeAll(keepCapacity: true)
//        // create new variable
//        let existingSearchObjects = SearchTerms()
//        existingSearchObjects.searchTerm = searchController.searchBar.text
//        let newSearchObject = existingSearchObjects.searchTerm
//        let realm = Realm()
//        var doesExist = false
//        var storeExistingResults: [AnyObject] = []
//        // searches through array for existing objects
//        for savedSearchTerm in existingSearchTerms {
//            if existingSearchObjects.searchTerm == savedSearchTerm.searchTerm{
//                doesExist = true
//                storeExistingResults.append(savedSearchTerm)
//            }
//            
//        }


}
