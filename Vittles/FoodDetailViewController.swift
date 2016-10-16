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
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTopDivider(self.showMoreButton, thickness: 1, color: MA_BGGray)
        
        //Setup delegates
        self.scrollView.delegate = self
        //self.scrollView.contentSize.height = 2000
        
        self.foodDescriptionLabel.text = dish?.foodDescription
        self.title = dish?.name
    
      

        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
