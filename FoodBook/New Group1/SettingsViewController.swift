//
//  SettingsViewController.swift
//  FoodBook
//
//  Created by Kyle McCarver on 4/1/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import UIKit
import Firebase

protocol SettingsViewControllerDelegate {
    func updateUserInfor()
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    var delegate: SettingsViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchCurrentUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchCurrentUser() {
        Api.observeCurrentUser { (user) in
            self.usernameTextField.text = user.username
            self.emailTextField.text = user.email
            if let profileUrl = URL(string: user.profileImageUrl!) {
                let data = try? Data(contentsOf: profileUrl)
                if let imageData = data {
                    self.profilePictureImageView.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    @IBAction func onSaveButtonPressed(_ sender: Any) {
        if let profileImg = self.profilePictureImageView.image, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            AuthService.updateUserInfor(username: usernameTextField.text!, email: emailTextField.text!, imageData: imageData, onSuccess: {
                self.delegate?.updateUserInfor()
            }, onError: { (errorMessage) in
                //ProgressHUD.showError(errorMessage)
            })
        }
    }
    
    @IBAction func onChangeProfilePicturePressed(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func signOut(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Start", bundle: nil).instantiateViewController(withIdentifier: "SignIn")
                present(vc, animated: true, completion: nil)
                print("signout successful")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("not signed in")
        }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did Finish Picking Media")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            profilePictureImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
