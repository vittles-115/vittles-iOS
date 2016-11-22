//
//  RestaurantMainDetailViewController.swift
//  Vittles
//
//  Created by Jenny Kwok on 10/18/16.
//  Copyright © 2016 Jenny Kwok. All rights reserved.
//

import UIKit

class RestaurantMainDetailViewController: UIViewController,UISearchBarDelegate {

    @IBOutlet weak var pickMenuContainer: UIView!
    @IBOutlet weak var searchMenuContainer: UIView!
    
    var restaurant:RestaurantObject?
    var dataHandler:FirebaseDataHandler = FirebaseDataHandler()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //temporarly hide
        //searchBar.delegate = self
        self.searchBar.isHidden = true
        
        pickMenuContainer.isHidden = false
        searchMenuContainer.isHidden = true
        
        for vc in self.childViewControllers{
            if vc is RestaurantPickMenuTableViewController{
                let childVC = vc as! RestaurantPickMenuTableViewController
                childVC.restaurant = self.restaurant
            }
            
            if vc is RestaurantSearchTableViewController{
                let childVC = vc as! RestaurantSearchTableViewController
                dataHandler.delegate = childVC
            }
        }
        
    
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        pickMenuContainer.isHidden = true
        searchMenuContainer.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        pickMenuContainer.isHidden = false
        searchMenuContainer.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSelectedMenu"{
            let destinationVC = segue.destination as! RestaurantMenuTableViewController
            destinationVC.restaurant = self.restaurant
            destinationVC.selectedMenu = sender as? String
            
        }
    }
}
