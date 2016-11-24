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

    var profileOptions = ["Your Reviews","Your Pictures","Login / Signup"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorColor = UIColor.clear
        
        if FirebaseUserHandler.currentUDID != nil{
            profileOptions[2] = "Log Out"
        }else{
            profileOptions[2] = "Login / Signup"
        }
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
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
            if FirebaseUserHandler.currentUDID != nil{
                profileOptions[2] = "Login / Signup"
                parentVC.clearUserProfile()
                parentVC.presentSimpleAlert(title: "Logged Out!", message: "You have been logged out.")
                FirebaseUserHandler.sharedInstance.logoutCurrentUser()
            }else{
                parentVC.performSegue(withIdentifier: "showLogin", sender: nil)
                parentVC.darkOverlayView.isHidden = false
                parentVC.navigationController?.navigationBar.layer.zPosition = -1;
            }
            
            self.tableView.reloadData()
            break
        default:
            break
        }
       
    }

    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
