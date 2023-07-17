//
//  AddGarmentNameViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 16/7/2023.
//

import UIKit

class AddGarmentNameViewController: UIViewController,UITextFieldDelegate {
    var garmentImage: UIImage? // image of garment
    
    @IBOutlet weak var nameOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameOutlet.delegate = self
        
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
        if segue.identifier == "addBrandSegue"{
            // set destination image to image in image view
            let destination = segue.destination as! AddGarmentBrandViewController
            destination.garmentImage = self.garmentImage
            destination.garmentName = nameOutlet.text
        }
    }
    @IBAction func nextButton(_ sender: Any) {
        guard let name = nameOutlet.text, name != "" else {
            return
        }
        
        self.performSegue(withIdentifier: "addBrandSegue", sender: self)
    }
}
