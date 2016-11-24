//
//  ReviewPickRestaurantTableViewController.swift
//  Vittles
//
//  Created by Jenny Kwok on 10/15/16.
//  Copyright © 2016 Jenny Kwok. All rights reserved.
//

import UIKit

class ReviewPickRestaurantTableViewController: UITableViewController ,UISearchBarDelegate, FirebaseDataHandlerDelegate{

    //Create searchBar to be used in NavigationBar
    lazy var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var restaurants:[RestaurantObject] = [RestaurantObject]()
    var dataHandler:FirebaseDataHandler = FirebaseDataHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "MARestaurantTableViewCell", bundle: nil), forCellReuseIdentifier: "restaurantCell")
        setUpSearchBar()
        dataHandler.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurants.count
    }
    
    
    func didFetchRestaurants(value:NSDictionary?){
        self.restaurants = FirebaseObjectConverter.restaurantArrayFrom(dictionary: value!)
        print("fetched the following: ",value,self.restaurants)
        self.tableView.reloadData()
    }
    
    func failedToFetchRestaurants(errorString:String){
        print("failed to fetch restaurant: ", errorString)
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> MARestaurantTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath) as! MARestaurantTableViewCell
        
        // Configure the cell...
        cell.setUpCell(restaurant: restaurants[indexPath.row])
        
        return cell
    }
    
    //Row hieght of 80
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pickedRestaurant = self.restaurants[indexPath.row]
        self.performSegue(withIdentifier: "pickedRestaurant", sender: pickedRestaurant)
    }
    
    func setUpSearchBar(){
        //Setup and put searchBar in navigationBar
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Pick a restaurant."
        self.searchBar.backgroundColor = MA_Red
        self.navigationItem.titleView = searchBar
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search")
        dataHandler.getRestaurantsWhereName(startsWith: (searchBar.text?.lowercased())!, numberOfRestaurants: 10)
    }
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        print("canceled search")
//        self.dismiss(animated: true, completion: nil)
//        //self.view.endEditing(true)
//    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //DEV NOTE: Need to generalize numbers for diffrent sizes
        self.parent?.preferredContentSize = CGSize(width: self.view.frame.width, height: 300)

        //self.preferredContentSize
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(self.performSearch),
            object: nil)
        self.perform(
            #selector(self.performSearch),
            with: nil,
            afterDelay: 0.3)
        
    }
    
    
    
    func performSearch() {
        
        if self.searchBar.text == ""{
            dataHandler.getRestaurants(numberOfRestaurants: 10)
        }else{
            dataHandler.getRestaurantsWhereName(startsWith: (searchBar.text?.lowercased())!, numberOfRestaurants: 10)
        }
        
        
    }
    


 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "pickedRestaurant"{
            let destinationVC = segue.destination as! ReviewViewController
            destinationVC.pickedRestaurant = sender as? RestaurantObject
        }
        
    }
}
