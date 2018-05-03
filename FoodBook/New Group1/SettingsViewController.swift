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
        
        //Nightmode setup
        view.mixedBackgroundColor = MixedColor(normal: 0xffffff, night: 0x222222)
        navigationController?.navigationBar.mixedBarTintColor = MixedColor(normal: 0xffffff, night: 0x222222)
        navigationController?.navigationBar.mixedTintColor = MixedColor(normal: 0x0000ff, night: 0xfafafa)
        navigationController?.navigationBar.mixedBarStyle = MixedBarStyle(normal: .default, night: .black)
        navigationController?.navigationBar.mixedTitleTextAttributes = [NNForegroundColorAttributeName: MixedColor(normal: 0x000000, night: 0xfafafa)]
        
        let username = NSMutableAttributedString(string: "Username")
        username.setMixedAttributes([NNForegroundColorAttributeName:
            MixedColor(normal: 0x000000, night: 0xfafafa)],
                                    range: NSRange(location: 0, length: username.string.count))
        self.usernameLabel.attributedText = username
        
        let bio = NSMutableAttributedString(string: "Bio")
        bio.setMixedAttributes([NNForegroundColorAttributeName:
            MixedColor(normal: 0x000000, night: 0xfafafa)],
                               range: NSRange(location: 0, length: bio.string.count))
        self.bioLabel.attributedText = bio
        
        let email = NSMutableAttributedString(string: "Email")
        email.setMixedAttributes([NNForegroundColorAttributeName:
            MixedColor(normal: 0x000000, night: 0xfafafa)],
                                 range: NSRange(location: 0, length: email.string.count))
        self.emailLabel.attributedText = email
        
        let nightMode = NSMutableAttributedString(string: "Night Mode")
        nightMode.setMixedAttributes([NNForegroundColorAttributeName:
            MixedColor(normal: 0x000000, night: 0xfafafa)],
                                 range: NSRange(location: 0, length: nightMode.string.count))
        self.nightModeLabel.attributedText = nightMode
        
        let boldFont = NSMutableAttributedString(string: "Bold Text")
        boldFont.setMixedAttributes([NNForegroundColorAttributeName:
            MixedColor(normal: 0x000000, night: 0xfafafa)],
                                 range: NSRange(location: 0, length: boldFont.string.count))
        self.boldFontLabel.attributedText = boldFont
    }
    
    //Prepares switches based on the appropiate State
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
    
    //Change nightMode state when switch is tapped
    @IBAction func nightModeSwitchTapped(_ sender: Any) {
        if nightModeSwitch.isOn {
            State.nightMode = true
            NightNight.theme = .night
        } else {
            State.nightMode = false
            NightNight.theme = .normal
        }
    }
    
    //Change bold state when switch is tapped
    @IBAction func boldSwitchTapped(_ sender: Any) {
        if boldSwitch.isOn {
            State.bold = true
            changeFont(toBold: true)
        } else {
            State.bold = false
            changeFont(toBold: false)
        }
    }
    
    //Change text to bold when switch is tapped
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
    
    //Change profile picture when image is tapped
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
}

//Used for picking new profile picture
extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did Finish Picking Media")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            profilePictureImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

