//
//  GarmentVer2CollectionViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 17/5/2023.
//

import UIKit

class GarmentVer2CollectionViewController: UICollectionViewController, DatabaseListener{
    var listenerType: ListenerType = .garment
    weak var databaseController: DatabaseProtocol?
    
    let CELL_IMAGE = "imageCell"
    var imageList = [UIImage]()
    var imagePathList = [String]()
    var allGarments = [Garment]()

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
            
        }catch{
            print("Unable to Fetch images")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("tapped \(indexPath.item)")
        
    }

    func generateLayout() -> UICollectionViewLayout {
        let imageItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        
        let imageItem = NSCollectionLayoutItem(layoutSize: imageItemSize)
        imageItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let imageGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1/3))
        
        let imageGroup = NSCollectionLayoutGroup.horizontal(layoutSize: imageGroupSize, subitems: [imageItem])
        
        let imageSection = NSCollectionLayoutSection(group: imageGroup)
        
        return UICollectionViewCompositionalLayout(section: imageSection)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IMAGE, for: indexPath) as! GarmentsVer2CollectionViewCell
        cell.backgroundColor = .secondarySystemFill
        cell.imageView.image = imageList[indexPath.item]
        return cell
    }
    
    func onGarmentChange(change: DatabaseChange, garments: [Garment]) {
        allGarments = garments
    }
    
    func onOutfitsChange(change: DatabaseChange, outfits: [Outfit]) {
        //nothing
    }
    
    func onOutfitGarmentsChange(change: DatabaseChange, garments: [Garment]) {
        //nothing
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGarment"{
            if let cell = sender as? GarmentsVer2CollectionViewCell,
               let indexPath = collectionView.indexPath(for: cell){
                let controller = segue.destination as! SoloGarmentViewController
                controller.selectedGarment = allGarments[indexPath.item]
            }
            
        }
    }
    
    
    
}

