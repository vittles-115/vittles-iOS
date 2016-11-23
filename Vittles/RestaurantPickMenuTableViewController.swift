//
//  RestaurantPickMenuTableViewController.swift
//  Vittles
//
//  Created by Jenny Kwok on 10/16/16.
//  Copyright © 2016 Jenny Kwok. All rights reserved.
//

import UIKit

class RestaurantPickMenuTableViewController: UITableViewController {

    var restaurant:RestaurantObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = restaurant?.name
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
        
        guard restaurant?.menuTitles != nil else {
            return 0
        }
        return (restaurant?.menuTitles?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuTitleCells", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = restaurant?.menuTitles?[indexPath.row]

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showSelectedMenu", sender: restaurant?.menuTitles?[indexPath.row])
    }
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSelectedMenu"{
            let destinationVC = segue.destination as! RestaurantMenuTableViewController
            destinationVC.restaurant = self.restaurant
            destinationVC.selectedMenu = sender as? String
            
        }
    }
    

}
