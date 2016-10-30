//
//  FoodDetailViewController.swift
//  MenuApp
//
//  Created by Jenny Kwok on 10/13/16.
//  Copyright © 2016 Jenny. All rights reserved.
//

import UIKit

class FoodDetailViewController: UIViewController, UIScrollViewDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var foodDescriptionLabel: UILabel!
    @IBOutlet weak var showMoreButton: UIButton!
    
  
    var selectedImageURL:String = ""
    var selectedImage:UIImage?
    var dish:DishObject?
  
    
    //var loadedObjects:[MAReview] = [MAReview]()
    var imageHandler:FirebaseImageHandler = FirebaseImageHandler()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTopDivider(self.showMoreButton, thickness: 1, color: MA_BGGray)
        
        //Setup delegates
        self.scrollView.delegate = self
        //self.scrollView.contentSize.height = 2000
        
        self.foodDescriptionLabel.text = dish?.foodDescription
        self.title = dish?.name
        
        for childVC in self.childViewControllers{
            if childVC is ReviewTableViewController{
                let childVC = childVC as! ReviewTableViewController
                childVC.dish = self.dish
                childVC.dataHandler.fetchReviewsFor(dishID:(dish!.uniqueID), numberOfReviews:10)
            }
            
            if childVC is DishImageCollectionViewController{
                let childVC = childVC as! DishImageCollectionViewController
                self.imageHandler.delegate = childVC
                imageHandler.getImageThumbnailUrlsFor(dishID: (dish?.uniqueID)!, imageCount: 10)
                
            }
        }
      
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 200{
            //scrollView.bounces = false
            //childTableVC?.tableView.isScrollEnabled = true
        }else{
            //scrollView.bounces = true
            //childTableVC?.tableView.isScrollEnabled = false
        }
        
    }
    
    
    // MARK: - Navigation


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAllImages"{
            let destinationVC = segue.destination as? AllDishImageCollectionViewController
            destinationVC?.dish = self.dish

        }
    }

}
