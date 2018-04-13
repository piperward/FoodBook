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
    var userId = ""
    
    //MARK: Properties
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        fetchUser()
        fetchMyPosts()
    }
    
    func fetchUser() {
        Api.observeCurrentUser { (user) in
            self.user = user
            self.navigationItem.title = user.username
            self.collectionView.reloadData()
        }
    }
    
    func fetchMyPosts() {
        guard let currentUser = Api.CURRENT_USER else {
            return
        }
        Api.REF_MYPOSTS.child(currentUser.uid).observe(.childAdded, with: {
            snapshot in
            Api.observePost(withId: snapshot.key, completion: {
                post in
                self.posts.append(post)
                self.collectionView.reloadData()
            })
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsSegue" {
            let settingVC = segue.destination as! SettingsViewController
            settingVC.delegate = self
        }
        
//        if segue.identifier == "Profile_DetailSegue" {
//            let detailVC = segue.destination as! DetailViewController
//            let postId = sender  as! String
//            detailVC.postId = postId
//        }
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
            //This is used for the follow button
            //headerViewCell.delegate = self.delegate
            headerViewCell.myPostsCountLabel.text! = "\(posts.count)"
        }
        return headerViewCell
    }
}

extension ProfileUserViewController: SettingsViewControllerDelegate {
    func updateUserInfor() {
        self.fetchUser()
    }
}

//TODO create segue
extension ProfileUserViewController: PhotoCollectionViewCellDelegate {
    func goToDetailVC(postId: String) {
        //performSegue(withIdentifier: "ProfileUser_DetailSegue", sender: postId)
    }
}
