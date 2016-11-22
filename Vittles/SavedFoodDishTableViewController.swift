//
//  SavedFoodDishTableViewController.swift
//  Vittles
//
//  Created by Jenny Kwok on 11/20/16.
//  Copyright © 2016 Jenny Kwok. All rights reserved.
//

import UIKit
import FirebaseAuth

class SavedFoodDishTableViewController: FoodDishTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MAFoodItemTableViewCell", bundle: nil), forCellReuseIdentifier: "foodCell")
        
        dataHandler.delegate = self
        
        if ((FIRAuth.auth()?.currentUser) != nil){
            dataHandler.getSavedDishesFor(userID: (FIRAuth.auth()?.currentUser?.uid)!)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(SavedFoodDishTableViewController.reload), name: NSNotification.Name(rawValue: loggedInNotificationKey), object: nil)
        
        self.setUpRefreshControl()
        let centerHeightPt = self.tableView.frame.height/2 - screenSize.height/6 - self.tableView.contentOffset.y
        let centerPoint = CGPoint(x: self.tableView.frame.width/2 , y: centerHeightPt)
        self.loadingIndicator.center = centerPoint
        
        self.view.addSubview(loadingIndicator)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if ((FIRAuth.auth()?.currentUser) == nil){
            self.dishes.removeAll()
        }
    }

    override func refreshTableView(){
        guard parent is SavedMainViewController else {
            self.refreshControl?.endRefreshing()
            return
        }
        
        if ((FIRAuth.auth()?.currentUser) != nil){
            dataHandler.getSavedDishesFor(userID: (FIRAuth.auth()?.currentUser?.uid)!)
        }

    }
    
    override func didFetchAdditionalDishes(value: NSDictionary?) {
        isFetching = false
        print("fetched next objects")
        self.refreshControl?.endRefreshing()
        //let indexPath = NSIndexPath(row: self.dishes.count-1, section: 0)
        var newDishes =  FirebaseObjectConverter.dishArrayFrom(dictionary: value!)
        if(newDishes.count > 1){
            newDishes.remove(at: 0)
        }else{
            return
        }
        self.dishes.append(contentsOf:newDishes)
        //self.tableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        self.tableView.reloadData()
        self.loadingIndicator.isHidden = true
    }


    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
                
    }

    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let save = UITableViewRowAction(style: .normal, title: "         ") { action, index in
            FirebaseUserHandler.sharedInstance.updateSavedDish(for: self.dishes[indexPath.row].uniqueID)
            self.showStarPopUp()
            self.dishes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            //self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.right)
        }
        
        let addToList = UITableViewRowAction(style: .normal, title: "         ") { action, index in
            //            FirebaseUserHandler.sharedInstance.updateSavedDish(for: self.dishes[indexPath.row].uniqueID)
            //            self.showStarPopUp()
            //self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.right)
        }
        
        let dishID = dishes[indexPath.row].uniqueID
        
        if (FirebaseUserHandler.currentUserDictionary?.object(forKey: "SavedDishes") as? NSDictionary)?.object(forKey: dishID ) as? Bool == true{
            save.backgroundColor = UIColor(patternImage: UIImage(named: "SaveSwipe")!)
        }else{
            save.backgroundColor = UIColor(patternImage: UIImage(named: "save")!)
        }
        
        addToList.backgroundColor = UIColor(patternImage: UIImage(named: "addToList")!)
        
        return [save]
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.parent?.performSegue(withIdentifier: "showFoodDetails", sender: self.dishes[indexPath.row])
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FoodDetailViewController") as! FoodDetailViewController
        vc.dish = self.dishes[indexPath.row]
        (self.parent?.parent as! UINavigationController).pushViewController(vc, animated: true)
        
        
        
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
