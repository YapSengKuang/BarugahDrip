//
//  SoloOutfitViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 19/5/2023.
//

import UIKit

class SoloOutfitViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var outfitName: UILabel!
    
    var selectedOutfit: Outfit?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        outfitName.text = selectedOutfit?.name
        imageView.image = loadImageData(filename: (selectedOutfit?.image!)!)

        // Do any additional setup after loading the view.
    }
    

    
}

extension UIViewController{
    func loadImageData(filename: String) -> UIImage?{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let imageURL = documentsDirectory.appendingPathComponent(filename)
        let image = UIImage(contentsOfFile: imageURL.path)
        return image
    }
}
