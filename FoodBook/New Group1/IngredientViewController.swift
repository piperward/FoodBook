//
//  IngredientViewController.swift
//  FoodBook
//
//  Created by Kyle McCarver on 4/22/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import UIKit

protocol IngredientDelegate {
    func getIngredientDetails(ingredientToReceive: String)
}

class IngredientViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var measurementPicker: UIPickerView!
    
    let measurementChoices = ["", "Cup(s)", "Tbsp", "tsp", "lb", "oz", "fl. oz"]
    var wholeNumberChoices = [""]
    let fractionChoices = ["", "1/8", "1/4", "1/3", "1/2", "2/3", "3/4"]
    
    var selectedMeasurement = ""
    var selectedWholeNumber = ""
    var selectedFraction = ""
    
    var delegate: IngredientDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        measurementPicker.dataSource = self
        measurementPicker.delegate = self
        
        //Setting up picker
        for i in 1...10 {
            wholeNumberChoices.append("\(i)")
        }
        
        selectedMeasurement = measurementChoices[0]
        selectedWholeNumber = wholeNumberChoices[0]
        selectedFraction = fractionChoices[0]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Send ingredient details to post view controller
    func sendIngredientDetails() {
        var ingredient = ""
        if selectedWholeNumber != "" {
            ingredient.append("\(selectedWholeNumber) ")
        }
        if selectedFraction != "" {
            ingredient.append("\(selectedFraction) ")
        }
        if selectedMeasurement != "" {
            ingredient.append("\(selectedMeasurement) ")
        }
        ingredient.append("\(nameTextField.text!)")
        delegate.getIngredientDetails(ingredientToReceive: ingredient)
    }
    
    //Sends ingredient details and brings user back to previoius controller
    @IBAction func onSaveButtonPressed(_ sender: Any) {
        if nameTextField.text! != "" {
            sendIngredientDetails()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onCancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return wholeNumberChoices.count
        } else if component == 1 {
            return fractionChoices.count
        }
        return measurementChoices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return wholeNumberChoices[row]
        } else if component == 1 {
            return fractionChoices[row]
        }
        return measurementChoices[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedWholeNumber = wholeNumberChoices[pickerView.selectedRow(inComponent: 0)]
        selectedFraction = fractionChoices[pickerView.selectedRow(inComponent: 1)]
        selectedMeasurement = measurementChoices[pickerView.selectedRow(inComponent: 2)]
    }
}
