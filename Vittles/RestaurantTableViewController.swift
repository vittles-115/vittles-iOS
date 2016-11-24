//
//  RestaurantTableViewController.swift
//  Vittles
//


import UIKit

class RestaurantTableViewController: UITableViewController,FirebaseDataHandlerDelegate,FirebaseSaveDelegate {

    var dataHandler:FirebaseDataHandler = FirebaseDataHandler()
    var restaurants:[RestaurantObject] = [RestaurantObject]()
    var loadingIndicator = DPLoadingIndicator.loadingIndicator()
    var currentSwipeIndex:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "MARestaurantTableViewCell", bundle: nil), forCellReuseIdentifier: "restaurantCell")
        dataHandler.delegate = self
        dataHandler.getRestaurants(numberOfRestaurants: 10)
        
        NotificationCenter.default.addObserver(self, selector: #selector(RestaurantTableViewController.reload), name: NSNotification.Name(rawValue: loggedInNotificationKey), object: nil)
        
        self.loadingIndicator.center = self.view.center
        self.setUpRefreshControl()
        self.view.addSubview(loadingIndicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
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
        if restaurants.count == 0{
            return 1
        }
        return self.restaurants.count
    }
    
    //Row hieght of 80
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if restaurants.count == 0{
            return tableView.frame.height   
        }
        
        return 80.0
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if restaurants.count == 0{
            let cell = UITableViewCell(frame: self.tableView.frame)
            
            let myString = "No Restaurants"
            let myAttribute = [ NSForegroundColorAttributeName: MA_LightGray , NSFontAttributeName: UIFont(name: "SourceSansPro-Semibold", size: 15.0)!]
            
            let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
            cell.textLabel?.attributedText = myAttrString
            cell.textLabel?.textAlignment = NSTextAlignment.center
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath) as! MARestaurantTableViewCell

        // Configure the cell...
       
        cell.setUpCell(restaurant: restaurants[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if restaurants.count == 0{
            return
        }
        self.performSegue(withIdentifier: "showMenus", sender: restaurants[indexPath.row])
    }
    
    //Hide keyboard when tableview moves
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        (self.parent as? HomeSearchViewController)?.searchBar.resignFirstResponder()
        
        let centerHeightPt = self.tableView.contentOffset.y - screenSize.height/6 + screenSize.height/2
        let centerPoint = CGPoint(x: self.tableView.frame.width/2 , y: centerHeightPt)
        self.loadingIndicator.center = centerPoint

    
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let save = UITableViewRowAction(style: .normal, title: "         ") { action, index in
            FirebaseUserHandler.sharedInstance.updateSavedRestaurant(for: self.restaurants[indexPath.row].uniqueID)
            self.showStarPopUp()
            self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.right)
        }
        
        let restaurantID = restaurants[indexPath.row].uniqueID
        
        if (FirebaseUserHandler.currentUserDictionary?.object(forKey: "SavedRestaurants") as? NSDictionary)?.object(forKey: restaurantID ) as? Bool == true{
            save.backgroundColor = UIColor(patternImage: UIImage(named: "SaveSwipe")!)
        }else{
            save.backgroundColor = UIColor(patternImage: UIImage(named: "save")!)
        }
        
        return [save]
        
    }
    
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        self.currentSwipeIndex = indexPath
    }
    
    func setUpRefreshControl(){
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshTableView), for: UIControlEvents.valueChanged)
        self.refreshControl?.backgroundColor = UIColor.white
        self.refreshControl?.tintColor = MA_Red
        self.tableView.addSubview(self.refreshControl!)
        
    }
    
    func refreshTableView(){
        let parentVC = parent as! HomeSearchViewController
        if parentVC.searchBar.text == ""{
            dataHandler.getRestaurants(numberOfRestaurants:10)
        }else{
            dataHandler.getRestaurantsWhereName(startsWith: parentVC.searchBar.text!, numberOfRestaurants: 10)
        }
        
    }
    
    func showStarPopUp(){
        let centerHeightPt = screenSize.height/2 - screenSize.height/10
        let centerPoint = CGPoint(x: self.tableView.frame.width/2 , y: centerHeightPt)
        let popup = popupFadeIn((self.parent?.view)!, imageName: "SavePopup",centerPoint:centerPoint)
        popupFadeOut(popup)
    }
    
    
    
    func didFetchRestaurants(value:NSDictionary?){
        self.restaurants = FirebaseObjectConverter.restaurantArrayFrom(dictionary: value!)
        self.tableView.reloadData()
        self.loadingIndicator.isHidden = true
        self.refreshControl?.endRefreshing()
    }
    
    func failedToFetchRestaurants(errorString:String){
        print("failed to fetch restaurant: ", errorString)
        self.restaurants.removeAll()
        self.tableView.reloadData()
        self.loadingIndicator.isHidden = true
        self.refreshControl?.endRefreshing()
    }

    func willBeginTask(){
        self.loadingIndicator.isHidden = false
    }
 
    func didUpdateSaveRestaurant() {
        guard self.currentSwipeIndex != nil else {
            return
        }
        self.tableView.reloadRows(at: [self.currentSwipeIndex!], with: .right)
    }
   
    func failedToUpdateSaveRestaurant(){
        self.presentSimpleAlert(title: "Failed to Save!", message: "You are not logged in! Please log in to save dishes and restaurants")
        guard self.currentSwipeIndex != nil else {
            return
        }
        self.tableView.reloadRows(at: [self.currentSwipeIndex!], with: .right)
    }
    
    func reload(){
        self.tableView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMenus"{
            let destinationVC = segue.destination as! RestaurantMainDetailViewController
            destinationVC.restaurant = sender as? RestaurantObject
        }
    }
    

}
