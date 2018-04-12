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
    //        let username = usernameTextField.text
    //        let email = emailTextField.text
    //        let password = passwordTextField.text
    //
    //        // If no field is empty, create a new user with Firebase
    //        if username! != "" && email! != "" && password! != "" {
    //            Auth.auth().createUser(withEmail: email!, password: password!) { user, error in
    //                if error == nil {
    //                    Auth.auth().signIn(withEmail: email!, password: password!)
    //
    //                    let uid = user?.uid
    //                    self.setUserInfomation(username: username!, email: email!, uid: uid!)
    //
    //                    self.dismissScene()
    //                }
    //                else {
    //                    print("Error: " + error.debugDescription)
    //                }
    //            }
    //        }
    
    //        view.endEditing(true)
    //ProgressHUD.show("Waiting...", interaction: false)
    //        if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
        
    AuthService.signUp(username: usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, onSuccess: {
                //ProgressHUD.showSuccess("Success")
                self.dismissScene()
            }, onError: { (errorString) in
                //ProgressHUD.showError(errorString!)
                print(errorString!)
            })
//    else {
//            ProgressHUD.showError("Profile Image can't be empty")
//        }
    }
    
    @IBAction func signIn(_ sender: Any) {
        dismissScene()
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
    
    //Dimiss the current view
    func dismissScene() {
        self.dismiss(animated: true, completion: nil)
    }
}

