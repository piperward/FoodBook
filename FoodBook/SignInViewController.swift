//
//  SignInViewController.swift
//  FoodBook
//
//  Created by Piper Ward on 3/19/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        signInButton.isUserInteractionEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Private funcs
    
//    private func updateSignInButtonState() {
//        // Disable the Save button if the text field is empty.
//        let pass = passwordTextField.text ?? ""
//        let email = emailTextField.text ?? ""
//        signInButton.isEnabled = !pass.isEmpty && isValidEmail(testStr: email)
//
//    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    //MARK: UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //let text = (passwordTextField.text! as NSString).replacingCharacters(in: range, with: string)
        let pass = passwordTextField.text ?? ""
        let email = emailTextField.text ?? ""
        
        if !pass.isEmpty && isValidEmail(testStr: email){
            signInButton.isUserInteractionEnabled = true
        } else {
            signInButton.isUserInteractionEnabled = false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
}
