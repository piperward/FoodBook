//
//  OtherProfileViewController.swift
//  FoodBook
//
//  Created by Piper Ward on 4/22/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import UIKit
import NightNight

class OtherProfileViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var user: User!
    
    // Maintain's all of the user's posts
    var posts: [Post] = []
    var userId = ""
    
    var delegate: HeaderProfileCollectionReusableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("userId: \(userId)")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Fetch user information and their posts form the database
        fetchUser()
        fetchMyPosts()
        
        //Nightmode setup
        view.mixedBackgroundColor = MixedColor(normal: 0xffffff, night: 0x222222)
        collectionView.mixedBackgroundColor = MixedColor(normal: 0xfafafa, night: 0x222222)
        navigationController?.navigationBar.mixedBarTintColor = MixedColor(normal: 0xffffff, night: 0x222222)
        navigationController?.navigationBar.mixedTintColor = MixedColor(normal: 0x0000ff, night: 0xfafafa)
        navigationController?.navigationBar.mixedBarStyle = MixedBarStyle(normal: .default, night: .black)
        navigationController?.navigationBar.mixedTitleTextAttributes = [NNForegroundColorAttributeName: MixedColor(normal: 0x000000, night: 0xfafafa)]
    }
    
    // Fetches the user's data from the database
    func fetchUser() {
        Api.observeUser(withId: userId) { (user) in
            self.isFollowing(userId: user.id!, completed: { (value) in
                user.isFollowing = value
                self.user = user
                self.navigationItem.title = user.username
                self.collectionView.reloadData()
            })
        }
    }
    
    // Updates the follow button on the profile to reflect whether or not the current user is already following them
    func isFollowing(userId: String, completed: @escaping (Bool) -> Void) {
        Api.isFollowing(userId: userId, completed: completed)
    }
    
    // Fetches all of the user's posts from the database
    func fetchMyPosts() {
        Api.fetchMyPosts(userId: userId) { (key) in
            Api.observePost(withId: key, completion: {
                post in
                self.posts.append(post)
                self.collectionView.reloadData()
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let detailVC = segue.destination as! DetailViewController
            let postId = sender  as! String
            detailVC.postId = postId
        }
        if segue.identifier == "settingsSegue" {
            let settingVC = segue.destination as! SettingsViewController
            settingVC.delegate = self
        }
    }
    
}


extension OtherProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        
        // Each cell has a post variable that it uses to pull the correct post information from the database
        let post = posts[indexPath.row]
        cell.post = post
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderProfileCollectionReusableView", for: indexPath) as! HeaderProfileCollectionReusableView
        if let user = self.user {
            headerViewCell.user = user
            headerViewCell.delegate = self.delegate
            headerViewCell.delegate2 = self
        }
        return headerViewCell
    }
}

extension OtherProfileViewController: HeaderProfileCollectionReusableViewDelegateSwitchSettingVC {
    func goToSettingVC() {
        performSegue(withIdentifier: "settingsSegue", sender: nil)
    }
}

// Customizes the collection view layout
extension OtherProfileViewController: UICollectionViewDelegateFlowLayout {
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

extension OtherProfileViewController: PhotoCollectionViewCellDelegate {
    func goToDetailVC(postId: String) {
        performSegue(withIdentifier: "detailSegue", sender: postId)
    }
}

extension OtherProfileViewController: SettingsViewControllerDelegate {
    func updateUserInfor() {
        self.fetchUser()
    }
}
