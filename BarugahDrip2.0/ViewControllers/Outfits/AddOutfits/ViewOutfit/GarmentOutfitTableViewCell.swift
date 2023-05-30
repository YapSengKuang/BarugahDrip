//
//  GarmentOutfitTableViewCell.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 26/5/2023.
//

import UIKit

class GarmentOutfitTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var Brand: UILabel!
    @IBOutlet weak var garmentImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        garmentImageView.layer.cornerRadius = 8.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
