//
//  SavedRestaurantTableViewController.swift
//  Vittles
//
//  Created by Jenny Kwok on 11/20/16.
//  Copyright © 2016 Jenny Kwok. All rights reserved.
//

import UIKit
import FirebaseAuth

class SavedRestaurantTableViewController: RestaurantTableViewController {

    override func viewDidLoad() {
        //super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MARestaurantTableViewCell", bundle: nil), forCellReuseIdentifier: "restaurantCell")
        
        
        if (FirebaseUserHandler.currentUDID != nil){
            dataHandler.getSavedRestaurantsFor(userID: (FIRAuth.auth()?.currentUser?.uid)!)
        }else{
            self.restaurants.removeAll()
            self.tableView.reloadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(RestaurantTableViewController.reload), name: NSNotification.Name(rawValue: loggedInNotificationKey), object: nil)
        
        self.loadingIndicator.center = self.view.center
        //self.setUpRefreshControl()
        self.view.addSubview(loadingIndicator)
        self.refreshControl?.endEditing(true)
        self.loadingIndicator.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (FirebaseUserHandler.currentUDID == nil){
            self.restaurants = [RestaurantObject]()
            self.tableView.reloadData()
        }else{
            dataHandler.delegate = self
            self.refreshControl?.isEnabled = true
            
        }
        
        self.refreshTableView()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func refreshTableView(){
        if ((FIRAuth.auth()?.currentUser) != nil){
            dataHandler.getSavedRestaurantsFor(userID: (FIRAuth.auth()?.currentUser?.uid)!)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "showMenus", sender: restaurants[indexPath.row])
        
        if restaurants.count == 0{
            return
        }
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RestaurantMainDetailViewController") as! RestaurantMainDetailViewController
    
        vc.restaurant = restaurants[indexPath.row]
        (self.parent?.parent as! UINavigationController).pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let save = UITableViewRowAction(style: .normal, title: "         ") { action, index in
            
            if FirebaseUserHandler.currentUDID != nil{
                FirebaseUserHandler.sharedInstance.updateSavedRestaurant(for: self.restaurants[indexPath.row].uniqueID)
            }else{
                self.presentSimpleAlert(title: "Failed to Save!", message: "You are not logged in! Please log in to save dishes and restaurants")
            }
            
            self.showStarPopUp()
            self.restaurants.remove(at: indexPath.row)
            
            
            if self.restaurants.count <= 1{
                self.tableView.reloadData()
            }else{
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                
            }
            
        }
        
        guard restaurants.count > 0 else{
            return []
        }
            
        let restaurantID = restaurants[indexPath.row].uniqueID
        
        if (FirebaseUserHandler.currentUserDictionary?.object(forKey: "SavedRestaurants") as? NSDictionary)?.object(forKey: restaurantID ) as? Bool == true{
            save.backgroundColor = UIColor(patternImage: UIImage(named: "SaveSwipe")!)
        }else{
            save.backgroundColor = UIColor(patternImage: UIImage(named: "save")!)
        }
        
        return [save]
        
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
