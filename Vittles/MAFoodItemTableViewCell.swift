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
    }
    
    //Setup cell from given MAFoodItem object
    func setupCell(fromDish:DishObject){
        
        foodNameLabel.isHidden = false
        foodDescriptionLabel.isHidden = false
        resturantNameLabel.isHidden = false
        
        

        if fromDish.imageURL != nil{
            print("has image url :", fromDish.imageURL!)
            self.foodImageView.kf.setImage(with: URL(string: fromDish.imageURL!), placeholder: UIImage(named: "icons1")!)
        }else{
            self.foodImageView.image = UIImage(named: "icons1")!
        }
        
//        FirebaseThumbnailImagePathRef.child("Dishes").child(fromDish.uniqueID).queryLimited(toFirst: 1).observeSingleEvent(of: .value, with: { (snapshot) in
//            
//                print("value is WOWOWOW", snapshot.value)
//                guard (snapshot.value as? String) != nil else{
//                    return
//                }
//            
//            
//            self.reloadInputViews()
//            
//            }) { (error) in
//            print(error.localizedDescription)
//            
//            }
//    
  
        
//        FirebaseImageHandler.sharedInstance.downloadThumbnailFor(dishID: fromDish.uniqueID, imageCallback:{(image:UIImage?,error:NSError?) in
//            print("GOT IMAGE")
//            print(image)
//            guard image != nil else{
//                print("NO Image IMAGE")
//                return
//            }
//            print("GOOD IMAGE")
//            self.foodImageView?.image = UIImage(named: "icons1")!
//            self.reloadInputViews()
//        })
        
        self.foodImageView.setCornerRadius(9)
        
        self.foodNameLabel.text = fromDish.name
        self.foodDescriptionLabel.text = fromDish.foodDescription
        self.resturantNameLabel.text = fromDish.restaurantName
        self.ratingCosmosView.rating = fromDish.averageRating
        self.ratingCosmosView.settings.fillMode = StarFillMode.precise
    }


    
}



