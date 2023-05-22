//
//  SoloGarmentViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 17/5/2023.
//

import UIKit

class SoloGarmentViewController: UIViewController {
    var selectedGarment: Garment?
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var garmentNameOutlet: UILabel!
    
    @IBOutlet weak var brandNameOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        garmentNameOutlet.text = selectedGarment?.name
        brandNameOutlet.text = selectedGarment?.brand
        imageView.image = loadImageData(filename: (selectedGarment?.image!)!)
    
    }

}
