//
//  GarmentsTableViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 26/5/2023.
//

import UIKit

class GarmentsTableViewController: UITableViewController, DatabaseListener {
    let CELL_ID = "garmentOutfitCell" // Cell Identifier
    var listenerType: ListenerType = .outfit // Listener type
    var garmentsToShow = [Garment]() // Garments that make up the Outfit
    var imageList = [UIImage]() // image list of garments
    var imagePathList = [String]() // image pathList of garment
    weak var databaseController: DatabaseProtocol? // reference to database
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // connect database controller
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return garmentsToShow.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /**
         assign cell to garment information
         */
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! GarmentOutfitTableViewCell
        let garment = garmentsToShow[indexPath.row]
        cell.Brand.text = garment.brand
        cell.name.text = garment.name
        cell.garmentImageView.image = imageList[indexPath.row]

        return cell
    }

    func onGarmentChange(change: DatabaseChange, garments: [Garment]) {
        //nothing
    }
    
    func onOutfitsChange(change: DatabaseChange, outfits: [Outfit]) {
        //nothing
    }
    
    func onOutfitGarmentsChange(change: DatabaseChange, garments: [Garment]) {
        /**
         Method is called when there are changes in Garments for this outfit
         */
        
        // get garments from database
        garmentsToShow = garments
        tableView.reloadData()
    }
    
    func onWearOutfitChange(change: DatabaseChange, wears: [WearInfo]) {
        //nothing
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /**
         Method is called when view appears
         */
        super.viewWillAppear(animated)
        // add listener
        databaseController?.addListener(listener: self)
        // Get images
        do{
            
            for data in garmentsToShow {
                let filename = data.image!
                if imagePathList.contains(filename){
                    continue
                }
                if let image = loadImageData(filename: filename) {
                    imageList.append(image)
                    imagePathList.append(filename)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        /**
         Method is called when view closes
         */
        super.viewWillDisappear(animated)
        
        // remove listener
        databaseController?.removeListener(listener: self)
    }
}
