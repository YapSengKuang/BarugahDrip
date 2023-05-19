//
//  PickGarmentCollectionViewCell.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 19/5/2023.
//

import UIKit

class PickGarmentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var checkmarkImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            checkmarkImageView.image = isSelected ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "checkmark.circle")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        checkmarkImageView.bringSubviewToFront(checkmarkImageView)
            
        checkmarkImageView.image = UIImage(systemName: "checkmark.circle") // Set the initial checkbox icon
        }
}
