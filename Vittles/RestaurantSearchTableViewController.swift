//
//  RestaurantSearchTableViewController.swift
//  Vittles
//
//  Created by Jenny Kwok on 10/18/16.
//  Copyright © 2016 Jenny Kwok. All rights reserved.
//

import UIKit

class RestaurantSearchTableViewController: FoodDishTableViewController {

    var restaurant:RestaurantObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MAFoodItemTableViewCell", bundle: nil), forCellReuseIdentifier: "foodCell")
        dataHandler.delegate = self
        //dataHandler.getDishes(numberOfDishes: 10)

        
    }
    
    //Hide keyboard when tableview moves
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showFoodDetails", sender: self.dishes[indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "showFoodDetails"{
            let destinationVC = segue.destination as! FoodDetailViewController
            destinationVC.dish = sender as? DishObject
        }
    }
    

}
