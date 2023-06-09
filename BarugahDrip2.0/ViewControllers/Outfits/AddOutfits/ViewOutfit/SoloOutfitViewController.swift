//
//  SoloOutfitViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 19/5/2023.
//

import UIKit

class SoloOutfitViewController: UIViewController, DatabaseListener{
    var listenerType: ListenerType = .wear // listener type
    @IBOutlet weak var imageView: UIImageView! // selected outfit picture
    @IBOutlet weak var outfitName: UILabel! // selected outfit name
    var selectedOutfit: Outfit? // instance of selected outfit
    var selectedOutfitWears: [WearInfo]? // list of WearInfo of this selected Outfit
    weak var outfitsViewController: OutfitsVer2CollectionViewController? // reference to outfits viewController to call functions
    weak var databaseController: DatabaseProtocol? // reference to database
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // connect database controller
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        // assign the image and text to information from outfit
        outfitName.text = selectedOutfit?.name
        imageView.image = loadImageData(filename: (selectedOutfit?.image!)!)
        
        // round corners of the image
        imageView.layer.cornerRadius = 8.0
        imageView.layer.masksToBounds = true
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
        /**
         Called when there is changes in the wears for this outfit
         */
        selectedOutfitWears = wears
    }
    
    @IBAction func viewChart(_ sender: Any) {
        /**
         Button that allows user to view a chart containing information on the months they have worn this outfit
         */
        
        // Segue to chart view
        self.performSegue(withIdentifier: "chartSeg", sender: self)
    }
    
    @IBAction func lodge(_ sender: Any) {
        /**
         Button that allows users to lodge an outfit
         */
        
        // segue to lodgeOutfit view
        self.performSegue(withIdentifier: "lodgeCreatedOutfit", sender: self)
    }
    
    @IBAction func viewGarments(_ sender: Any) {
        /**
         Button to allow user to view the garments that make up the outfit
         */
        
        // segue to viewGarment view
        self.performSegue(withIdentifier: "viewGarmentFromOutfit", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chartSeg"{
            // Set the dataset of the chart view to the list of wears
            
            let destination = segue.destination as! ChartViewController
            destination.dataset = selectedOutfitWears
        }
        if segue.identifier == "lodgeCreatedOutfit"{
            // set the outfit to lodge as the selected outfit
            
            let destination = segue.destination as! LodgeOutfitViewController
            destination.outfitToLodge = selectedOutfit
        }
        if segue.identifier == "viewGarmentFromOutfit"{
            _ = segue.destination as! GarmentsTableViewController
        }
    }
    
    @IBAction func deleteOutfit(_ sender: Any) {
        /**
         Button that allows users to delete this outfit
         */
        
        // call deleteItem function from outfitsViewController
        outfitsViewController?.deleteItem(outfit: selectedOutfit!)

        // pop this view controller to go back to the outfitsViewController
        navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // add listener to database
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // remove listener when view closes
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
}


