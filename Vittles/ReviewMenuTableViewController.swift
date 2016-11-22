//
//  ReviewMenuTableViewController.swift
//  Vittles
//
//  Created by Jenny kwok on 10/16/16.
//  Copyright © 2016 Jenny Kwok. All rights reserved.
//

import UIKit

class ReviewMenuTableViewController: RestaurantMenuTableViewController {

//    var restaurant:RestaurantObject?
//    var selectedMenu:String?
//    var dataHandler:FirebaseDataHandler = FirebaseDataHandler()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataHandler.delegate = self
        self.dataHandler.getDishesFor(restaurantID: (restaurant?.uniqueID)!, menuNamed: selectedMenu!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "pickedDish", sender: self.dishes[indexPath.row])
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickedDish"{
            let destinationVC = segue.destination as! ReviewViewController
            destinationVC.pickedDish = sender as? DishObject
        }

    }
 

}
