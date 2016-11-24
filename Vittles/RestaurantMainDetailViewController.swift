//
//  RestaurantMainDetailViewController.swift
//  Vittles
//
//  Created by Jenny Kwok on 10/18/16.
//  Copyright © 2016 Jenny Kwok. All rights reserved.
//

import UIKit
import MapKit

class RestaurantMainDetailViewController: UIViewController,UISearchBarDelegate {

    @IBOutlet weak var pickMenuContainer: UIView!
    @IBOutlet weak var searchMenuContainer: UIView!
    
    
    @IBOutlet weak var savedStarImageView: UIImageView!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantAddressLabel: UILabel!
    @IBOutlet weak var foodTypeLabel: UILabel!
    
    
    @IBOutlet weak var directionsButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var restaurant:RestaurantObject?
    var dataHandler:FirebaseDataHandler = FirebaseDataHandler()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //temporarly hide
        //searchBar.delegate = self
        //self.searchBar.isHidden = true
        
        pickMenuContainer.isHidden = false
        //searchMenuContainer.isHidden = true
        
        for vc in self.childViewControllers{
            if vc is RestaurantPickMenuTableViewController{
                let childVC = vc as! RestaurantPickMenuTableViewController
                childVC.restaurant = self.restaurant
            }
            
            if vc is RestaurantSearchTableViewController{
                let childVC = vc as! RestaurantSearchTableViewController
                dataHandler.delegate = childVC
            }
        }
        
        self.restaurantImageView.setCornerRadius(9)
        self.restaurantImageView.kf.setImage(with: URL(string: (restaurant?.imageURL!)!), placeholder: UIImage(named: "placeholderPizza")!)
        self.restaurantNameLabel.text = restaurant?.name
        self.restaurantAddressLabel.text = restaurant?.address
        self.foodTypeLabel.text = restaurant?.categories?.joined(separator: ",")
        self.foodTypeLabel.text = self.foodTypeLabel.text?.substring(to: (self.foodTypeLabel.text?.endIndex)!)
        
        self.saveButton.setCornerRadius(9)
        self.directionsButton.setCornerRadius(9)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Star Saved Indicator
        if (FirebaseUserHandler.currentUserDictionary?.object(forKey: "SavedRestaurants") as? NSDictionary)?.object(forKey: restaurant?.uniqueID ) as? Bool == true{
            self.saveButton.backgroundColor = MA_Yellow
            self.saveButton.setTitleColor(UIColor.white, for: .normal)
            self.saveButton.setTitle("Saved", for: .normal)
        }else{
            self.saveButton.backgroundColor = MA_ButtonGray
            self.saveButton.setTitleColor(UIColor.darkGray, for: .normal)
            self.saveButton.setTitle("Save", for: .normal)
        }

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        pickMenuContainer.isHidden = true
        searchMenuContainer.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        pickMenuContainer.isHidden = false
        searchMenuContainer.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getDirectionsPressed(_ sender: Any) {
       // UIApplication.shared.openURL(NSURL(string: "http://maps.apple.com/?address=1600%PennsylvaniaAve.%20500")! as URL)
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString((restaurant?.address)!) { placemarks, error in
            if let placemark = placemarks?[0]{
                let mapitem = MKMapItem(placemark: MKPlacemark(placemark: CLPlacemark(placemark: placemark)))
                let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                mapitem.openInMaps(launchOptions: options)
                
            }

        }

    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        guard FirebaseUserHandler.currentUDID != nil else {
            self.presentSimpleAlert(title: "Failed to Save!", message: "You are not logged in! Please log in to save dishes and restaurants")
            return
        }
       
        FirebaseUserHandler.sharedInstance.updateSavedRestaurant(for: (self.restaurant?.uniqueID)!)
        
        if self.saveButton.backgroundColor == MA_ButtonGray{
            self.saveButton.backgroundColor = MA_Yellow
            self.saveButton.setTitleColor(UIColor.white, for: .normal)
            self.saveButton.setTitle("Saved", for: .normal)
        }else{
            self.saveButton.backgroundColor = MA_ButtonGray
            self.saveButton.setTitleColor(UIColor.darkGray, for: .normal)
            self.saveButton.setTitle("Save", for: .normal)
        }
        

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
