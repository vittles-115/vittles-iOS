//
//  RestaurantMenuTableViewController.swift
//  Vittles
//
//  Created by Jenny Kwok on 10/16/16.
//  Copyright © 2016 Jenny Kwok. All rights reserved.
//

import UIKit

class RestaurantMenuTableViewController: FoodDishTableViewController{
    
    //var dishes:[DishObject] = [DishObject]()
    var restaurant:RestaurantObject?
    var selectedMenu:String?
    //var dataHandler:FirebaseDataHandler = FirebaseDataHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "MAFoodItemTableViewCell", bundle: nil), forCellReuseIdentifier: "foodCell")
        self.title = selectedMenu
        self.dataHandler.delegate = self
        self.dataHandler.getDishesFor(restaurantID: (restaurant?.uniqueID)!, menuNamed: selectedMenu!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(FoodDishTableViewController.reload), name: NSNotification.Name(rawValue: loggedInNotificationKey), object: nil)
        
        self.setUpRefreshControl()


    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return self.dishes.count
//    }
//    
//    //Row hieght of 80
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 80.0
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> MAFoodItemTableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as! MAFoodItemTableViewCell
//        
//        // Configure the cell...
//        cell.setupCell(fromDish: dishes[indexPath.row])
//        
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showFoodDetails", sender: self.dishes[indexPath.row])
    }

    func didFetchDishesForMenu(value:NSDictionary?) {
        print("returned with : ", value)
        self.dishes = FirebaseObjectConverter.dishArrayFrom(dictionary: value!)
        self.tableView.reloadData()
        //print("dishes",foodArray)
    }
//    
//    func failedToFetchDishes(errorString: String) {
//        print("error is: ",errorString)
//    }
//
//    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // the cells you would like the actions to appear needs to be editable
//        return true
//    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let save = UITableViewRowAction(style: .normal, title: "         ") { action, index in
            FirebaseUserHandler.sharedInstance.updateSavedDish(for: self.dishes[indexPath.row].uniqueID)
            self.showStarPopUp()
            //self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.right)
        }
        
        let dishID = dishes[indexPath.row].uniqueID
        
        if (FirebaseUserHandler.currentUserDictionary?.object(forKey: "SavedDishes") as? NSDictionary)?.object(forKey: dishID ) as? Bool == true{
            save.backgroundColor = UIColor(patternImage: UIImage(named: "SaveSwipe")!)
        }else{
            save.backgroundColor = UIColor(patternImage: UIImage(named: "save")!)
        }
        
        return [save]
        
    }
    
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        self.currentSwipeIndex = indexPath
    }
    
//    func setUpRefreshControl(){
//        self.refreshControl = UIRefreshControl()
//        refreshControl?.addTarget(self, action: #selector(refreshTableView), for: UIControlEvents.valueChanged)
//        self.refreshControl?.backgroundColor = UIColor.white
//        self.refreshControl?.tintColor = MA_Red
//        self.tableView.addSubview(self.refreshControl!)
//        
//    }
    
//    func refreshTableView(){
//        let parentVC = parent as! HomeSearchViewController
//        if parentVC.searchBar.text == ""{
//            dataHandler.getDishes(numberOfDishes:10)
//        }else{
//            dataHandler.getDishesWhereName(startsWith: parentVC.searchBar.text!, numberOfDishes: 10)
//        }
//        
//    }
    
//    func showStarPopUp(){
//        let popup = popupFadeIn(self.view, imageName: "SavePopup")
//        popupFadeOut(popup)
//    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "showFoodDetails"{
            let destinationVC = segue.destination as! FoodDetailViewController
            destinationVC.dish = sender as? DishObject
        }
    }

}
