//
//  MAProfileOptionsTableViewController.swift
//  MenuApp
//
//  Created by Jenny Kwok on 2/26/16.
//  Copyright © 2016 Jenny. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class MAProfileOptionsTableViewController: UITableViewController {

    var profileOptions = ["Your Reviews","Your Pictures","Help/Documentation","Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.separatorColor = UIColor.clear
        
        print(FIRAuth.auth()?.currentUser)
        
        if FIRAuth.auth()?.currentUser != nil{
            profileOptions[3] = "Log Out"
        }else{
            profileOptions[3] = "Login"
        }
        
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
        return 4
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> MAProfileOptionTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileOptionCell", for: indexPath) as! MAProfileOptionTableViewCell

        // Configure the cell...
        cell.addBottomDivider(1, color: MA_BGGray)
        cell.optionLabel.text = self.profileOptions[(indexPath as NSIndexPath).row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let parentVC = self.parent as! ProfileMainViewController
        
        switch indexPath.row {
        case 0:
            parentVC.performSegue(withIdentifier: "showUserReviews", sender: nil)
            break
        case 1:
            parentVC.performSegue(withIdentifier: "showUserUploadeImages", sender: nil)
            break
        case 2:
            break
        case 3:
            if FIRAuth.auth()?.currentUser != nil{
                profileOptions[3] = "Login"
                parentVC.clearUserProfile()
                FirebaseUserHandler.sharedInstance.logoutCurrentUser()
            }else{
                parentVC.performSegue(withIdentifier: "showLogin", sender: nil)
            }
            
            self.tableView.reloadData()
            break
        default:
            break
        }
       
    }

//    
//    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//    
//
//    override  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle{
//        
//        return UITableViewCellEditingStyle.none;
//        
//    }
//    
//    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
//        let item = profileOptions[(fromIndexPath as NSIndexPath).row]
//        profileOptions.remove(at: (fromIndexPath as NSIndexPath).row)
//        profileOptions.insert(item, at: (toIndexPath as NSIndexPath).row)
//    }
//    
//
//    
//    // Override to support conditional rearranging of the table view.
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//        
//    }



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
