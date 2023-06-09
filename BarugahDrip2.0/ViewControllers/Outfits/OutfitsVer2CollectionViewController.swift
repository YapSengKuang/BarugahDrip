//
//  OutfitsVer2CollectionViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 18/5/2023.
//

import UIKit

class OutfitsVer2CollectionViewController: UICollectionViewController, DatabaseListener {
    var listenerType: ListenerType = .outfits // listener type
    weak var databaseController: DatabaseProtocol? // database reference
    var indicator = UIActivityIndicatorView()
    let CELL_IMAGE = "outfitCell" // cell identifier
    var imageList = [UIImage]() // outfit image list
    var imagePathList = [String]() // pathlist of outfit image
    var allOutfits = [Outfit]() // list of outfits
    var outfitToDelete: Outfit? // outfit to delete
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set database controller
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        // set collectionview layout
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
        // add listener
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // remove listener when view closes
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
            
            // get image and image path for each outfit
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

    func deleteItem(outfit: Outfit){
         /**
          Deletes and item from this view
          */
        
        // Get index of item to delete
        var index: Int?
        var counter = 0
        for i in allOutfits{
            if i == outfit{
                index = counter
            }
            counter+=1
        }
        
        // remove in image list and path list
        imageList.remove(at: index!)
        imagePathList.remove(at: index!)
        
        // remove from database
        databaseController?.deleteOutfit(outfit: outfit)
        databaseController?.cleanup()
        
        // reload collectionview
        collectionView.reloadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOutfit"{
            // set controller outfit var to be selected outfit
            
            if let cell = sender as? OutfitsVer2CollectionViewCell,
               let indexPath = collectionView.indexPath(for: cell){
                let controller = segue.destination as! SoloOutfitViewController
                databaseController?.currentOutfit = allOutfits[indexPath.item]
                controller.selectedOutfit = allOutfits[indexPath.item]
                controller.outfitsViewController = self
                controller.hidesBottomBarWhenPushed = true
            }
        }
        
        if segue.identifier == "pickGarmentSegue"{
            // hide bottom bar
            let controller = segue.destination as! PickGarmentCollectionViewController
            controller.hidesBottomBarWhenPushed = true
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
         return the number of items
         */
        return imageList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /**
         Configure each item in collection view with image
         */
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IMAGE, for: indexPath) as! OutfitsVer2CollectionViewCell
        cell.imageView.image = imageList[indexPath.item]
        return cell
    }
    
    func onGarmentChange(change: DatabaseChange, garments: [Garment]) {
        //nothing
    }
    
    func onOutfitsChange(change: DatabaseChange, outfits: [Outfit]) {
        // set all outfits from database
        allOutfits = outfits
        
        // get images
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
