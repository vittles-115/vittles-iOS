//
//  MAFoodItemTableViewCell.swift
//  MenuApp
//
//  Created by Jenny Kwok on 2/21/16.
//  Copyright © 2016 Jenny. All rights reserved.
//

import UIKit
import Cosmos
import Kingfisher

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
        self.savedStarImageView.image = UIImage()
    }
    
    //Setup cell from given MAFoodItem object
    func setupCell(fromDish:DishObject){
        
        foodNameLabel.isHidden = false
        foodDescriptionLabel.isHidden = false
        resturantNameLabel.isHidden = false
        
        
        //Thumbnail image
        if fromDish.imageURL != nil{
            self.foodImageView.kf.setImage(with: URL(string: fromDish.imageURL!), placeholder: UIImage(named: "placeholderPizza")!)
        }else{
            self.foodImageView.image = UIImage(named: "icons1")!
        }
        
        //Star Saved Indicator
        if (FirebaseUserHandler.currentUserDictionary?.object(forKey: "SavedDishes") as? NSDictionary)?.object(forKey: fromDish.uniqueID ) as? Bool == true{
            self.savedStarImageView.image = UIImage(named: "Star")
        }else{
            self.savedStarImageView.image = UIImage()
        }

        
        self.foodImageView.setCornerRadius(9)
        self.foodNameLabel.text = fromDish.name
        self.foodDescriptionLabel.text = fromDish.foodDescription
        self.resturantNameLabel.text = fromDish.restaurantName
        self.ratingCosmosView.rating = fromDish.averageRating
        self.ratingCosmosView.settings.fillMode = StarFillMode.precise
    }


    
}



