//
//  UserReviewsTableViewController.swift
//  Vittles
//
//  Created by Jenny Kwok on 11/21/16.
//  Copyright © 2016 Jenny Kwok. All rights reserved.
//

import UIKit
import FirebaseAuth

class UserReviewsTableViewController: ReviewTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MAFoodReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "reviewCell")
        dataHandler.delegate = self
        
        guard FIRAuth.auth()?.currentUser != nil else{
            return
        }
        dataHandler.fetchReviewsFor(userID: (FIRAuth.auth()?.currentUser?.uid)!, numberOfReviews: 10)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
