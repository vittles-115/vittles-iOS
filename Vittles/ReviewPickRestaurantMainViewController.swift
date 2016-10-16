//
//  ReviewPickRestaurantMainViewController.swift
//  Vittles
//
//  Created by Jenny Kwok on 10/15/16.
//  Copyright © 2016 Jenny Kwok. All rights reserved.
//

import UIKit

class ReviewPickRestaurantMainViewController: UIViewController,UISearchBarDelegate,FirebaseDataHandlerDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    var pickedRestaurant:RestaurantObject?
    
    var dataHandler:FirebaseDataHandler = FirebaseDataHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchBar.delegate = self
        self.dataHandler.delegate = self.childViewControllers.first as! ReviewPickRestaurantTableViewController
        
        let cancelButton = searchBar.value(forKey: "cancelButton") as! UIButton
        cancelButton.setTitle("Close", for: .normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search")
        dataHandler.getRestaurantsWhereName(startsWith: (searchBar.text?.lowercased())!, numberOfRestaurants: 10)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("canceled search")
        self.dismiss(animated: true, completion: nil)
        //self.view.endEditing(true)
    }
        
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //DEV NOTE: Need to generalize numbers for diffrent sizes
        self.preferredContentSize = CGSize(width: self.view.frame.width, height: 350)
    }



    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "pickedRestaurant"{
            let destinationVC = segue.destination as! ReviewViewController
            destinationVC.pickedRestaurant = self.pickedRestaurant
        }
        
    }
    

}
