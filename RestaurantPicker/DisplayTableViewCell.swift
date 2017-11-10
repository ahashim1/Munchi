//
//  DisplayTableViewCell.swift
//  RestaurantPicker
//
//  Created by Ali Hashim on 11/7/17.
//  Copyright © 2017 Ali Hashim. All rights reserved.
//

import UIKit

class DisplayTableViewCell: UITableViewCell {

   
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupImageView(){
        imageView?.clipsToBounds = true
        imageView?.contentMode = .scaleAspectFill
    }

}
