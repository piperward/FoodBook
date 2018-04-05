//
//  SearchViewController.swift
//  FoodBook
//
//  Created by Piper Ward on 4/3/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController {
    var REF_USERS = Database.database().reference().child("users")

    var searchBar = UISearchBar()
    var users: [User] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.frame.size.width = view.frame.size.width - 60
        
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = searchItem
        
        self.tableView.dataSource = self
        
        doSearch()
    }
    
    func doSearch() {
        if let searchText = searchBar.text?.lowercased() {
            self.users.removeAll()
            self.tableView.reloadData()
            queryUsers(withText: searchText, completion: { (user) in
                self.users.append(user)
                self.tableView.reloadData()
            })
        }
    }
    
    func queryUsers(withText text: String, completion: @escaping (User) -> Void) {
        REF_USERS.queryOrdered(byChild: "username_lowercase").queryStarting(atValue: text).queryEnding(atValue: text+"\u{f8ff}").queryLimited(toFirst: 10).observeSingleEvent(of: .value, with: {
            snapshot in
            snapshot.children.forEach({ (s) in
                let child = s as! DataSnapshot
                if let dict = child.value as? [String: Any] {
                    let user = User.transformUser(dict: dict, key: child.key)
                    completion(user)
                }
            })
        })
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "Search_ProfileSegue" {
//            let profileVC = segue.destination as! ProfileUserViewController
//            let userId = sender  as! String
//            profileVC.userId = userId
//            profileVC.delegate = self
//        }
//    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        doSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        doSearch()
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCell
        let user = users[indexPath.row]
        cell.user = user
        //cell.delegate = self
        return cell
    }
}
