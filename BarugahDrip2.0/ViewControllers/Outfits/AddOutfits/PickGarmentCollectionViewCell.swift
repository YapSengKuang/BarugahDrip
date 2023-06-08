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
    
    override var isSelected: Bool{
        didSet{
            toggleSelected()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
        toggleSelected()
    }
    
    func toggleSelected(){
        if isSelected{
            self.checkmarkImageView.image = UIImage(systemName: "checkmark.square.fill")
        }else{
            self.checkmarkImageView.image = UIImage(systemName: "checkmark.square")
        }
    }
}
