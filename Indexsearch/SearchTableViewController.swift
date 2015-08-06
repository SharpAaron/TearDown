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
    let realm = Realm()
    var yahooSearchViewController: YSLSearchViewController?
    var listTableViewController: ListTableViewController?
    var searchResultsArray: [SearchTerm]!
    var savedSearches: Results<SearchTermRealm>! {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultsArray?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        savedSearches = realm.objects(SearchTermRealm).sorted("text", ascending: true)
        var launchSearchFromList = searchResultsArray[indexPath.row].text as String
        println(launchSearchFromList)
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.listTableViewController!.searchSelectedSearchResultWithString(launchSearchFromList)
        })
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("something", forIndexPath: indexPath) as! UITableViewCell
        var returnedSearchObjects = searchResultsArray[indexPath.row] as SearchTerm
        cell.textLabel?.text = returnedSearchObjects.text
        var date = returnedSearchObjects.dateModified
        var text = NSDateFormatter.localizedStringFromDate(date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        cell.detailTextLabel?.text = text
        
        return cell
    }
    
}

