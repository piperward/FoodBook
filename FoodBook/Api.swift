//
//  Api.swift
//  FoodBook
//
//  Created by Piper Ward on 4/10/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import Foundation
import Firebase
struct Api {
    static var REF_FEED = Database.database().reference().child("feed")
    static var REF_USERS = Database.database().reference().child("users")
    static var REF_POSTS = Database.database().reference().child("posts")
    static var REF_FOLLOWERS = Database.database().reference().child("followers")
    static var REF_FOLLOWING = Database.database().reference().child("following")
    static var REF_MYPOSTS = Database.database().reference().child("myPosts")

    
    static var CURRENT_USER = Auth.auth().currentUser
    //MARK: FollowAPI
    static func followAction(withUser id: String) {
        self.REF_MYPOSTS.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                for key in dict.keys {
                    Database.database().reference().child("feed").child(self.CURRENT_USER!.uid).child(key).setValue(true)
                }
            }
        })
        REF_FOLLOWERS.child(id).child(self.CURRENT_USER!.uid).setValue(true)
        REF_FOLLOWING.child(self.CURRENT_USER!.uid).child(id).setValue(true)
    }
    
    static func unFollowAction(withUser id: String) {
        
        self.REF_MYPOSTS.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                for key in dict.keys {
                    Database.database().reference().child("feed").child(self.CURRENT_USER!.uid).child(key).removeValue()
                }
            }
        })
        
        REF_FOLLOWERS.child(id).child(CURRENT_USER!.uid).setValue(NSNull())
        REF_FOLLOWING.child(CURRENT_USER!.uid).child(id).setValue(NSNull())
    }
    
    static func isFollowing(userId: String, completed: @escaping (Bool) -> Void) {
        REF_FOLLOWERS.child(userId).child(self.CURRENT_USER!.uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let _ = snapshot.value as? NSNull {
                completed(false)
            } else {
                completed(true)
            }
        })
    }
    
    static func fetchCountFollowing(userId: String, completion: @escaping (Int) -> Void) {
        REF_FOLLOWING.child(userId).observe(.value, with: {
            snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
        
    }
    
    static func fetchCountFollowers(userId: String, completion: @escaping (Int) -> Void) {
        REF_FOLLOWERS.child(userId).observe(.value, with: {
            snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
        
    }
    
    //MARK: MyPostsAPI
    
    static func fetchMyPosts(userId: String, completion: @escaping (String) -> Void) {
        REF_MYPOSTS.child(userId).observe(.childAdded, with: {
            snapshot in
            completion(snapshot.key)
        })
    }
    
    static func fetchCountMyPosts(userId: String, completion: @escaping (Int) -> Void) {
        REF_MYPOSTS.child(userId).observe(.value, with: {
            snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
    }
    
    //MARK: PostAPI
    static func observePost(withId id: String, completion: @escaping (Post) -> Void) {
        REF_POSTS.child(id).observeSingleEvent(of: DataEventType.value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let post = Post.transformPostPhoto(dict: dict, key: snapshot.key)
                completion(post)
            }
        })
    }
    
    //MARK: FeedAPI
    static func observeFeed(withId id: String, completion: @escaping (Post) -> Void) {
        REF_FEED.child(id).observe(.childAdded, with: {
            snapshot in
            let key = snapshot.key
            self.observePost(withId: key, completion: { (post) in
                completion(post)
            })
        })
    }
    
    static func observeFeedRemoved(withId id: String, completion: @escaping (Post) -> Void) {
        REF_FEED.child(id).observe(.childRemoved, with: {
            snapshot in
            let key = snapshot.key
            self.observePost(withId: key, completion: { (post) in
                completion(post)
            })
        })
    }
    
    //MARK: UserAPI
    static func observeUser(withId uid: String, completion: @escaping (User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    static func observeCurrentUser(completion: @escaping (User) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        REF_USERS.child(currentUser.uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    //MARK: FollowAPI
    func followAction(withUser id: String) {
        Api.REF_MYPOSTS.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                for key in dict.keys {
                    Database.database().reference().child("feed").child(Api.CURRENT_USER!.uid).child(key).setValue(true)
                }
            }
        })
        Api.REF_FOLLOWERS.child(id).child(Api.CURRENT_USER!.uid).setValue(true)
        Api.REF_FOLLOWING.child(Api.CURRENT_USER!.uid).child(id).setValue(true)
    }
    
    func unFollowAction(withUser id: String) {
        
        Api.REF_MYPOSTS.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                for key in dict.keys {
                    Database.database().reference().child("feed").child(Api.CURRENT_USER!.uid).child(key).removeValue()
                }
            }
        })
        
        Api.REF_FOLLOWERS.child(id).child(Api.CURRENT_USER!.uid).setValue(NSNull())
        Api.REF_FOLLOWING.child(Api.CURRENT_USER!.uid).child(id).setValue(NSNull())
    }
    
    func isFollowing(userId: String, completed: @escaping (Bool) -> Void) {
        Api.REF_FOLLOWERS.child(userId).child(Api.CURRENT_USER!.uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let _ = snapshot.value as? NSNull {
                completed(false)
            } else {
                completed(true)
            }
        })
    }
    
    func fetchCountFollowing(userId: String, completion: @escaping (Int) -> Void) {
        Api.REF_FOLLOWING.child(userId).observe(.value, with: {
            snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
        
    }
    
    func fetchCountFollowers(userId: String, completion: @escaping (Int) -> Void) {
        Api.REF_FOLLOWERS.child(userId).observe(.value, with: {
            snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
        
    }
}
