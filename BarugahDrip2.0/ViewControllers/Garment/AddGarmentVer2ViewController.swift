//
//  AddGarmentVer2ViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 17/5/2023.
//

import UIKit

class AddGarmentVer2ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var garmentNameOutlet: UITextField!
    
    @IBOutlet weak var garmentBrandOutlet: UITextField!
    
    
    @IBOutlet weak var garmentSizeOutlet: UITextField!
    
    
    @IBOutlet weak var garmentPriceOutlet: UITextField!
    
    
    weak var databaseController: DatabaseProtocol?
        
    var garmentImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        garmentNameOutlet.delegate = self
        garmentBrandOutlet.delegate = self
        garmentSizeOutlet.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        imageView.image = garmentImage
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Allows for user to dismiss keyboard when pressing return
        textField.resignFirstResponder()
        return true
    }
        
    @IBAction func addGarmentButton(_ sender: Any) {
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
            
            if let priceDouble = Double(price){
                let _  = databaseController?.addGarment(name: name, price: priceDouble, brand: brand, size: size, numberOfWears: 0, datePurchased: Date(), image: filename)
                print(filename)
            }
            
            databaseController?.cleanup()
            
        } catch {
            displayMessage(title: "Error", message: "\(error)")
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
        

}
