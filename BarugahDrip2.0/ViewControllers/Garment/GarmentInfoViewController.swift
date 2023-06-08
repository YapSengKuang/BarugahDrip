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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        sheetPresentationController.delegate = self
        sheetPresentationController.selectedDetentIdentifier = .medium
        sheetPresentationController.prefersGrabberVisible = true
        sheetPresentationController.detents = [
            .medium()]
        // Do any additional setup after loading the view.
    }
}
