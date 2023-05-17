//
//  AddGarmentViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 16/5/2023.
//

import UIKit

class AddGarmentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var garmentNameOutlet: UITextField!
    
    @IBOutlet weak var garmentBrandOutlet: UITextField!
    
    @IBOutlet weak var garmentSizeOutlet: UITextField!
    
    @IBOutlet weak var garmentPriceOutlet: UITextField!
    
    weak var databaseController: DatabaseProtocol?
    
    var garmentImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        imageView.image = garmentImage
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
            }
            
            databaseController?.cleanup()
            
        } catch {
            displayMessage(title: "Error", message: "\(error)")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
