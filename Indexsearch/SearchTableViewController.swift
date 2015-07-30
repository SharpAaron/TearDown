//
//  SearchTableViewController.swift
//  Indexsearch
//
//  Created by Aaron Wasserman on 7/27/15.
//  Copyright (c) 2015 Aaron Wasserman. All rights reserved.
//

import UIKit
import RealmSwift

class SearchTableViewController: UITableViewController,UISearchControllerDelegate, UISearchResultsUpdating {
    
    let realm = Realm()
    var searchResultsArray: [AnyObject] = []
    var existingSearchTerms: Results<SearchTerms>!{
        didSet{
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        existingSearchTerms = realm.objects(SearchTerms).sorted("searchTerm", ascending: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
// MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultsArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = searchResultsArray[indexPath.row] as? String
        cell.detailTextLabel?.text = searchResultsArray[indexPath.row] as? String
        return cell
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        var searchText = searchController.searchBar.text
        searchResultsArray.removeAll(keepCapacity: true)
        // create new variable
        let existingSearchObjects = SearchTerms()
        existingSearchObjects.searchTerm = searchController.searchBar.text
        let newSearchObject = existingSearchObjects.searchTerm
        let realm = Realm()
        var doesExist = false
        var storeExistingResults: [AnyObject] = []
        // searches through array for existing objects
        for savedSearchTerm in existingSearchTerms {
            if existingSearchObjects.searchTerm == savedSearchTerm.searchTerm{
                doesExist = true
                storeExistingResults.append(savedSearchTerm)
            }
            
        }
        // find matches here
        // make one array to search through existing realm objects, another array to store matches
        // have to clear array then append it
        searchResultsArray.append(searchText)
        tableView.reloadData()
    }

}

extension SearchTableViewController: UISearchResultsUpdating,UISearchBarDelegate {

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {

    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        updateSearchResultsForSearchController()
    }

}