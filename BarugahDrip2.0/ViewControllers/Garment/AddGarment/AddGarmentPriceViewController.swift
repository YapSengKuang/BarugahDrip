//
//  AddGarmentPriceViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 16/7/2023.
//

import UIKit

class AddGarmentPriceViewController: UIViewController, UITextFieldDelegate {
    var garmentImage: UIImage? // image of garment
    var garmentName: String? // name of garment
    var garmentBrand: String? // brand of garment
    var garmentSize: String? // size of garment
    weak var databaseController: DatabaseProtocol? // database reference
    @IBOutlet weak var priceOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.priceOutlet.delegate = self
        
        // hide keyboard when tapped around
        self.hideKeyboardWhenTappedAround()
        
        // set database controller
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        /**
         Method to allow for users to progress to next step
         */
        
        nextButton(self)
        
        return true
    }

    @IBAction func nextButton(_ sender: Any) {
        guard let price = priceOutlet.text, price != "" else {
            return
        }
        
        // error handling
        guard let name = self.garmentName, name != "" else {
            return
        }
        
        guard let brand = self.garmentBrand, brand != "" else {
            return
        }
        
        guard let size = self.garmentSize, size != "" else {
            return
        }
        
        guard let image = garmentImage else {
            return
        }
        
        // Compress image
        
        let timestamp = UInt(Date().timeIntervalSince1970)
        let filename = "\(timestamp).jpg"
        
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            displayMessage(title: "Error", message: "Image data could not be compressed")
            return
        }
        
        let pathsList = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = pathsList[0]
        let imageFile = documentDirectory.appendingPathComponent(filename)
    
        // add to coredata
        do {
            try data.write(to: imageFile)
            
            if let priceDouble = Double(price){
                let _  = databaseController?.addGarment(name: name, price: priceDouble, brand: brand, size: size, numberOfWears: 0, datePurchased: Date(), image: filename)
                print(filename)
            }
            
            //displayMessage(title: "Success", message: "Successfully added this garment.")
            
            databaseController?.cleanup()
            
            // pop to root view
            navigationController?.popToRootViewController(animated: true)
        } catch {
            displayMessage(title: "Error", message: "\(error)")
        }
        
    }
}
