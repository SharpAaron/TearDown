//
//  ListTableViewController.swift
//  Indexsearch
//
//  Created by Aaron Wasserman on 7/20/15.
//  Copyright (c) 2015 Aaron Wasserman. All rights reserved.
//
import RealmSwift
import UIKit



class ListTableViewController: UITableViewController {
    var unfilteredSavedSearches: [SearchTerm] = [SearchTerm]()
    let realm = Realm()
    var searchController: UISearchController!
    var savedSearches: Results<SearchTermRealm>! {
        didSet {
            tableView.reloadData()
        }
    }
    
    var yahooSearchViewController: YSLSearchViewController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(red: 39.0/255, green: 73.0/255, blue: 86.0/255, alpha: 1.0)
        setupYahooSearch()
        setupSearchController()
    }
    
    func setupYahooSearch() {
        let settings = YSLSearchViewControllerSettings()
        settings.enableSearchToLink = true
        settings.enableTransparency = true
        yahooSearchViewController = YSLSearchViewController(settings: settings);
        yahooSearchViewController!.delegate = self
    }
    
    func setupSearchController() {
        savedSearches = realm.objects(SearchTermRealm).sorted("text", ascending: true)

        let searchTableViewController = UIStoryboard(name: "New Story", bundle: nil).instantiateViewControllerWithIdentifier("searchTableViewController") as! SearchTableViewController
        
    
        searchController = UISearchController(searchResultsController: searchTableViewController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Enter searches here"
        searchController.searchBar.tintColor = UIColor.blueColor()
        searchController.searchBar.returnKeyType = UIReturnKeyType.Search
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
        
    }
    func synchronizeRealm() {
        let text = searchController.searchBar.text
        let term = SearchTermRealm()
        term.text = text
        
        var termExists = false
        for term in savedSearches {
            if term.text == text {
                termExists = true
                break
            }
        }
        
        if !termExists {
            realm.write {
                self.realm.add(term)
            }
            savedSearches = realm.objects(SearchTermRealm).sorted("text", ascending: true)
            tableView.reloadData()
        }
    }
}

// MARK: YSLSearchViewControllerDelegate
extension ListTableViewController: YSLSearchViewControllerDelegate {
    
    func searchViewController(searchViewController: YSLSearchViewController!, actionForQueryString queryString: String!) -> YSLQueryAction {
        println("actionForQueryString ---> \(queryString)")
        return YSLQueryAction.Search
    }
    
    func searchViewControllerDidTapLeftButton(searchViewController: YSLSearchViewController) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func searchViewController(searchViewController: YSLSearchViewController!, didSearchToLink result: YSLSearchToLinkResult!) {
        
        println("did search to link query string --> \(searchViewController.queryString)")
        println("did search to link short url --> \(result.shortURL)")
        
    }
    
    func shouldSearchViewController(searchViewController: YSLSearchViewController!, previewSearchToLinkForSearchResultType searchResultType: String!) -> Bool {
        println("previewSearchToLink --->  \(searchResultType)")
        return true
    }
    
    func shouldSearchViewController(searchViewController: YSLSearchViewController!, loadWebResult result: YSLSearchWebResult!) -> Bool {
        println("loadWebResult ---> \(searchViewController.selectedResultType)")
        return false
    }
    
    
    
}

// MARK: UISearchResultsUpdating 
extension ListTableViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        var searchString = searchController.searchBar.text
        
        
        searchString = searchString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        searchString = searchString.lowercaseString
        var predicate = NSPredicate(format: "text.lowercaseString BEGINSWITH %@", searchString.lowercaseString)
//        var unfilteredSavedSearches: [SearchTerm] = [SearchTerm]()
        
        for index in 0..<savedSearches.count {
            var object = savedSearches[index] as SearchTermRealm
            
//            println(object)
            
            unfilteredSavedSearches.append(SearchTerm(text: savedSearches[index].text as String))
        }
        
        var filteredData = (unfilteredSavedSearches as NSArray).filteredArrayUsingPredicate(predicate)
        (searchController.searchResultsController as! SearchTableViewController).searchResultsArray = filteredData as! [SearchTerm]
        (searchController.searchResultsController as! SearchTableViewController).tableView.reloadData()
        

        
//        if !searchString.isEmpty {
//            searchString = searchString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
//            searchString = searchString.lowercaseString
//            var predicate = NSPredicate(format: "text.lowercaseString BEGINSWITH %@", searchString.lowercaseString)
//            var unfilteredSavedSearches: [SearchTerm] = [SearchTerm]()
//            for index in 0..< savedSearches.count {
//                unfilteredSavedSearches.append(SearchTerm(text: savedSearches[index].text as String))
//            }
//            var filteredData = (unfilteredSavedSearches as NSArray).filteredArrayUsingPredicate(predicate)
//            (searchController.searchResultsController as! SearchTableViewController).searchResultsArray = filteredData as! [SearchTerm]
//            (searchController.searchResultsController as! SearchTableViewController).tableView.reloadData()
//        }
        
        
        
    }
}

// MARK: UISearchBarDelegate
extension ListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        //takes text from search bar and launches predefined search
        yahooSearchViewController?.queryString = searchBar.text
        yahooSearchViewController?.setSearchResultTypes([YSLSearchResultTypeWeb])
        self.presentViewController(yahooSearchViewController!, animated: true, completion: nil);
        synchronizeRealm()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        println("go back ")
    }
}

// MARK: UITableViewDelegate
extension ListTableViewController: UITableViewDelegate {
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            //handle delete (by removing the data from your array and updating the tableview)
            let deletedSearches = savedSearches[indexPath.row]
            let realm = Realm()
            realm.write({ () -> Void in
                realm.delete(deletedSearches)
            })
            savedSearches = realm.objects(SearchTermRealm).sorted("text", ascending: true)
            tableView.reloadData()
            println("pressed delete")
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var launchSearchFromList = savedSearches[indexPath.row].text as! String
        yahooSearchViewController?.queryString = launchSearchFromList
        yahooSearchViewController?.setSearchResultTypes([YSLSearchResultTypeWeb])
        self.presentViewController(yahooSearchViewController!, animated: true, completion: nil);
        println("launch search")
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}

// MARK: UITableViewDataSource
extension ListTableViewController: UITableViewDataSource {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedSearches.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listCell") as! UITableViewCell
        cell.textLabel?.text = savedSearches[indexPath.row].text as String
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
}
