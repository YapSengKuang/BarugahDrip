//
//  garmentCollectionViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 10/5/2023.
//

import UIKit

class garmentCollectionViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, DatabaseListener, UICollectionViewDelegateFlowLayout {
    var listenerType: ListenerType = .garment
    var allGarments: [Garment] = []
    weak var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        collectionView.register(garmentCollectionViewCell.nib(), forCellWithReuseIdentifier: garmentCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self

        // Do any additional setup after loading the view.
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        //let screenHeight = screenSize.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
    }
    
    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return allGarments.count
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: garmentCollectionViewCell.identifier, for: indexPath) as! garmentCollectionViewCell
    
        cell.configure(with: UIImage(named: "Outfit1")!)
        
        // Configure the cell
    
        return cell
    }
    
    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("tapped \(indexPath)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /*
         before the view appears on screen , we need to add ourselves to the database listeners.
         */
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width/3, height: width/3)
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
}
