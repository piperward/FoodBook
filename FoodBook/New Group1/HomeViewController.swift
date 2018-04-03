//
//  HomeViewController.swift
//  FoodBook
//
//  Created by Kyle McCarver on 3/20/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import UIKit
import Firebase

public var postList = [Post]()

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var postCellIdentifier = "postCellIdentifier"
    let ref = Database.database().reference(withPath: "posts")
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        // Attach a listener to receive updates whenever the posts endpoint is modified
        ref.observe(.value, with: { snapshot in
            // Store the latest version of the data in a local variable inside the listener’s closure.
            var newPosts: [Post] = []
            // Loop through the posts provided by the snapshot that the closure returned, creating list
            for item in snapshot.children {
                let post = Post(snapshot: item as! DataSnapshot)
                newPosts.append(post)
            }
            
            // Reassign items to the latest version of the data, reload the table view
            postList = newPosts
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TableView Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: postCellIdentifier, for: indexPath as IndexPath) as! PostTableViewCell
        let currentPost = postList[indexPath.row]
        
        //Use photo URL to set image view
        let url = URL(string: currentPost.photoUrl)
        if let data = try? Data(contentsOf: url!) {
            cell.postImageView.image = UIImage(data: data)!
        }
        
        //Set caption and username
        cell.postDescriptionLabel.text = currentPost.caption
        cell.postNameLabel.text = "Jane Doe"
        
        return cell
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
