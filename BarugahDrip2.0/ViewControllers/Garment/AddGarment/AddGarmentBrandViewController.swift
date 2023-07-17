//
//  AddGarmentBrandViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 16/7/2023.
//

import UIKit

class AddGarmentBrandViewController: UIViewController, UITextFieldDelegate {
    var garmentImage: UIImage? // image of garment
    var garmentName: String? // name of garment
    
    @IBOutlet weak var brandOutlet: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.brandOutlet.delegate = self
        
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
        if segue.identifier == "addSizeSegue"{
            // set destination image to image in image view
            let destination = segue.destination as! AddGarmentSizeViewController
            destination.garmentImage = self.garmentImage
            destination.garmentName = self.garmentName
            destination.garmentBrand = brandOutlet.text
        }
    }
    @IBAction func nextButton(_ sender: Any) {
        guard let brand = brandOutlet.text, brand != "" else {
            return
        }
        
        self.performSegue(withIdentifier: "addSizeSegue", sender: self)
    }
}
