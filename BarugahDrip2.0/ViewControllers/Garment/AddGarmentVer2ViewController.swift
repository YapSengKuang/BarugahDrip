//
//  AddGarmentVer2ViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 17/5/2023.
//

import UIKit

class AddGarmentVer2ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var imageView: UIImageView! // image view of garment
    @IBOutlet weak var garmentNameOutlet: UITextField! // text field of garment name
    @IBOutlet weak var garmentBrandOutlet: UITextField! // text field of brand name
    @IBOutlet weak var garmentSizeOutlet: UITextField! // text field of size
    @IBOutlet weak var garmentPriceOutlet: UITextField! // text field of price
    weak var databaseController: DatabaseProtocol? // database reference
    var garmentImage: UIImage? // image of garment
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set delegate to self to dismiss keyboard
        garmentNameOutlet.delegate = self
        garmentBrandOutlet.delegate = self
        garmentSizeOutlet.delegate = self
        
        // hide keyboard when tapped around
        self.hideKeyboardWhenTappedAround()
        
        // set database controller
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        // set image view to garment image
        imageView.image = garmentImage
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        /**
         Method to allow for users to dismiss keyboard
         */
        
        let nextTag = textField.tag + 1

        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return true
    }
        
    @IBAction func addGarmentButton(_ sender: Any) {
        /**
         Button to add garment to coredata
         */
        
        // error handling
        guard let name = garmentNameOutlet.text, name != "" else {
            return
        }
        
        guard let brand = garmentBrandOutlet.text, brand != "" else {
            return
        }
        
        guard let size = garmentSizeOutlet.text, size != "" else {
            return
        }
        
        guard let price = garmentPriceOutlet.text, price != "" else {
            return
        }
        
        guard let image = imageView.image else {
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
            
            databaseController?.cleanup()
        } catch {
            displayMessage(title: "Error", message: "\(error)")
        }
        // pop to root view
        navigationController?.popToRootViewController(animated: true)
    }
}
