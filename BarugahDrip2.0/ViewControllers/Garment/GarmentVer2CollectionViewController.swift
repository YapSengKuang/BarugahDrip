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
    
    var indicator = UIActivityIndicatorView()
    
    let CELL_IMAGE = "imageCell"
    var imageList = [UIImage]()
    var imagePathList = [String]()
    var allGarments = [Garment]()

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

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        collectionView.backgroundColor = .systemBackground
        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
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
            
            for data in allGarments {
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
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("tapped \(indexPath.item)")
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IMAGE, for: indexPath) as! GarmentsVer2CollectionViewCell
        cell.backgroundColor = .secondarySystemFill
        cell.imageView.image = imageList[indexPath.item]
        return cell
    }
    
    func onGarmentChange(change: DatabaseChange, garments: [Garment]) {
        allGarments = garments
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
        
        imageList.remove(at: index!)
        imagePathList.remove(at: index!)
        databaseController?.deleteGarment(garment: garment)
        databaseController?.cleanup()
        collectionView.reloadData()
        print("has been deleted")
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGarment"{
            if let cell = sender as? GarmentsVer2CollectionViewCell,
               let indexPath = collectionView.indexPath(for: cell){
                let controller = segue.destination as! SoloGarmentViewController
                controller.selectedGarment = allGarments[indexPath.item]
                controller.outfitsViewController = self
                controller.hidesBottomBarWhenPushed = true
            }
            
        }
        
        if segue.identifier == "createGarmentSegue"{

            let controller = segue.destination as! AddGarmentPhotoVer2ViewController
            
            controller.hidesBottomBarWhenPushed = true
            
            
        }
    }
    
    
    
}

