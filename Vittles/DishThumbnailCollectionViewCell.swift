//
//  DishThumbnailCollectionViewCell.swift
//  Vittles
//
//  Created by Jenny Kwok on 10/28/16.
//  Copyright © 2016 Jenny Kwok. All rights reserved.
//

import UIKit
import Kingfisher

class DishThumbnailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    //NOTE: Kinda hacky code to hide the camera image in post image feature
    override func prepareForReuse() {
        thumbnailImageView.image = UIImage()
        for subview in self.subviews{
            if subview is UIImageView{
                (subview as! UIImageView).image = UIImage()
            }
        }
    }
    
    
    func setUpCellFromURL(_ imageURL:String?, square:Bool){
        

        if !square{
            self.setCornerRadius(9)
        }
        
        guard imageURL != nil else{
            thumbnailImageView.image = UIImage(named: "placeholderPizza")
            return
        }
        thumbnailImageView.kf.setImage(with: URL(string: imageURL!), placeholder: UIImage(named: "placeholderPizza")!)

    }
    
    func setUpCellFromImage(_ image:UIImage, square:Bool){
        
        thumbnailImageView.image = image
        if !square{
            self.setCornerRadius(9)
        }
    }

    
}
