//
//  QuickAddOutfitCollectionViewCell.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 9/6/2023.
//

import UIKit

class QuickAddOutfitCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView! // Outfit Image of the cell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // round the corner of the image
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
    }
}
