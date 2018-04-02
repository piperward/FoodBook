//
//  SignUpViewController.swift
//  FoodBook
//
//  Created by Piper Ward on 3/20/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Hides text as it is typed
        passwordTextField.isSecureTextEntry = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func signUp(_ sender: Any) {
        let username = usernameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if username! != "" && email! != "" && password! != "" {
            Auth.auth().createUser(withEmail: email!, password: password!) { user, error in
                if error == nil {
                    Auth.auth().signIn(withEmail: email!, password: password!)
                    
                    let uid = user?.uid
                    self.setUserInfomation(username: username!, email: email!, uid: uid!)
                }
            }
        }
    }
    
    @IBAction func signIn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUserInfomation(username: String, email: String, uid: String) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users")
        let newUserReference = usersReference.child(uid)
        newUserReference.setValue(["username": username, "username_lowercase": username.lowercased(), "email": email])
    }
}
