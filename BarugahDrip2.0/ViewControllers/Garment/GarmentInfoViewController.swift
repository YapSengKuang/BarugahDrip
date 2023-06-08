//
//  GarmentInfoViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 9/6/2023.
//

import UIKit

class GarmentInfoViewController: UIViewController, UISheetPresentationControllerDelegate {
    
    override var sheetPresentationController: UISheetPresentationController{
        presentationController as! UISheetPresentationController
    }
    
    var selectedGarment: Garment?
    
    @IBOutlet weak var priceLabel: UIButton!
    
    @IBOutlet weak var pricePerWearLabel: UIButton!
    
    @IBOutlet weak var sizeLabel: UIButton!
    
    @IBOutlet weak var wearsLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sheetPresentationController.delegate = self
        sheetPresentationController.selectedDetentIdentifier = .medium
        sheetPresentationController.prefersGrabberVisible = true
        sheetPresentationController.detents = [
            .medium()]
        // load garment info
        
        priceLabel.setTitle("$"+String(selectedGarment!.price), for: .normal)
        
        sizeLabel.setTitle(selectedGarment?.size, for: .normal)
        
        wearsLabel.setTitle(String(selectedGarment!.numberOfWears), for: .normal)
        
        
        if Double(selectedGarment!.numberOfWears) > 0{
            let pricePerWear = selectedGarment!.price/Double(selectedGarment!.numberOfWears)
            pricePerWearLabel.setTitle("$"+String(pricePerWear), for: .normal)
        }else{
            pricePerWearLabel.setTitle("$"+String(selectedGarment!.price), for: .normal)
        }
    }
}
