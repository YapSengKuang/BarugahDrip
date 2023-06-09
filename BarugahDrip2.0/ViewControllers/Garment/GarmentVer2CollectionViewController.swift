//
//  GarmentVer2CollectionViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 17/5/2023.
//

import UIKit

class GarmentVer2CollectionViewController: UICollectionViewController, DatabaseListener{
    var listenerType: ListenerType = .garment // listener type
    weak var databaseController: DatabaseProtocol? // database reference
    var indicator = UIActivityIndicatorView()
    let CELL_IMAGE = "imageCell" // cell identifier
    var imageList = [UIImage]() // image list of garment
    var imagePathList = [String]() // image path list of garment
    var allGarments = [Garment]() // list of garments

    override func viewDidLoad() {
        super.viewDidLoad()
        
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

        // connect database controller
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        // set collection view layout
        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // add listener
        databaseController?.addListener(listener: self)
    }
    
    func getImages() async{
        /**
         Function is responsible for getting Imageslist and path list
         */
        do{
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
            }
            
            // get image for each garment
            for data in allGarments {
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // remove listener when view closes
        databaseController?.removeListener(listener: self)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /**
         Method for when item is selected in collection view
         */
        collectionView.deselectItem(at: indexPath, animated: true)
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
         Configure each item in collectionview with garmentimage
         */
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IMAGE, for: indexPath) as! GarmentsVer2CollectionViewCell
        cell.imageView.image = imageList[indexPath.item]
        return cell
    }
    
    func onGarmentChange(change: DatabaseChange, garments: [Garment]) {
        /**
         Method is for when there is a change in garments
         */
        
        // set all garments
        allGarments = garments
        
        // get images
        indicator.startAnimating()
        Task{
            await getImages()
        }
    }
    
    func onOutfitsChange(change: DatabaseChange, outfits: [Outfit]) {
        //nothing
    }
    
    func onOutfitGarmentsChange(change: DatabaseChange, garments: [Garment]) {
        //nothing
    }
    
    func onWearOutfitChange(change: DatabaseChange, wears: [WearInfo]) {
        // nothing
    }
    
    func deleteGarment(garment: Garment){
         /**
          Deletes and item from this view
          */
        
        // Get index of item to delete
        
        var index: Int?
        var counter = 0
        for i in allGarments{
            if i == garment{
                index = counter
            }
            counter+=1
        }
        
        // remove image at index
        imageList.remove(at: index!)
        imagePathList.remove(at: index!)
        
        // delete from database
        databaseController?.deleteGarment(garment: garment)
        databaseController?.cleanup()
        
        // reload collection view
        collectionView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGarment"{
            if let cell = sender as? GarmentsVer2CollectionViewCell,
               // set controller garment to selected garment and hide bottom bar
               let indexPath = collectionView.indexPath(for: cell){
                let controller = segue.destination as! SoloGarmentViewController
                controller.selectedGarment = allGarments[indexPath.item]
                controller.outfitsViewController = self
                controller.hidesBottomBarWhenPushed = true
            }
        }
        if segue.identifier == "createGarmentSegue"{
            // hide bottom bar
            let controller = segue.destination as! AddGarmentPhotoVer2ViewController
            controller.hidesBottomBarWhenPushed = true
        }
    }
}

