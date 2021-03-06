//
//  FoodDetailViewController.swift
//  MenuApp
//
//  Created by Jenny Kwok on 10/13/16.
//  Copyright © 2016 Jenny. All rights reserved.
//

import UIKit
import Cosmos

class FoodDetailViewController: UIViewController, UIScrollViewDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var foodDescriptionLabel: UILabel!
    @IBOutlet weak var showMoreButton: UIButton!
    
    @IBOutlet weak var starRating: CosmosView!
    @IBOutlet weak var restaurantLabel: UILabel!
  
    @IBOutlet weak var savedStarImageView: UIImageView!
    
    var selectedImageURL:String = ""
    var selectedImage:UIImage?
    var dish:DishObject?
  
    var childReviewTable:ReviewTableViewController?
    
    //var loadedObjects:[MAReview] = [MAReview]()
    var imageHandler:FirebaseImageHandler = FirebaseImageHandler()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTopDivider(self.showMoreButton, thickness: 1, color: MA_BGGray)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Review", style: .plain, target: self, action: #selector(reviewButtonPressed))
        
        //Setup delegates
        self.scrollView.delegate = self
        //self.scrollView.contentSize.height = 2000
        
        self.foodDescriptionLabel.text = dish?.foodDescription
        self.title = dish?.name
        
    
        
        for childVC in self.childViewControllers{
            if childVC is ReviewTableViewController{
                let childVC = childVC as! ReviewTableViewController
                childVC.dish = self.dish
                childVC.dataHandler.fetchReviewsFor(dishID:(dish!.uniqueID), numberOfReviews:40)
                self.childReviewTable = childVC
            }
            
            if childVC is DishImageCollectionViewController{
                let childVC = childVC as! DishImageCollectionViewController
                self.imageHandler.delegate = childVC
                imageHandler.getImageThumbnailUrlsFor(dishID: (dish?.uniqueID)!, imageCount: 10)
                
            }
        }
      
        guard dish != nil else {
            return
        }
        
        if let rating = dish?.averageRating{
            self.starRating.rating = rating
        }
        
        if let restaurantName = dish?.restaurantName{
            self.restaurantLabel.text = restaurantName
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 200{
            scrollView.bounces = false
            childReviewTable?.tableView.isScrollEnabled = true
        }else{
            scrollView.bounces = true
            childReviewTable?.tableView.isScrollEnabled = false
        }
        
    }
    
    func reviewButtonPressed(){
        
        FirebaseResturantRef.child((dish?.restaurantRefID)!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else{
                return
            }
            
            pushReviewVC(dish: self.dish!, restaurant:FirebaseObjectConverter.dictionaryToRestaurantObject(dictionary: value, uniqueID: (self.dish?.restaurantRefID)!)!)
        })
    
//        let storyboard =  UIStoryboard(name: "Review", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
//        vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
//        self.present(vc, animated: true, completion: nil)
        
    }
    
    // MARK: - Navigation


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAllImages"{
            let destinationVC = segue.destination as? AllDishImageCollectionViewController
            destinationVC?.dish = self.dish
        }else if segue.identifier == "viewLargeImage"{
            let destinationVC = segue.destination as? DishLargeImageViewController
            destinationVC?.imageURLS = sender as! [(String, String)]
        }
        
    }

}
