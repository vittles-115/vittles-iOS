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
    
    override func prepareForReuse() {
        thumbnailImageView.image = UIImage()
    }
    
    
    func setUpCellFromURL(_ imageURL:String?, square:Bool){
        

        if !square{
            self.setCornerRadius(9)
        }
        
        guard imageURL != nil else{
            thumbnailImageView.image = UIImage(named: "icons1")
            return
        }
        thumbnailImageView.kf.setImage(with: URL(string: imageURL!), placeholder: UIImage(named: "icons1")!)

    }
    
    func setUpCellFromImage(_ image:UIImage, square:Bool){
        
        thumbnailImageView.image = image
        if !square{
            self.setCornerRadius(9)
        }
    }

    
}
