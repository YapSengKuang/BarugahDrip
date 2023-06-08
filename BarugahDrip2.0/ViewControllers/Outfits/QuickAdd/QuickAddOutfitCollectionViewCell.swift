//
//  QuickAddOutfitCollectionViewCell.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 9/6/2023.
//

import UIKit

class QuickAddOutfitCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
    }
}
