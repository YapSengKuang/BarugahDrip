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
    var selectedGarment: Garment? // garment to get info out of
    @IBOutlet weak var priceLabel: UIButton! // price label of garment
    @IBOutlet weak var pricePerWearLabel: UIButton! // price per wear label of garment
    @IBOutlet weak var sizeLabel: UIButton! // size label of garment
    @IBOutlet weak var wearsLabel: UIButton! // number of wears of garment
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the sheet presentation controller so that it only goes half way
        
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
