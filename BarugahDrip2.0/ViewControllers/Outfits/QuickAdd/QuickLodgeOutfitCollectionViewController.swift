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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        databaseController?.addListener(listener: self)
        
        do{
            
            for data in allOutfits {
                let filename = data.image!
                
                if imagePathList.contains(filename){
                    continue
                }
                
                if let image = loadImageData(filename: filename) {
                    imageList.append(image)
                    imagePathList.append(filename)
                    collectionView.reloadSections([0])
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(4/9))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item, item])

        let section = NSCollectionLayoutSection(group: group)

        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lodgeQuickAddOutfit"{
            if let cell = sender as? QuickAddOutfitCollectionViewCell,
               let indexPath = collectionView.indexPath(for: cell){
                let controller = segue.destination as! LodgeOutfitViewController
                controller.outfitToLodge = allOutfits[indexPath.item]
            }
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IMAGE, for: indexPath) as! QuickAddOutfitCollectionViewCell
        cell.backgroundColor = .secondarySystemFill
        cell.imageView.image = imageList[indexPath.item]
        return cell
    }
    
    func onGarmentChange(change: DatabaseChange, garments: [Garment]) {
        //nothing
    }
    
    func onOutfitsChange(change: DatabaseChange, outfits: [Outfit]) {
        allOutfits = outfits
    }
    
    func onOutfitGarmentsChange(change: DatabaseChange, garments: [Garment]) {
        //nothing
    }
    
    func onWearOutfitChange(change: DatabaseChange, wears: [WearInfo]) {
        // nothing
    }
    

}
