//
//  PickGarmentCollectionViewCell.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 19/5/2023.
//

import UIKit

class PickGarmentCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var checkmarkImageView: UIImageView! // check mark image
    @IBOutlet weak var imageView: UIImageView! // image of garment
    
    override var isSelected: Bool{
        /**
         Responsible for toggling the checkmarks
         */
        didSet{
            toggleSelected()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // round corners
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
        toggleSelected()
    }
    
    func toggleSelected(){
        
        // change item based on isSelected
        if isSelected{
            self.checkmarkImageView.image = UIImage(systemName: "checkmark.square.fill")
        }else{
            self.checkmarkImageView.image = UIImage(systemName: "checkmark.square")
        }
    }
}
