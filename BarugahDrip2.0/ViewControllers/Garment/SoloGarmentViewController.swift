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
    
    weak var outfitsViewController: GarmentVer2CollectionViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        garmentNameOutlet.text = selectedGarment?.name
        brandNameOutlet.text = selectedGarment?.brand
        imageView.image = loadImageData(filename: (selectedGarment?.image!)!)
        
        imageView.layer.cornerRadius = 8.0
        imageView.layer.masksToBounds = true
    
    }

    @IBAction func deleteGarment(_ sender: Any) {
        outfitsViewController?.deleteGarment(garment: selectedGarment!)

        
        navigationController?.popViewController(animated: true)
        
    }
}
