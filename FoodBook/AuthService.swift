//
//  AuthService.swift
//  FoodBook
//
//  Created by Piper Ward on 4/12/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AuthService {
    static func signUp(username: String, email: String, password: String, imageData: Data, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            let uid = user?.uid
            let storageRef = Storage.storage().reference(forURL: "gs://foodbook-9ebb1.appspot.com/").child("profile_image").child(uid!)

            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    return
                }
                let profileImageUrl = metadata?.downloadURL()?.absoluteString

                self.setUserInformation(profileImageUrl: profileImageUrl!, username: username, email: email, uid: uid!, bio: "", onSuccess: onSuccess)
            
            })
        })
    }
    
    // Adds a new user to the database using the provided information
    static func setUserInformation(profileImageUrl: String, username: String, email: String, uid: String, bio: String, onSuccess: @escaping () -> Void) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users")
        let newUserReference = usersReference.child(uid)
        newUserReference.setValue(["username": username, "username_lowercase": username.lowercased(), "email": email, "profileImageUrl": profileImageUrl, "bio": bio])
    
        onSuccess()
        }
    
    static func updateUserInfor(username: String, email: String, imageData: Data, bio: String, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        
        Api.CURRENT_USER?.updateEmail(to: email, completion: { (error) in
            if error != nil {
                onError(error!.localizedDescription)
            }else {
                let uid = Api.CURRENT_USER?.uid
                let storageRef = Storage.storage().reference(forURL: "gs://foodbook-9ebb1.appspot.com/").child("profile_image").child(uid!)
                
                storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        return
                    }
                    let profileImageUrl = metadata?.downloadURL()?.absoluteString
                    
                    self.updateDatabase(profileImageUrl: profileImageUrl!, username: username, email: email, bio: bio, onSuccess: onSuccess, onError: onError)
                })
            }
        })
        
    }
    
    static func updateDatabase(profileImageUrl: String, username: String, email: String, bio: String, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        let dict = ["username": username, "username_lowercase": username.lowercased(), "email": email, "profileImageUrl": profileImageUrl, "bio": bio]
        Api.REF_USERS.child((Api.CURRENT_USER?.uid)!).updateChildValues(dict, withCompletionBlock: { (error, ref) in
            if error != nil {
                onError(error!.localizedDescription)
            } else {
                onSuccess()
            }
            
        })
    }

}
