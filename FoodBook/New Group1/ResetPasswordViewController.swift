//
//  ResetPasswordViewController.swift
//  FoodBook
//
//  Created by Piper Ward on 3/30/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func reset(_ sender: Any) {
    }
    
    @IBAction func signIn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
