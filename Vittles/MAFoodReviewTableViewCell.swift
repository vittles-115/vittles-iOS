//
//  MAFoodReviewTableViewCell.swift
//  MenuApp
//
//  Created by Jenny Kwok on 10/16/16.
//  Copyright © 2016 Jenny. All rights reserved.
//

import UIKit
import Cosmos

class MAFoodReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewerImageView: UIImageView!
    @IBOutlet weak var reviewerNameLabel: UILabel!
    @IBOutlet weak var reviewerGeneralLocationLabel: UILabel!
    @IBOutlet weak var reviewDateLabel: UILabel!
    @IBOutlet weak var reviewTitleLabel: UILabel!
    @IBOutlet weak var reviewDescriptionLabel: UILabel!
    @IBOutlet weak var ratingCosmosView: CosmosView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        reviewerNameLabel.text = ""
        reviewerGeneralLocationLabel.text = ""
        reviewDateLabel.text = ""
        reviewTitleLabel.text = ""
        reviewDescriptionLabel.text = ""
        ratingCosmosView.isHidden = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //hide old fields in preperaton of reuse
    override func prepareForReuse() {
        reviewerImageView.image = UIImage()
        reviewerNameLabel.isHidden = true
        reviewerGeneralLocationLabel.isHidden = true
        reviewDateLabel.isHidden = true
        reviewTitleLabel.isHidden = true
        reviewDescriptionLabel.isHidden = true
        ratingCosmosView.isHidden = true

    }

    
    func setUpCellFromReview(review:ReviewObject){
        
        //Show fields once ready to load
        reviewerNameLabel.isHidden = false
        reviewerGeneralLocationLabel.isHidden = false
        reviewDateLabel.isHidden = false
        reviewTitleLabel.isHidden = false
        reviewDescriptionLabel.isHidden = false
        ratingCosmosView.isHidden = false
        
        
        reviewerImageView.setCornerRadius(9)
        reviewerImageView.image = UIImage(named: "icons1")
        reviewerNameLabel.text = review.reviewer_name
        reviewerNameLabel.sizeToFit()
        reviewerGeneralLocationLabel.text = "Santa Cruz, CA"
        //reviewDateLabel.text = dateToString(foodReview.date!,dateFormat: "MMM yyy")
        reviewTitleLabel.text = review.title
        reviewDescriptionLabel.text = review.body
        ratingCosmosView.rating = review.rating
        ratingCosmosView.settings.fillMode = StarFillMode.precise
    
    }
    
    
        
    
    
}
