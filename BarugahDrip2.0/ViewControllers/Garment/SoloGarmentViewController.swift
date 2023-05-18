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
    /*
     do{
         
         for data in allGarments {
             let filename = data.image!
             
             if imagePathList.contains(filename){
                 print("Image Already loaded. Skipping image")
                 continue
             }
             
             if let image = loadImageData(filename: filename) {
                 imageList.append(image)
                 imagePathList.append(filename)
                 collectionView.reloadSections([0])
             }
         }
         
     */
    
    
    func loadImageData(filename: String) -> UIImage?{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let imageURL = documentsDirectory.appendingPathComponent(filename)
        let image = UIImage(contentsOfFile: imageURL.path)
        return image
    }
    

}
