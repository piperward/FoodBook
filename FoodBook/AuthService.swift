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
    static func signUp(username: String, email: String, password: String, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            let uid = user?.uid
//            let storageRef = StorageStorage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("profile_image").child(uid!)
//
//            storageRef.put(imageData, metadata: nil, completion: { (metadata, error) in
//                if error != nil {
//                    return
//                }
//                let profileImageUrl = metadata?.downloadURL()?.absoluteString
//
//                self.setUserInfomation(profileImageUrl: profileImageUrl!, username: username, email: email, uid: uid!, onSuccess: onSuccess)
            self.setUserInfomation(username: username, email: email, uid: uid!, onSuccess: onSuccess)
            
            })
        }
    
    // Adds a new user to the database using the provided information
    static func setUserInfomation(username: String, email: String, uid: String, onSuccess: @escaping () -> Void) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users")
        let newUserReference = usersReference.child(uid)
        newUserReference.setValue(["username": username, "username_lowercase": username.lowercased(), "email": email])
    
        onSuccess()
    }
        
}

