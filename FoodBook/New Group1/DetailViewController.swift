//
//  DetailViewController.swift
//  FoodBook
//
//  Created by Kyle McCarver on 4/17/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var postId = ""
    var post = Post()
    var user = User()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadPost()
    }
    
    func loadPost() {
        Api.observePost(withId: postId) { (post) in
            guard let postUid = post.uid else {
                return
            }
            print(postUid)
            self.fetchUser(uid: postUid, completed: {
                self.post = post
                self.tableView.reloadData()
            })
        }
    }
    
    func fetchUser(uid: String, completed:  @escaping () -> Void ) {
        Api.observeUser(withId: uid, completion: {
            user in
            self.user = user
            completed()
        })
        
    }
    
    @IBAction func deletePost(_ sender: Any) {
        Api.REF_POSTS.child(post.id!).removeValue()
        Api.REF_MYPOSTS.child(user.id!).child(post.id!).removeValue()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        cell.post = post
        cell.user = user
        cell.delegate = self
        return cell
    }
}

extension DetailViewController: HomeTableViewCellDelegate {
    func goToCommentVC(postId: String) {
        //performSegue(withIdentifier: "Detail_CommentVC", sender: postId)
    }
    func goToProfileUserVC(userId: String) {
        //performSegue(withIdentifier: "Detail_ProfileUserSegue", sender: userId)
    }
}
