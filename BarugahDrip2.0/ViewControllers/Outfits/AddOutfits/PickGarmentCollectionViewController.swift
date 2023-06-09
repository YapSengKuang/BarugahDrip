//
//  PickGarmentCollectionViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 19/5/2023.
//

import UIKit

class PickGarmentCollectionViewController: UICollectionViewController{
    weak var databaseController: DatabaseProtocol? // database reference
    var indicator = UIActivityIndicatorView()
    let CELL_IMAGE = "pickGarmentCell" // cell identifier
    var imageList = [UIImage]() // image list of garments
    var imagePathList = [String]() // image path list of garments
    var allGarments = [Garment]() // list of garments
    var selectedGarments = [Garment]() // list of selected garments by user
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set database controller
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        // set layout of collection view
        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
        
        // allow for multiple selection
        collectionView.allowsMultipleSelection = true
        
        // set spinner
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo:
                                                view.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo:
                                                view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        // get garments for users to select
        indicator.startAnimating()
        Task{
            await requestGarments()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /**
         Method is for when users select an item
         */
        
        // set cell isSelected to be true to change checkmark icon
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IMAGE, for: indexPath) as! PickGarmentCollectionViewCell
        cell.isSelected = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        /**
         Method is for when users deselect an item
         */
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IMAGE, for: indexPath) as! PickGarmentCollectionViewCell
        
        // set cell isSelected to be false to change checkmark icon
        collectionView.deselectItem(at: indexPath, animated: true)
        cell.isSelected = false
        
    }
    
    func requestGarments()async{
        /**
         Method to request all garments and call getImages
         */
        allGarments = databaseController!.fetchAllGarments()
        await getImages()
    }
    
    func getImages() async{
        /**
         Responsible for getting the imagePath and imageList
         */
        do{
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
            }
            
            // get image from each garment
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
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        /**
         Return the number of sections
         */
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /**
         Return the number of items
        */
        return imageList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /**
        Configure cell at index path
         */
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IMAGE, for: indexPath) as! PickGarmentCollectionViewCell
        
        // set image to garment image
        cell.imageView.image = imageList[indexPath.item]
        return cell
    }
    
    @IBAction func nextButton(_ sender: Any) {
        /**
         Button allows for users to move to the next view
         */
        
        // check if users have selected at least one item
        if (collectionView.indexPathsForSelectedItems?.count != 0){
            
            // segue to next view
            performSegue(withIdentifier: "addOutfitPhoto", sender: self)
        }else{
            displayMessage(title: "Error", message: "Please add at least 1 garment.")
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addOutfitPhoto"{
            
            // set selected garments in destination to local selected garments
            let destination = segue.destination as!AddPhotoOutfitViewController
            for index in collectionView.indexPathsForSelectedItems!{
                selectedGarments.append(allGarments[index.item])
            }
            destination.selectedGarments = selectedGarments
        }
    }
}
