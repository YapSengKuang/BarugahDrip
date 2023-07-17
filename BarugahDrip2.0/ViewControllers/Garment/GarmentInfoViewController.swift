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
    @IBOutlet weak var priceLabel: UILabel! // price label of garment
    @IBOutlet weak var pricePerWearLabel: UILabel! // price per wear label of garment
    @IBOutlet weak var sizeLabel: UILabel! // size label of garment
    @IBOutlet weak var wearsLabel: UILabel! // number of wears of garment
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the sheet presentation controller so that it only goes half way
        
        sheetPresentationController.delegate = self
        sheetPresentationController.selectedDetentIdentifier = .medium
        sheetPresentationController.prefersGrabberVisible = true
        sheetPresentationController.detents = [
            .medium()]
        
        // load garment info
        priceLabel.text = "$"+String(format: "%.2f", selectedGarment!.price)
        sizeLabel.text = selectedGarment?.size
        wearsLabel.text = String(selectedGarment!.numberOfWears)
        
        if Double(selectedGarment!.numberOfWears) > 0{
            let pricePerWear = selectedGarment!.price/Double(selectedGarment!.numberOfWears)
        
            pricePerWearLabel.text = "$"+String(format: "%.2f", pricePerWear)
        }else{
            pricePerWearLabel.text = "$"+String(format: "%.2f", selectedGarment!.price)
        }
    }
}
