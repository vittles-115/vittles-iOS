//
//  ReviewTableViewController.swift
//  MenuApp
//
//  Created by Jenny Kwok on 10/16/16.
//  Copyright © 2016 Jenny. All rights reserved.
//

import Foundation
import UIKit

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ReviewTableViewController: UITableViewController,FirebaseDataHandlerDelegate{

    var dish:DishObject?
    var reviews:[ReviewObject] = [ReviewObject]()
    let dataHandler:FirebaseDataHandler = FirebaseDataHandler()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MAFoodReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "reviewCell")

        dataHandler.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if reviews.count > 0{
            return reviews.count
        }else{
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if reviews.count == 0{
            let cell = UITableViewCell(frame: self.tableView.frame)
            
            let myString = "No reviews yet!"
            let myAttribute = [ NSForegroundColorAttributeName: MA_LightGray , NSFontAttributeName: UIFont(name: "SourceSansPro-Semibold", size: 15.0)!]
            
            let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
            cell.textLabel?.attributedText = myAttrString
            cell.textLabel?.textAlignment = NSTextAlignment.center
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! MAFoodReviewTableViewCell
        cell.setUpCellFromReview(review: reviews[indexPath.row])
        cell.loadReviewerInfoFor(review: reviews[indexPath.row])
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if reviews.count == 0{
            return 300
        }
        return 115
    }
    
    func didFetchReviews(value: NSDictionary?) {
        
        guard parent is FoodDetailViewController else{
            return
        }
        
        (self.parent as! FoodDetailViewController).scrollView.isScrollEnabled = true
        self.reviews = FirebaseObjectConverter.reviewArrayFrom(dictionary: value!)
        self.tableView.isScrollEnabled = true
        self.tableView.reloadData()
    }
    
    func failedToFetchReviews(errorString: String) {
        
        print("error :",errorString)
        self.tableView.isScrollEnabled = false
       (self.parent as! FoodDetailViewController).scrollView.isScrollEnabled = false
    }
    
    
    //var isScrollinUp = false
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
 
        

    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

    }
  
}
