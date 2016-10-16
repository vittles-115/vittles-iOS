//
//  ResturantMenuMainViewController.swift
//  Vittles
//
//  Created by Jenny Kwok on 10/16/16.
//  Copyright © 2016 Jenny Kwok. All rights reserved.
//

import UIKit

class ResturantMenuMainViewController: UIViewController {

    var restaurant:RestaurantObject?
    var selectedMenu:String?
    var dataHandler:FirebaseDataHandler = FirebaseDataHandler()

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard selectedMenu != nil else {
            return
        }
        self.title = selectedMenu
        self.dataHandler.delegate = self.childViewControllers.first as! RestaurantMenuTableViewController
        self.dataHandler.getDishesFor(restaurantID: (restaurant?.uniqueID)!, menuNamed: selectedMenu!)
        
        
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
