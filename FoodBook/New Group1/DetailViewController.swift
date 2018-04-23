//
//  DetailViewController.swift
//  FoodBook
//
//  Created by Kyle McCarver on 4/17/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import UIKit

//protocol for refreshing user posts in ProfileUserViewController
protocol DetailViewControllerDelegate {
    //passes the postId that needs to be removed from the
    func removePostFromDataSource(postId: String)
}

class DetailViewController: UIViewController {
    
    var postId = ""
    var post = Post()
    var user = User()
    
    var delegate: DetailViewControllerDelegate?
    
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
        //Remove post from database
        Api.REF_POSTS.child(post.id!).removeValue()
        Api.REF_MYPOSTS.child(user.id!).child(post.id!).removeValue()
        Api.REF_FEED.child(user.id!).child(post.id!).removeValue()
        //Remove  post from ProfileUserViewController's posts array
        delegate?.removePostFromDataSource(postId: post.id!)
        
        //Alert user that post has been deleted
        let alert = UIAlertController(title: nil, message: "Post deleted.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action:UIAlertAction!) in
            //Go back to profile page
            _ = self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail_CommentVC" {
            let commentVC = segue.destination as! CommentViewController
            let postId = sender  as! String
            commentVC.postId = postId
        }
        
//        if segue.identifier == "Detail_ProfileUserSegue" {
//            let profileVC = segue.destination as! ProfileUserViewController
//            let userId = sender  as! String
//            profileVC.userId = userId
//        }
    }

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

extension DetailViewController: PostTableViewCellDelegate {
    func goToCommentVC(postId: String) {
        performSegue(withIdentifier: "Detail_CommentVC", sender: postId)
    }
    func goToProfileUserVC(userId: String) {
        //performSegue(withIdentifier: "Detail_ProfileUserSegue", sender: userId)
    }
}
