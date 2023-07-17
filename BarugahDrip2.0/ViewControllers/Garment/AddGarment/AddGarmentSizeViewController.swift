//
//  AddGarmentSizeViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 16/7/2023.
//

import UIKit

class AddGarmentSizeViewController: UIViewController, UITextFieldDelegate {
    var garmentImage: UIImage? // image of garment
    var garmentName: String? // name of garment
    var garmentBrand: String? // brand of garment
    
    @IBOutlet weak var sizeOutlet: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.sizeOutlet.delegate = self
        
        // hide keyboard when tapped around
        self.hideKeyboardWhenTappedAround()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        /**
         Method to allow for users to progress to next step
         */
        
        nextButton(self)
        
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addPriceSegue"{
            // set destination image to image in image view
            let destination = segue.destination as! AddGarmentPriceViewController
            destination.garmentImage = self.garmentImage
            destination.garmentName = self.garmentName
            destination.garmentBrand = self.garmentBrand
            destination.garmentSize = sizeOutlet.text
        }
    }
    @IBAction func nextButton(_ sender: Any) {
        guard let size = sizeOutlet.text, size != "" else {
            return
        }
        
        self.performSegue(withIdentifier: "addPriceSegue", sender: self)
    }
}
