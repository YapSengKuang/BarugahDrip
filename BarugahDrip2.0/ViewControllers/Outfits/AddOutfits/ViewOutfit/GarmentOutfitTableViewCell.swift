//
//  GarmentOutfitTableViewCell.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 26/5/2023.
//

import UIKit

class GarmentOutfitTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel! // Name of garment
    @IBOutlet weak var Brand: UILabel! // brand of garment
    @IBOutlet weak var garmentImageView: UIImageView! // image of garment
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        garmentImageView.layer.cornerRadius = 8.0 // round corners
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // If item is selected set as selected
        super.setSelected(selected, animated: animated)
    }

}
