//
//  ListTableViewController.swift
//  Indexsearch
//
//  Created by Aaron Wasserman on 7/20/15.
//  Copyright (c) 2015 Aaron Wasserman. All rights reserved.
//
import RealmSwift
import UIKit



class ListTableViewController: UITableViewController{
    
    var searchTableViewController: UITableViewController?
    let realm = Realm()
    var searchController: UISearchController!
    var searchViewController: YSLSearchViewController?
    var savedSearches: Results<SearchTerms>! {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reload()
        let settings = YSLSearchViewControllerSettings()
        settings.enableSearchToLink = true
        settings.enableTransparency = false
        searchViewController = YSLSearchViewController(settings: settings);
        searchViewController!.delegate = self
        setupSearchController()
    }

    // Set up UISearch Controller
    
    
    func setupSearchController() {
        let searchTableViewController = SearchTableViewController()
        searchTableViewController.tableView.delegate = searchTableViewController
        searchTableViewController.tableView.dataSource = searchTableViewController
        searchTableViewController.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "searchCell")
        searchController = UISearchController(searchResultsController: searchTableViewController)
        searchController.searchResultsUpdater = searchTableViewController
        searchController.delegate = searchTableViewController
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Enter searches here"
        searchController.searchBar.tintColor = UIColor.blueColor()
        searchController.searchBar.returnKeyType = UIReturnKeyType.Search
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
        
    }
    
    
    //function to update table with user generated search term
    func reload() {
        savedSearches = realm.objects(SearchTerms).sorted("searchTerm", ascending: true)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedSearches.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("aCell", forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        let savedWords = savedSearches[row] as SearchTerms
        cell.textLabel?.text = savedWords.searchTerm
        return cell
    }
    
    
}

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

extension ListTableViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

        //takes text from search bar and launches predefined search
//        searchViewController?.queryString = searchBar.text
//        searchViewController?.setSearchResultTypes([YSLSearchResultTypeWeb])
//        self.presentViewController(searchViewController!, animated: true, completion: nil);
//        let searchContent = SearchTerms()
//        searchContent.searchTerm = searchBar.text
//        let searchObject = searchContent.searchTerm
//        let realm = Realm()
//        var alreadyExists = false
//        for savedSearchTerm in savedSearches {
//            if searchContent.searchTerm == savedSearchTerm.searchTerm {
//                alreadyExists = true
//            }
//        }
//        
//        if alreadyExists == false {
//            realm.write {
//                realm.add(searchContent)
//            }
//        }
        reload()
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        //takes text from search bar and launches predefined search
        searchViewController?.queryString = searchBar.text
        searchViewController?.setSearchResultTypes([YSLSearchResultTypeWeb])
        self.presentViewController(searchViewController!, animated: true, completion: nil);
        let searchContent = SearchTerms()
        searchContent.searchTerm = searchBar.text
        let searchObject = searchContent.searchTerm
        let realm = Realm()
        var alreadyExists = false
        for savedSearchTerm in savedSearches {
            if searchContent.searchTerm == savedSearchTerm.searchTerm {
                alreadyExists = true
            }
        }
        
        if alreadyExists == false {
            realm.write {
                realm.add(searchContent)
            }
        }
        reload()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        println("go back ")
    }
}
