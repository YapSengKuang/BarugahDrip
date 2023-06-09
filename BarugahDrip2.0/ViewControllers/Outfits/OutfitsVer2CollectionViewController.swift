//
//  OutfitsVer2CollectionViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 18/5/2023.
//

import UIKit

class OutfitsVer2CollectionViewController: UICollectionViewController, DatabaseListener {
    var listenerType: ListenerType = .outfits
    weak var databaseController: DatabaseProtocol?
    var indicator = UIActivityIndicatorView()
    let CELL_IMAGE = "outfitCell"
    var imageList = [UIImage]()
    var imagePathList = [String]()
    var allOutfits = [Outfit]()
    var outfitToDelete: Outfit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        collectionView.backgroundColor = .systemBackground
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
        
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
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
            
            for data in allOutfits {
                let filename = data.image!
                
                if imagePathList.contains(filename){
//                    print("Image Already loaded. Skipping image")
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
        
        imageList.remove(at: index!)
        imagePathList.remove(at: index!)
        databaseController?.deleteOutfit(outfit: outfit)
        databaseController?.cleanup()
        collectionView.reloadData()
        print("has been deleted")
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOutfit"{
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
            let controller = segue.destination as! PickGarmentCollectionViewController
            controller.hidesBottomBarWhenPushed = true
            
        }
    }
 
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imageList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO: Implement
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IMAGE, for: indexPath) as! OutfitsVer2CollectionViewCell
        cell.backgroundColor = .secondarySystemFill
        cell.imageView.image = imageList[indexPath.item]
        return cell
    }
    
    func onGarmentChange(change: DatabaseChange, garments: [Garment]) {
        //nothing
    }
    
    func onOutfitsChange(change: DatabaseChange, outfits: [Outfit]) {
        allOutfits = outfits
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
