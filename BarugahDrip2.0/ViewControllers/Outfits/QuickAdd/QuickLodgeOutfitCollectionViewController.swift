//
//  QuickLodgeOutfitCollectionViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 9/6/2023.
//

import UIKit

class QuickLodgeOutfitCollectionViewController: UICollectionViewController, DatabaseListener {
    
    var listenerType: ListenerType = .outfits
    weak var databaseController: DatabaseProtocol?
    let CELL_IMAGE = "outfitCell" // cell identifier
    var imageList = [UIImage]() // image list for outfits
    var imagePathList = [String]() // image pathlist for outfits
    var allOutfits = [Outfit]() // list of outfits
    var outfitToDelete: Outfit? // outfit user wants to delete
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // connect databasecontroller
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        // generate layout of collection view
        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
        
        // Add a loading indicator view
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo:
                                                view.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo:
                                                view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // add listener to database controller
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove listener when view closes
        databaseController?.removeListener(listener: self)
    }
    
    func getImages() async{
        /**
         Responsible for getting the imagePath and imageList
         */
        do{
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
            }
            
            // go through all outfits and get image and image path
            // skip if imagepath list already exist in local list
            
            for data in allOutfits {
                let filename = data.image!
                
                if imagePathList.contains(filename){
                    continue
                }
                
                DispatchQueue.main.async {
                    if let image = self.loadImageData(filename: filename) {
                        
                        self.imageList.append(image)
                        self.imagePathList.append(filename)
                        self.collectionView.reloadSections([0])
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lodgeQuickAddOutfit"{
            // Send the outfit instance that user wants to lodge to LodgeOutfitViewController
            
            if let cell = sender as? QuickAddOutfitCollectionViewCell,
               let indexPath = collectionView.indexPath(for: cell){
                let controller = segue.destination as! LodgeOutfitViewController
                controller.outfitToLodge = allOutfits[indexPath.item]
            }
        }
    }
 
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        /**
         return the number of sections
         */
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /**
         return the number of items in collection view
         */
        return imageList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       /**
        Assign cell in indexpath
        */
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IMAGE, for: indexPath) as! QuickAddOutfitCollectionViewCell
        cell.backgroundColor = .secondarySystemFill
        cell.imageView.image = imageList[indexPath.item]
        return cell
    }
    
    func onGarmentChange(change: DatabaseChange, garments: [Garment]) {
        //nothing
    }
    
    func onOutfitsChange(change: DatabaseChange, outfits: [Outfit]) {
        /**
         Called when there is change in the Outfits database
         */
        
        // assign local allOutfits to database
        allOutfits = outfits
        
        // start animating spinner while getting images
        indicator.startAnimating()
        Task{
            await getImages()
        }
    }
    
    func onOutfitGarmentsChange(change: DatabaseChange, garments: [Garment]) {
        //nothing
    }
    
    func onWearOutfitChange(change: DatabaseChange, wears: [WearInfo]) {
        // nothing
    }
}
