//
//  SignInViewController.swift
//  FoodBook
//
//  Created by Piper Ward on 3/19/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInUIDelegate {
    
    //MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var invalidLabel: UILabel!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        invalidLabel.text! = ""
        
        //Hides text as it is typed
        passwordTextField.isSecureTextEntry = true
        
        //Google sign in
        GIDSignIn.sharedInstance().uiDelegate = self
        
        //Skips this controller if user is already signed in
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
                self.present(vc!, animated: true, completion: nil)
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Keyboard dismissal methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Called when the user touches on the main view (outside the UITextField).
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: Actions
    @IBAction func signIn(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        //Ensure email and password are valid
        if email! == "" || password! == "" {
            print("invalid - blank text field")
            self.invalidLabel.text! = "Invalid information"
        } else {
            Auth.auth().signIn(withEmail: email!, password: password!) { user, error in
                if error == nil {
                    print("Login success")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
                    self.present(vc!, animated: true, completion: nil)
                } else {
                    print("invalid - login failure")
                    self.invalidLabel.text! = "Invalid information"
                }
            }
        }
    }
}
