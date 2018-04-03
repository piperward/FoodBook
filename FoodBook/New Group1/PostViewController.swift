//
//  PostViewController.swift
//  FoodBook
//
//  Created by Kyle McCarver on 3/19/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    
    var selectedImage:UIImage?
    let ref = Database.database().reference(withPath: "posts")
    var currentUser = ""
    
    private var imageSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPostImageViewTapped(_ sender: UITapGestureRecognizer) {
        //Hide keyboard
        postTextView.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        self.selectedImage = selectedImage
        postImageView.image = selectedImage
        imageSelected = true
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onUploadButtonPressed(_ sender: Any) {
        if imageSelected {
            //postList.insert(post, at: 0)
            
            if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
                let ratio = profileImg.size.width / profileImg.size.height
                uploadDataToServer(data: imageData, ratio: ratio, caption: postTextView.text!)
            }
            
            //Clean up post scene and move to home scene
            self.clean()
            self.navigationController?.tabBarController?.selectedIndex = 0
        }
    }
    
    func uploadDataToServer(data: Data, ratio: CGFloat, caption: String) {
        uploadImageToFirebaseStorage(data: data) { (photoURL) in
            self.sendDataToDatabase(photoUrl: photoURL, ratio: ratio, caption: caption)
        }
    }
    
    func uploadImageToFirebaseStorage(data: Data, onSuccess: @escaping (_ imageUrl: String) -> Void) {
        let photoIdString = NSUUID().uuidString
        let storageRef = Storage.storage().reference(forURL: "gs://foodbook-9ebb1.appspot.com/").child("posts").child(photoIdString)
        storageRef.putData(data, metadata: nil) { (metadata, error) in
            if error != nil {
                return
            }
            if let photoUrl = metadata?.downloadURL()?.absoluteString {
                onSuccess(photoUrl)
            }
        }
    }
    
    func sendDataToDatabase(photoUrl: String, videoUrl: String? = nil, ratio: CGFloat, caption: String) {
        let newPostId = ref.childByAutoId().key
        let newPostReference = ref.child(newPostId)
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let currentUserId = currentUser.uid
        let dict = ["uid": currentUserId ,"photoUrl": photoUrl, "caption": caption, "likeCount": 0, "ratio": ratio] as [String : Any]
        newPostReference.setValue(dict, withCompletionBlock: {
            (error, ref) in
            if error != nil {
                return
            }
            /*
            Api.Feed.REF_FEED.child(Api.User.CURRENT_USER!.uid).child(newPostId).setValue(true)
            
            let myPostRef = Api.MyPosts.REF_MYPOSTS.child(currentUserId).child(newPostId)
            myPostRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
            })
            ProgressHUD.showSuccess("Success")
 */
            //onSuccess()
        })
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
    
    //Resets image and caption to default state
    func clean() {
        self.postTextView.text = "Caption"
        self.postImageView.image = UIImage(named: "placeholder")
        self.imageSelected = false
        self.selectedImage = nil
    }
}
