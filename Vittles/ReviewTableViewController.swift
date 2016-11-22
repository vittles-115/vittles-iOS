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
        
        return reviews.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> MAFoodReviewTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! MAFoodReviewTableViewCell
        cell.setUpCellFromReview(review: reviews[indexPath.row])
        cell.loadReviewerInfoFor(review: reviews[indexPath.row])
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    func didFetchReviews(value: NSDictionary?) {
        self.reviews = FirebaseObjectConverter.reviewArrayFrom(dictionary: value!)
        self.tableView.reloadData()
    }
    
    func failedToFetchReviews(errorString: String) {
        print("error :",errorString)
    }
    
    //var isScrollinUp = false
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
 
        

    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

    }
  
}
