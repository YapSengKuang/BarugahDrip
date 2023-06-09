//
//  AddOutfitViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 19/5/2023.
//

import UIKit

class AddOutfitViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var imageView: UIImageView! // image view of outfit
    @IBOutlet weak var lodgeOutfitSwitch: UISwitch! // switch for user to choose if they want to lodge the outfit
    var selectedImage: UIImage? // image of Outfit
    @IBOutlet weak var outfitName: UITextField! // outfit name label
    var selectedGarments = [Garment]() // selected garments for outfit
    weak var databaseController: DatabaseProtocol? // database reference
    var createdOutfit: Outfit? // outfit that is created
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set delegate to self to dismiss keyboard
        outfitName.delegate = self

        // connect database reference
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        // set imageview to outfit image
        imageView.image = selectedImage
        
        // dismiss keyboard when users tap around
        self.hideKeyboardWhenTappedAround() 

    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        /**
         Allows for users to dismiss keyboard when return is pressed
         */
        // Allows for user to dismiss keyboard when pressing return
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func addOutfitButton(_ sender: Any) {
        /**
         Button allows for users to create an outfit to coredata
         */
        
        // error handling
        guard let name = outfitName.text, name != "" else {
            return
        }
        guard let image = imageView.image else {
            return
        }
        
        // Compress image and get pathlist
        let timestamp = UInt(Date().timeIntervalSince1970)
        let filename = "\(timestamp).jpg"
        
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            displayMessage(title: "Error", message: "Image data could not be compressed")
            return
        }
        let pathsList = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = pathsList[0]
        let imageFile = documentDirectory.appendingPathComponent(filename)
    
        do {
            try data.write(to: imageFile)
            
            // add outfit to database
            let outfit  = (databaseController?.addOutfit(price: 0.00, wears: 0, outfitName: name, image: filename))!
            createdOutfit = outfit
            
            // add garments to outfit in database
            for garment in selectedGarments{
                let _ = databaseController?.addGarmentToOutfit(garment: garment, outfit: outfit)
            }
            
            // save any changes to coredata
            databaseController?.cleanup()
            
        } catch {
            displayMessage(title: "Error", message: "\(error)")
        }
        
        // segue to lodge view if switch is on
        
        if lodgeOutfitSwitch.isOn {
            self.performSegue(withIdentifier: "lodgeOutfit", sender: self)
        }else{
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lodgeOutfit"{
            // set outfit to lodge to local outfit
            let destination = segue.destination as! LodgeOutfitViewController
            destination.outfitToLodge = self.createdOutfit
        }
    }
}
