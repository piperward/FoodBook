//
//  ResetPasswordViewController.swift
//  FoodBook
//
//  Created by Piper Ward on 3/30/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        statusLabel.text! = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    // Sends a password reset email to the provided email address if it's in the database
    @IBAction func reset(_ sender: Any) {
        if emailTextField.text! != "" {
            Auth.auth().sendPasswordReset(withEmail: emailTextField.text!, completion: { error in
                if error == nil {
                    self.emailTextField.text! = ""
                    self.statusLabel.text! = "Password reset email sent."
                } else {
                self.statusLabel.text! = "ERROR"
                }
            })
        } else {
            self.statusLabel.text! = "Please enter a valid email."
        }
    }
    
    @IBAction func signIn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
}
