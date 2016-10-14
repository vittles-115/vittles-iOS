//
//  MARestaurantTableViewCell.swift
//  MenuApp
//
//  Created by Jenny Kwok on 2/21/16.
//  Copyright © 2016 Jenny. All rights reserved.
//

import UIKit

class MARestaurantTableViewCell: UITableViewCell {

    
    @IBOutlet weak var resturantImageView: UIImageView!
    @IBOutlet weak var resturantNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var foodCategoryLabel: UILabel!
    
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
        resturantNameLabel.isHidden = true
        addressLabel.isHidden = true
        foodCategoryLabel.isHidden = true
        resturantImageView.image = UIImage()
    }
    
    func setUpCell(){
        
        resturantNameLabel.isHidden = false
        addressLabel.isHidden = false
        foodCategoryLabel.isHidden = false
        
        //Load image from url and set corner radius
        

        self.resturantImageView.image = UIImage(named: "icons1")!
    
        
        self.resturantImageView.setCornerRadius(9)
        
        self.resturantNameLabel.text = "Restaurant Name"
        self.addressLabel.text = "Address"
        self.foodCategoryLabel.text = "American, Fast Food, Burgers"
    }
    
    
    
}