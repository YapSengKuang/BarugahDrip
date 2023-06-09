//
//  GarmentsVer2CollectionViewCell.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 17/5/2023.
//

import UIKit

class GarmentsVer2CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView! // image of garment
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // round corners
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
    }
}
