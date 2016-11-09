//
//  FoodDishTableViewController.swift
//  Vittles
//


import UIKit

class FoodDishTableViewController: UITableViewController ,FirebaseDataHandlerDelegate,FirebaseSaveDelegate{

    var dataHandler:FirebaseDataHandler = FirebaseDataHandler()
    var dishes:[DishObject] = [DishObject]()
    var loadingIndicator = DPLoadingIndicator.loadingIndicator()
//    var refreshControl: UIRefreshControl?
    var currentSwipeIndex:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "MAFoodItemTableViewCell", bundle: nil), forCellReuseIdentifier: "foodCell")
        dataHandler.delegate = self
        dataHandler.getDishes(numberOfDishes: 10)
        
        NotificationCenter.default.addObserver(self, selector: #selector(FoodDishTableViewController.reload), name: NSNotification.Name(rawValue: loggedInNotificationKey), object: nil)
        
        self.setUpRefreshControl()
        let centerHeightPt = self.tableView.frame.height/2 - screenSize.height/6 - self.tableView.contentOffset.y
        let centerPoint = CGPoint(x: self.tableView.frame.width/2 , y: centerHeightPt)
        self.loadingIndicator.center = centerPoint
        
        self.view.addSubview(loadingIndicator)
        
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
        return dishes.count
    }
    
    //Row hieght of 80
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> MAFoodItemTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as! MAFoodItemTableViewCell

        // Configure the cell...
        cell.setupCell(fromDish: dishes[indexPath.row])

        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }

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
            dataHandler.getDishes(numberOfDishes:10)
        }else{
            dataHandler.getDishesWhereName(startsWith: parentVC.searchBar.text!, numberOfDishes: 10)
        }
        
    }
    //Hide keyboard when tableview moves
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        (self.parent as? HomeSearchViewController)?.searchBar.resignFirstResponder()
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.parent?.performSegue(withIdentifier: "showFoodDetails", sender: self.dishes[indexPath.row])
    }
    
    func showStarPopUp(){
        let popup = popupFadeIn(self.view, imageName: "SavePopup")
        popupFadeOut(popup)
    }
    
    
    func didFetchDishes(value:NSDictionary?) {
        self.refreshControl?.endRefreshing()
        self.dishes = FirebaseObjectConverter.dishArrayFrom(dictionary: value!)
        self.tableView.reloadData()
        self.loadingIndicator.isHidden = true

        //print("dishes",foodArray)
    }
    
    func failedToFetchDishes(errorString: String) {
        self.refreshControl?.endRefreshing()
        print("error is: ",errorString)
        self.dishes.removeAll()
        self.tableView.reloadData()
        self.loadingIndicator.isHidden = true
    }
    
    func willBeginTask(){
        self.loadingIndicator.isHidden = false
    }
    
    func didUpdateSaveDish() {
        guard self.currentSwipeIndex != nil else {
            return
        }
        self.tableView.reloadRows(at: [self.currentSwipeIndex!], with: .right)
    }
    
    func failedToUpdateSaveDish(){
        self.presentSimpleAlert(title: "Failed to Save!", message: "You are not logged in! Please log in to save dishes and restaurants")
        self.tableView.reloadRows(at: [self.currentSwipeIndex!], with: .right)
    }
    
    func reload(){
        self.tableView.reloadData()
    }
}
