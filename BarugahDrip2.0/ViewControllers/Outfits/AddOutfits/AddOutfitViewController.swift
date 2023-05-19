//
//  AddOutfitViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 19/5/2023.
//

import UIKit

class AddOutfitViewController: UIViewController{
    @IBOutlet weak var imageView: UIImageView!
    
    var selectedImage: UIImage?
    
    @IBOutlet weak var outfitName: UITextField!
    
    var selectedGarments = [Garment]()
    
    weak var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        imageView.image = selectedImage

    }
    
    @IBAction func addOutfitButton(_ sender: Any) {
        guard let name = outfitName.text, name != "" else {
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
            
            
            let outfit  = (databaseController?.addOutfit(price: 0.00, wears: 0, outfitName: name, image: filename))!
            
            for garment in selectedGarments{
                let _ = databaseController?.addGarmentToOutfit(garment: garment, outfit: outfit)
            }
            
            databaseController?.cleanup()
            
        } catch {
            displayMessage(title: "Error", message: "\(error)")
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
    
}
