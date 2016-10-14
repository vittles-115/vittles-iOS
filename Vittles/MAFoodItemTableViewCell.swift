//
//  MAFoodItemTableViewCell.swift
//  MenuApp
//
//  Created by Jenny Kwok on 2/21/16.
//  Copyright © 2016 Jenny. All rights reserved.
//

import UIKit
import Cosmos

class MAFoodItemTableViewCell: UITableViewCell {

    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodDescriptionLabel: UILabel!
    @IBOutlet weak var resturantNameLabel: UILabel!
    @IBOutlet weak var ratingCosmosView: CosmosView!
    @IBOutlet weak var savedStarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
 
            
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func prepareForReuse() {
        foodImageView.image = UIImage()
        foodNameLabel.isHidden = true
        foodDescriptionLabel.isHidden = true
        resturantNameLabel.isHidden = true
    }
    
    //Setup cell from given MAFoodItem object
    func setupCell(){
        
        foodNameLabel.isHidden = false
        foodDescriptionLabel.isHidden = false
        resturantNameLabel.isHidden = false
        
  
        self.foodImageView.image = UIImage(named: "icons1")!
    
        
        self.foodImageView.setCornerRadius(9)
        
        self.foodNameLabel.text = "Food"
        self.foodDescriptionLabel.text = "This is the description of the yummy food!"
        self.resturantNameLabel.text = "Restaurant Name"
        self.ratingCosmosView.rating = 4.5
        self.ratingCosmosView.settings.fillMode = StarFillMode.precise
    }


    
}


