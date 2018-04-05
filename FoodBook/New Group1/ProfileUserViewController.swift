//
//  ProfileUserViewController.swift
//  FoodBook
//
//  Created by Piper Ward on 3/21/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import UIKit
import Firebase

class ProfileUserViewController: UIViewController {
    
    var user: User!
    var posts: [Post] = []
    
    let ref = Database.database().reference(withPath: "posts")
    
    //MARK: Properties
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        user = User()
        user.email = Auth.auth().currentUser?.email
        user.id = Auth.auth().currentUser?.uid
        user.username = "Jane Doe"
        
        ref.observe(.value, with: { snapshot in
            // Store the latest version of the data in a local variable inside the listener’s closure.
            var myPosts: [Post] = []
            // Loop through the posts provided by the snapshot that the closure returned, creating list
            for item in snapshot.children {
                let post = Post(snapshot: item as! DataSnapshot)
                if post.uid == self.user.id! {
                    myPosts.append(post)
                }
            }
            
            // Reassign items to the latest version of the data, reload the table view
            self.posts = myPosts
            self.collectionView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.reload()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func reload() {
        collectionView.reloadData()
    }
}

extension ProfileUserViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3 - 1, height: collectionView.frame.size.width / 3 - 1)
    }
}

extension ProfileUserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        let post = posts[indexPath.row]
        cell.post = post
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderProfileCollectionReusableView", for: indexPath) as! HeaderProfileCollectionReusableView
        if let user = self.user {
            headerViewCell.user = user
            //headerViewCell.delegate = self.delegate
            //headerViewCell.delegate2 = self
            headerViewCell.myPostsCountLabel.text! = "\(posts.count)"
        }
        return headerViewCell
    }
}

extension ProfileUserViewController: PhotoCollectionViewCellDelegate {
    func goToDetailVC(postId: String) {
        performSegue(withIdentifier: "ProfileUser_DetailSegue", sender: postId)
    }
}
