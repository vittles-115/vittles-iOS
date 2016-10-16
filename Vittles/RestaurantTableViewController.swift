//
//  RestaurantTableViewController.swift
//  Vittles
//


import UIKit

class RestaurantTableViewController: UITableViewController,FirebaseDataHandlerDelegate {

    var dataHandler:FirebaseDataHandler = FirebaseDataHandler()
    var restaurants:[RestaurantObject] = [RestaurantObject]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "MARestaurantTableViewCell", bundle: nil), forCellReuseIdentifier: "restaurantCell")
        dataHandler.delegate = self
        dataHandler.getRestaurants(numberOfRestaurants: 10)
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
        return self.restaurants.count
    }
    
    //Row hieght of 80
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> MARestaurantTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath) as! MARestaurantTableViewCell

        // Configure the cell...
        cell.setUpCell(restaurant: restaurants[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showMenus", sender: restaurants[indexPath.row])
    }
    
    //Hide keyboard when tableview moves
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        (self.parent as? HomeSearchViewController)?.searchBar.resignFirstResponder()
    
    }
    
    func didFetchRestaurants(value:NSDictionary?){
        self.restaurants = FirebaseObjectConverter.restaurantArrayFrom(dictionary: value!)
        self.tableView.reloadData()
    }
    
    func failedToFetchRestaurants(errorString:String){
        print("failed to fetch restaurant: ", errorString)
    }

 

   
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMenus"{
            let destinationVC = segue.destination as! RestaurantPickMenuTableViewController
            destinationVC.restaurant = sender as? RestaurantObject
        }
    }
    

}
