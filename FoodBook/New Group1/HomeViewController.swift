//
//  HomeViewController.swift
//  FoodBook
//
//  Created by Kyle McCarver on 3/20/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import UIKit
import Firebase
import NightNight

class HomeViewController: UIViewController {

    var postCellIdentifier = "postCellIdentifier"
    
    // Stores posts loaded in from database
    var posts = [Post]()
    // Maintains list of users loaded in from database
    var users = [User]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //tableView.estimatedRowHeight = 521
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.allowsSelection = false
        loadPosts()
        
        //Nightmode setup
        view.mixedBackgroundColor = MixedColor(normal: 0xfafafa, night: 0x222222)
        tableView.mixedBackgroundColor = MixedColor(normal: 0xfafafa, night: 0x222222)
        navigationController?.navigationBar.mixedBarTintColor = MixedColor(normal: 0xffffff, night: 0x222222)
        navigationController?.navigationBar.mixedTintColor = MixedColor(normal: 0x0000ff, night: 0xfafafa)
        navigationController?.navigationBar.mixedBarStyle = MixedBarStyle(normal: .default, night: .black)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func loadPosts() {
        
        // Load the current user's posts
        if let currentUser = Auth.auth().currentUser {
            Api.observeFeed(withId: currentUser.uid) { (post) in
                guard let postUid = post.uid else {
                    return
                }
                self.fetchUser(uid: postUid, completed: {
                    self.posts.append(post)
                    self.tableView.reloadData()
                })
            }
            
            // If the user deleted any of their own posts, update the table view to reflect that
            Api.observeFeedRemoved(withId: currentUser.uid) { (post) in
                // These two lines removes posts and users from their respective arrays if there is a change
                self.posts = self.posts.filter { $0.id != post.id }
                self.users = self.users.filter { $0.id != post.uid }
                
                self.tableView.reloadData()
            }
        }
    }
    
    // Searches the database for a specific user and adds them to the array
    func fetchUser(uid: String, completed:  @escaping () -> Void ) {
        Api.observeUser(withId: uid, completion: {
            user in
            self.users.append(user)
            completed()
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommentSegue" {
            let commentVC = segue.destination as! CommentViewController
            let postId = sender  as! String
            commentVC.postId = postId
        }
        
        if segue.identifier == "Home_ProfileSegue" {
            let profileVC = segue.destination as! OtherProfileViewController
            let userId = sender  as! String
            profileVC.userId = userId
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        
        // Each cell has a post variable and a user variable that it uses to pull the correct data from the database
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        cell.post = post
        cell.user = user
        cell.delegate = self
        return cell
    }
}

extension HomeViewController: PostTableViewCellDelegate {
    func goToCommentVC(postId: String) {
        performSegue(withIdentifier: "CommentSegue", sender: postId)
    }
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "Home_ProfileSegue", sender: userId)
    }
}
