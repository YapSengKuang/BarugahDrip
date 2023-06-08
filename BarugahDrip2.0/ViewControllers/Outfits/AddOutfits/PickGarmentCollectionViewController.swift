//
//  PickGarmentCollectionViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 19/5/2023.
//

import UIKit

class PickGarmentCollectionViewController: UICollectionViewController, DatabaseListener {
    var listenerType: ListenerType = .garment
    weak var databaseController: DatabaseProtocol?
    
    let CELL_IMAGE = "pickGarmentCell"
    var imageList = [UIImage]()
    var imagePathList = [String]()
    var allGarments = [Garment]()
    var selectedGarments = [Garment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        collectionView.backgroundColor = .systemBackground
        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
        
        collectionView.allowsMultipleSelection = true
        
        databaseController?.addListener(listener: self)
        
        
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
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //collectionView.deselectItem(at: indexPath, animated: true)f
        //let cell = collectionView.cellForItem(at: indexPath).
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IMAGE, for: indexPath) as! PickGarmentCollectionViewCell
        
        //collectionView.deselectItem(at: indexPath, animated: true)
        cell.isSelected.toggle()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IMAGE, for: indexPath) as! PickGarmentCollectionViewCell
        
        collectionView.deselectItem(at: indexPath, animated: true)
        cell.isSelected.toggle()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IMAGE, for: indexPath) as! PickGarmentCollectionViewCell
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
    
    func onWearOutfitChange(change: DatabaseChange, wears: [WearInfo]) {
        // nothing
    }
    
    
    @IBAction func nextButton(_ sender: Any) {
        if (collectionView.indexPathsForSelectedItems?.count != 0){
            performSegue(withIdentifier: "addOutfitPhoto", sender: self)
        }else{
            displayMessage(title: "Error", message: "Please add at least 1 garment.")
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addOutfitPhoto"{
            let destination = segue.destination as!AddPhotoOutfitViewController
            for index in collectionView.indexPathsForSelectedItems!{
                selectedGarments.append(allGarments[index.item])
            }
            destination.selectedGarments = selectedGarments
        }
    }
}
