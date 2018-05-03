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
import NightNight

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate, IngredientDelegate {
    
    // Displays the list of ingredients
    @IBOutlet weak var recipeTableView: UITableView!
    // Stores ingredients to be displayed and sent to the database
    var ingredients = [String]()
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    
    var selectedImage:UIImage?
    
    // Used for quick access to the posts section of the database
    let ref = Database.database().reference(withPath: "posts")
    var currentUser = ""
    
    // Will store the complete formatted string that is saved to the database
    var ingredientDetails = ""
    
    private var imageSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
        recipeTableView.allowsSelection = false
        
        //Nightmode setup
        view.mixedBackgroundColor = MixedColor(normal: 0xfafafa, night: 0x222222)
        recipeTableView.mixedBackgroundColor = MixedColor(normal: 0xfafafa, night: 0x222222)
        navigationController?.navigationBar.mixedBarTintColor = MixedColor(normal: 0xffffff, night: 0x222222)
        navigationController?.navigationBar.mixedTintColor = MixedColor(normal: 0x0000ff, night: 0xfafafa)
        navigationController?.navigationBar.mixedBarStyle = MixedBarStyle(normal: .default, night: .black)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Check to see if bold text has been enabled; if so, make sure the text is bolded;
        // if not, make sure the text is normal
        if State.bold == true {
            postTextView.font = UIFont.boldSystemFont(ofSize: (postTextView.font?.pointSize)!)
        } else {
            postTextView.font = UIFont.systemFont(ofSize: (postTextView.font?.pointSize)!)
        }
        recipeTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Delegate method; receives the ingredient name and amount from IngredientViewController
    func getIngredientDetails(ingredientToReceive: String) {
        let newIngredient = ingredientToReceive
        // Add the ingredient to the list of ingredients
        ingredients.append(newIngredient)
        
        self.recipeTableView.reloadData()
    }
    
    // UIImagePickerController methods to select an image for the post
    
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
    
    @IBAction func onAddIngredientPressed(_ sender: Any) {
        //FIXME: segue to recipeviewcontroller
    }
    
    @IBAction func onUploadButtonPressed(_ sender: Any) {
        // Formatting the ingredientDetails string
        if ingredients.count == 0 {
            ingredientDetails = "No ingredients specified"
        } else {
            // Clean up the string from the previous post
            ingredientDetails.removeAll()
            
            // Add each ingredient on a new line in the string
            for ingredient in ingredients {
                ingredientDetails.append(ingredient + "\n")
            }
        }
        if imageSelected {
            // Send image data to be stored in Firebase
            if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
                let ratio = profileImg.size.width / profileImg.size.height
                uploadDataToServer(data: imageData, ratio: ratio, caption: postTextView.text!, ingredients: ingredientDetails, onSuccess: {
                    //Clean up post scene and move to home scene
                    self.clean()
                    self.navigationController?.tabBarController?.selectedIndex = 0
                })
            }
        }
    }
    
    func uploadDataToServer(data: Data, ratio: CGFloat, caption: String, ingredients: String, onSuccess: @escaping () -> Void) {
        uploadImageToFirebaseStorage(data: data) { (photoURL) in
            self.sendDataToDatabase(photoUrl: photoURL, ratio: ratio, caption: caption, ingredients: ingredients, onSuccess: onSuccess)
        }
    }
    
    // Store the image data into FirebaseStorage using the Storage reference URL
    func uploadImageToFirebaseStorage(data: Data, onSuccess: @escaping (_ imageUrl: String) -> Void) {
        let photoIdString = NSUUID().uuidString
        // Put image data in Firebase Storage
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
    
    func sendDataToDatabase(photoUrl: String, videoUrl: String? = nil, ratio: CGFloat, caption: String, ingredients: String,  onSuccess: @escaping () -> Void) {
        let newPostId = ref.childByAutoId().key
        let newPostReference = ref.child(newPostId)
        
        // If this user is somehow not the current logged in user, do not upload data
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        // Store post data in the following format
        let currentUserId = currentUser.uid
        // User data is stored in a dictionary
        let dict = ["uid": currentUserId ,"photoUrl": photoUrl, "caption": caption, "likeCount": 0, "ratio": ratio, "ingredients": ingredients] as [String : Any]
        newPostReference.setValue(dict, withCompletionBlock: {
            (error, ref) in
            if error != nil {
                print("senddatatodatabase error != nil")
                return
            }
            
            // Send the new data to the user's home feed
            Api.REF_FEED.child(Api.CURRENT_USER!.uid).child(newPostId).setValue(true)

            // Add new data to current user's list of posts in database
            let myPostRef = Api.REF_MYPOSTS.child(currentUserId).child(newPostId)
            myPostRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    return
                }
            })
            onSuccess()
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
        self.postTextView.text = "Recipe instructions"
        self.postImageView.image = UIImage(named: "placeholder")
        self.imageSelected = false
        self.selectedImage = nil
        self.ingredients.removeAll()
        self.recipeTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showIngredientPopover" {
            let vc = segue.destination
            let controller = vc.popoverPresentationController
            if controller != nil {
                controller?.delegate = self
            }
            if let destination = segue.destination as? IngredientViewController {
                destination.delegate = self
            }
        }
    }
}

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath as IndexPath)
        let row = indexPath.row
        
        // Check to see if bold text has been enabled; if so, make sure the text is bolded;
        // if not, make sure the text is normal
        if State.bold == true {
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: (cell.textLabel?.font.pointSize)!)
        } else {
            cell.textLabel?.font = UIFont.systemFont(ofSize: (cell.textLabel?.font.pointSize)!)
        }
        
        //Nightmode setup
        cell.mixedBackgroundColor = MixedColor(normal: 0xfafafa, night: 0x222222)
        let text = NSMutableAttributedString(string: ingredients[row])
        text.setMixedAttributes([NNForegroundColorAttributeName:
            MixedColor(normal: 0x000000, night: 0xfafafa)],
                                range: NSRange(location: 0, length: text.string.count))
        cell.textLabel?.attributedText = text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.ingredients.remove(at: indexPath.row)
            recipeTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
