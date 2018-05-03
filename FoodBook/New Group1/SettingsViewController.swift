//
//  SettingsViewController.swift
//  FoodBook
//
//  Created by Kyle McCarver on 4/1/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import UIKit
import Firebase
import NightNight

protocol SettingsViewControllerDelegate {
    func updateUserInfor()
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var nightModeSwitch: UISwitch!
    @IBOutlet weak var boldSwitch: UISwitch!
    
    // UILabels
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nightModeLabel: UILabel!
    @IBOutlet weak var boldFontLabel: UILabel!
    
    
    var delegate: SettingsViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchCurrentUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if State.nightMode == true {
            nightModeSwitch.setOn(true, animated: false)
        } else {
            nightModeSwitch.setOn(false, animated: false)
        }
        if State.bold == true {
            boldSwitch.setOn(true, animated: false)
            changeFont(toBold: true)
        } else {
            boldSwitch.setOn(false, animated: false)
            changeFont(toBold: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchCurrentUser() {
        Api.observeCurrentUser { (user) in
            self.usernameTextField.text = user.username
            self.emailTextField.text = user.email
            self.bioTextField.text = user.bio
            if let profileUrl = URL(string: user.profileImageUrl!) {
                let data = try? Data(contentsOf: profileUrl)
                if let imageData = data {
                    self.profilePictureImageView.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    @IBAction func nightModeSwitchTapped(_ sender: Any) {
        if nightModeSwitch.isOn {
            State.nightMode = true
            NightNight.theme = .night
        } else {
            State.nightMode = false
            NightNight.theme = .normal
        }
    }
    
    @IBAction func boldSwitchTapped(_ sender: Any) {
        if boldSwitch.isOn {
            State.bold = true
            changeFont(toBold: true)
        } else {
            State.bold = false
            changeFont(toBold: false)
        }
    }
    
    func changeFont(toBold: Bool) {
        if toBold == true {
            usernameLabel.font = UIFont.boldSystemFont(ofSize: usernameLabel.font.pointSize)
            bioLabel.font = UIFont.boldSystemFont(ofSize: bioLabel.font.pointSize)
            emailLabel.font = UIFont.boldSystemFont(ofSize: emailLabel.font.pointSize)
            nightModeLabel.font = UIFont.boldSystemFont(ofSize: nightModeLabel.font.pointSize)
            boldFontLabel.font = UIFont.boldSystemFont(ofSize: boldFontLabel.font.pointSize)
        } else {
            usernameLabel.font = UIFont.systemFont(ofSize: usernameLabel.font.pointSize)
            bioLabel.font = UIFont.systemFont(ofSize: bioLabel.font.pointSize)
            emailLabel.font = UIFont.systemFont(ofSize: emailLabel.font.pointSize)
            nightModeLabel.font = UIFont.systemFont(ofSize: nightModeLabel.font.pointSize)
            boldFontLabel.font = UIFont.systemFont(ofSize: boldFontLabel.font.pointSize)
        }
    }
    
    @IBAction func onSaveButtonPressed(_ sender: Any) {
        if let profileImg = self.profilePictureImageView.image, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            AuthService.updateUserInfor(username: usernameTextField.text!, email: emailTextField.text!, imageData: imageData, bio: bioTextField.text!, onSuccess: {
                self.delegate?.updateUserInfor()
                _ = self.navigationController?.popViewController(animated: true)
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

