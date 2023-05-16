//
//  outfitsCollectionViewCell.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 12/5/2023.
//

import UIKit

class outfitsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    static let identifier = "outfitsCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
    }
    
    

    public func configure(with image: UIImage){
        /**
         Configure method acts as the setter for the image in the collection view cell
         */
        imageView.image = image
    }
    
    static func nib() -> UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
}
