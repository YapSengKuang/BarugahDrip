//
//  SoloOutfitViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 19/5/2023.
//

import UIKit

class SoloOutfitViewController: UIViewController, DatabaseListener {
    var listenerType: ListenerType = .wear
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var outfitName: UILabel!
    
    var selectedOutfit: Outfit?
    var selectedOutfitWears: [WearInfo]?
    
    weak var outfitsViewController: OutfitsVer2CollectionViewController?
    weak var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        
        outfitName.text = selectedOutfit?.name
        imageView.image = loadImageData(filename: (selectedOutfit?.image!)!)
        
        
        imageView.layer.cornerRadius = 8.0
        imageView.layer.masksToBounds = true
        
        
        // Do any additional setup after loading the view.
    }
    
    func onGarmentChange(change: DatabaseChange, garments: [Garment]) {
        //nothing
    }

    func onOutfitsChange(change: DatabaseChange, outfits: [Outfit]) {
        //nothing
    }

    func onOutfitGarmentsChange(change: DatabaseChange, garments: [Garment]) {
        //nothing
    }

    func onWearOutfitChange(change: DatabaseChange, wears: [WearInfo]) {
        selectedOutfitWears = wears
    }
    
    @IBAction func viewChart(_ sender: Any) {
        
        
        self.performSegue(withIdentifier: "chartSeg", sender: self)
        
    }
    
    @IBAction func lodge(_ sender: Any) {
        
        self.performSegue(withIdentifier: "lodgeCreatedOutfit", sender: self)
    }
    
    @IBAction func viewGarments(_ sender: Any) {
        self.performSegue(withIdentifier: "viewGarmentFromOutfit", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chartSeg"{
            let destination = segue.destination as! ChartViewController
            destination.dataset = selectedOutfitWears
        }
        if segue.identifier == "lodgeCreatedOutfit"{
            let destination = segue.destination as! LodgeOutfitViewController
            destination.outfitToLodge = selectedOutfit
        }
        if segue.identifier == "viewGarmentFromOutfit"{
            _ = segue.destination as! GarmentsTableViewController
            
            
        }
    }
    
    @IBAction func deleteOutfit(_ sender: Any) {
        outfitsViewController?.deleteItem(outfit: selectedOutfit!)

        
        navigationController?.popViewController(animated: true)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        databaseController?.addListener(listener: self)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
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
