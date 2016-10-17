//
//  ReviewPickMenuTableViewController.swift
//  Vittles
//
//  Created by Jenny kwok on 10/16/16.
//  Copyright © 2016 Jenny Kwok. All rights reserved.
//

import UIKit

class ReviewPickMenuTableViewController: RestaurantPickMenuTableViewController,UISearchBarDelegate {

    lazy var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let mainVC = self.parent?.parent as! ReviewPickDishMainViewController
        mainVC.navigationItem.setLeftBarButton(nil, animated: true)
        mainVC.navigationItem.setRightBarButton(mainVC.cancelButton, animated: true)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpSearchBar(){
        //Setup and put searchBar in navigationBar
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Pick a dish."
        self.searchBar.backgroundColor = MA_Red
        self.navigationItem.titleView = searchBar
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.performSegue(withIdentifier: "showSearchResults", sender: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search")
        
//        dataHandler.getRestaurantsWhereName(startsWith: (searchBar.text?.lowercased())!, numberOfRestaurants: 10)
    }

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("seguing seguing seguing ")
        let mainVC = self.parent?.parent as! ReviewPickDishMainViewController
        mainVC.navigationItem.setLeftBarButton(mainVC.backButton, animated: true)
        mainVC.navigationItem.setRightBarButton(nil, animated: true)
        
        if segue.identifier == "showSelectedMenu"{
            let destinationVC = segue.destination as! ReviewMenuTableViewController
            destinationVC.restaurant = self.restaurant
            destinationVC.selectedMenu = sender as? String
            mainVC.view.endEditing(true)
        }
    }
    

}
