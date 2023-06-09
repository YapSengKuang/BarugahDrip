//
//  OutfitsVer2CollectionViewCell.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 18/5/2023.
//

import UIKit

class OutfitsVer2CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView! // image of outfit
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //round corners
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
    }
    
}
