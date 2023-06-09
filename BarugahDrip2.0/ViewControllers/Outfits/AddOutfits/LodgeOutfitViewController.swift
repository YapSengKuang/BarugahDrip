//
//  LodgeOutfitViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 26/5/2023.
//

import UIKit

class LodgeOutfitViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var occasionOutlet: UITextField! // Text Field for occasion
    @IBOutlet weak var tempOutlet: UITextField! // Tempurature for outfit
    @IBOutlet weak var datePicker: UIDatePicker! // date of lodge
    weak var databaseController: DatabaseProtocol? // database reference
    var outfitToLodge: Outfit? // outfit to lodge
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide keyboard if tapped around
        self.hideKeyboardWhenTappedAround()
        
        // set delegate to self for return to dismiss
        occasionOutlet.delegate = self

        // connect database controller
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
    }
    
    @IBAction func nextButton(_ sender: Any) {
        /**
         Button allows for users to lodge outfit in coredata and go back to root view
         */
        
        // Error handling
        guard let temp = Int(tempOutlet.text!) else {
            return
        }
        guard let occasion = occasionOutlet.text, occasion != "" else {
            return
        }
    
        // create wear info
        let wearInfo = (databaseController?.addWear(date: datePicker.date, tempCelcuis: temp, event: occasion))!
        
        // add wear info to outfit
        let _ = databaseController?.addWearToOutfit(outfit: outfitToLodge!, wearInfo: wearInfo)
        
        // incrememt the wears variable in each garment in outfit
        databaseController?.incrementGarmentInSelectOutfit(outfit: outfitToLodge!)
        
        // pop to root view
        navigationController?.popToRootViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        /**
         Method allows for users to dismiss keyboard when return key is pressed
         */
        // Allows for user to dismiss keyboard when pressing return
        textField.resignFirstResponder()
        return true
    }
}
