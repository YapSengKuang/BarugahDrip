//
//  Extensions.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 9/6/2023.
//
import Foundation
import UIKit

extension UIViewController{
    func loadImageData(filename: String) -> UIImage?{
        /**
         Method fetches a UIImage from the device given a file name
         */
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let imageURL = documentsDirectory.appendingPathComponent(filename)
        let image = UIImage(contentsOfFile: imageURL.path)
        return image
    }
    
    func displayMessage(title: String, message: String) {
        /**
         Method is responsible for alerting users given a title and a message
         */
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        /**
         Method is responsible for hiding the keyboard if a user taps anywhere on the screen that is not the keyboard
         */
        
        // add tap gesture to dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        // add gesture to view
        view.addGestureRecognizer(tap)
    }
    
    
    
    @objc func dismissKeyboard() {
        /**
         Method is responsible for dismissing the keyboard
         */
        view.endEditing(true)
    }
}

extension UICollectionViewController{
    func generateLayout() -> UICollectionViewLayout {
        /**
         Method is responsible for generating the layout of the Collection view
         */
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(4/9))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item, item])

        let section = NSCollectionLayoutSection(group: group)

        return UICollectionViewCompositionalLayout(section: section)
    }
}
