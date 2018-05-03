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
    
    // All Database references for easy access
    static var REF_FEED = Database.database().reference().child("feed")
    static var REF_USERS = Database.database().reference().child("users")
    static var REF_POSTS = Database.database().reference().child("posts")
    static var REF_FOLLOWERS = Database.database().reference().child("followers")
    static var REF_FOLLOWING = Database.database().reference().child("following")
    static var REF_MYPOSTS = Database.database().reference().child("myPosts")
    static var REF_COMMENTS = Database.database().reference().child("comments")
    static var REF_POST_COMMENTS = Database.database().reference().child("post-comments")

    
    static var CURRENT_USER = Auth.auth().currentUser
    //MARK: FollowAPI
    
    // Called when the user taps the follow button; adds that user to their following list
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
    
    // Called when the user unfollows someone; removes that user from their following list
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
    
    // Called when updating the follow button to say if the current user is already following someone
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
    
    // Called in the profile view to show how many people the user is following
    static func fetchCountFollowing(userId: String, completion: @escaping (Int) -> Void) {
        REF_FOLLOWING.child(userId).observe(.value, with: {
            snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
        
    }
    
    // Called in the profile view to show how many people follow the user
    static func fetchCountFollowers(userId: String, completion: @escaping (Int) -> Void) {
        REF_FOLLOWERS.child(userId).observe(.value, with: {
            snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
        
    }
    
    //MARK: MyPostsAPI
    
    // Pulls data of all the posts from this user
    static func fetchMyPosts(userId: String, completion: @escaping (String) -> Void) {
        REF_MYPOSTS.child(userId).observe(.childAdded, with: {
            snapshot in
            completion(snapshot.key)
        })
    }
    
    // Called in profile view controller to show how many posts this user has
    static func fetchCountMyPosts(userId: String, completion: @escaping (Int) -> Void) {
        REF_MYPOSTS.child(userId).observe(.value, with: {
            snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
    }
    
    //MARK: PostAPI
    
    // Pulls post data from the database and their pictures from Storage
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
    
    // Updates the home feed by pulling all the posts of the user's this person follows from the database
    static func observeFeed(withId id: String, completion: @escaping (Post) -> Void) {
        REF_FEED.child(id).observe(.childAdded, with: {
            snapshot in
            let key = snapshot.key
            self.observePost(withId: key, completion: { (post) in
                completion(post)
            })
        })
    }
    
    // Updates the home feed whenever a user this person follows has deleted a post
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
    
    // Pulls this user's data from the database
    static func observeUser(withId uid: String, completion: @escaping (User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    // Pulls the current user's information from the database
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
    
    // Pulls information from the specified person this user follows
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
    
    // Updates the database whenever the current user unfollows the specified user
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
    
    // Called when updating the follow button to say if the current user is already following someone
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
    
    // Called in the profile view to show how many people the user is following
    func fetchCountFollowing(userId: String, completion: @escaping (Int) -> Void) {
        Api.REF_FOLLOWING.child(userId).observe(.value, with: {
            snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
        
    }
    
    // Called in the profile view to show how many people follow the user
    func fetchCountFollowers(userId: String, completion: @escaping (Int) -> Void) {
        Api.REF_FOLLOWERS.child(userId).observe(.value, with: {
            snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
        
    }
    
    // Comment API
    
    // Pulls comments from the correct post in the database; called whenever someone taps the comment icon on a post
    static func observeComments(withPostId id: String, completion: @escaping (Comment) -> Void) {
        Api.REF_COMMENTS.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let newComment = Comment.transformComment(dict: dict)
                completion(newComment)
            }
        })
    }
}
