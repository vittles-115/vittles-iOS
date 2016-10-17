//
//  ReviewPickDishMainViewController.swift
//  Vittles
//
//  Created by Jenny kwok on 10/16/16.
//  Copyright © 2016 Jenny Kwok. All rights reserved.
//

import UIKit

class ReviewPickDishMainViewController: UIViewController,UISearchBarDelegate {

    var backButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var containerView: UIView!
    
    lazy var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var dataHandler:FirebaseDataHandler = FirebaseDataHandler()
    var restaurant:RestaurantObject?
    var viewDefualtSize:CGSize?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //dataHandler.delegate = childViewControllers.first as! REvi
        
        let childVC = self.childViewControllers.first as! UINavigationController
        let rootVC = childVC.viewControllers.first as! ReviewPickMenuTableViewController
        rootVC.restaurant = self.restaurant
        setUpSearchBar()
        
        self.backButton = UIBarButtonItem(title: " Back ", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backButtonPressed))
        
        self.cancelButton = UIBarButtonItem(title: " cancel ", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelButtonPressed))
        
        self.navigationItem.setRightBarButton(cancelButton, animated: false)
        
        viewDefualtSize = CGSize(width: self.view.frame.width, height: 430)
        //self.backButton.style = UIBarButtonItemStyle.plain
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpSearchBar(){
        //Setup and put searchBar in navigationBar
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Pick a dish."
        self.searchBar.backgroundColor = MA_Red
        self.navigationItem.titleView = searchBar
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        self.parent?.preferredContentSize = CGSize(width: self.view.frame.width, height: 300)
        let childVC = self.childViewControllers.first as! UINavigationController
        let rootVC = childVC.viewControllers.first as! ReviewPickMenuTableViewController
        rootVC.performSegue(withIdentifier: "showSearchResults", sender: nil)
    }
    
    func cancelButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func backButtonPressed(_ sender: AnyObject) {
        let childVC = self.childViewControllers.first as! UINavigationController
        self.searchBar.resignFirstResponder()
        parent?.preferredContentSize = viewDefualtSize!
        childVC.popViewController(animated: true)
    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        print("search")
//        dataHandler.getRestaurantsWhereName(startsWith: (searchBar.text?.lowercased())!, numberOfRestaurants: 10)
//    }
//    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
