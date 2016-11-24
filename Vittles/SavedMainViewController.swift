//
//  SavedMainViewController.swift
//  Vittles
//
//  Created by Jenny Kwok on 11/20/16.
//  Copyright © 2016 Jenny Kwok. All rights reserved.
//

import UIKit

class SavedMainViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var resturantContainer: UIView!
    @IBOutlet weak var foodDishContainer: UIView!
    
    var restaurantVC:RestaurantTableViewController?
    var dishVC:FoodDishTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Saved"
        
        self.segmentedControl.selectedSegmentIndex = 0
        self.foodDishContainer.isHidden = false
        self.resturantContainer.isHidden = true
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            FirebaseUserHandler.sharedInstance.firebaseSaveDegate = dishVC
            break
        case 1:
            FirebaseUserHandler.sharedInstance.firebaseSaveDegate = restaurantVC
            break
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            FirebaseUserHandler.sharedInstance.firebaseSaveDegate = dishVC
            self.foodDishContainer.isHidden = false
            self.resturantContainer.isHidden = true
            break
        case 1:
            FirebaseUserHandler.sharedInstance.firebaseSaveDegate = restaurantVC
            self.foodDishContainer.isHidden = true
            self.resturantContainer.isHidden = false
            break
        default:
            break
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "showFoodDetails"{
            let destinationVC = segue.destination as! FoodDetailViewController
            destinationVC.dish = sender as? DishObject
        }
    }
    


}
