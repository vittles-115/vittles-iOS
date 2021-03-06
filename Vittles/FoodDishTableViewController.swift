//
//  FoodDishTableViewController.swift
//  Vittles
//


import UIKit
import FirebaseAuth

class FoodDishTableViewController: UITableViewController ,FirebaseDataHandlerDelegate,FirebaseSaveDelegate{

    var dataHandler:FirebaseDataHandler = FirebaseDataHandler()
    var dishes:[DishObject] = [DishObject]()
    var loadingIndicator = DPLoadingIndicator.loadingIndicator()
    var currentSwipeIndex:IndexPath?
    var isFetching:Bool = false
    
    var lastObjectFetched:Any?
    
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
        
        if dishes.count > 0{
            return dishes.count
        }else{
            return 1
        }
        
    }
    
    //Row hieght of 80
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if dishes.count == 0{
            return tableView.frame.height
        }
        
        return 80.0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if dishes.count == 0{
            let cell = UITableViewCell(frame: self.tableView.frame)
            
            let myString = "No dishes"
            let myAttribute = [ NSForegroundColorAttributeName: MA_LightGray , NSFontAttributeName: UIFont(name: "SourceSansPro-Semibold", size: 15.0)!]
            
            let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
            cell.textLabel?.attributedText = myAttrString
            cell.textLabel?.textAlignment = NSTextAlignment.center
            return cell
        }

        
        
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
            
            if FirebaseUserHandler.currentUDID != nil{
                FirebaseUserHandler.sharedInstance.updateSavedDish(for: self.dishes[indexPath.row].uniqueID)
            }else{
                self.presentSimpleAlert(title: "Failed to Save!", message: "You are not logged in! Please log in to save dishes and restaurants")
            }
            
            
            
            self.showStarPopUp()
            self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.right)
        }
        
        let addToList = UITableViewRowAction(style: .normal, title: "         ") { action, index in
//            FirebaseUserHandler.sharedInstance.updateSavedDish(for: self.dishes[indexPath.row].uniqueID)
//            self.showStarPopUp()
            //self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.right)
        }
        
        let dishID = dishes[indexPath.row].uniqueID
        
        if (FirebaseUserHandler.currentUserDictionary?.object(forKey: "SavedDishes") as? NSDictionary)?.object(forKey: dishID ) as? Bool == true{
            save.backgroundColor = UIColor(patternImage: UIImage(named: "SaveSwipe")!)
        }else{
            save.backgroundColor = UIColor(patternImage: UIImage(named: "save")!)
        }
        
        addToList.backgroundColor = UIColor(patternImage: UIImage(named: "addToList")!)
        
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
        guard parent is HomeSearchViewController else {
            self.refreshControl?.endRefreshing()
            return
        }
        
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
        
        let centerHeightPt = self.tableView.contentOffset.y - screenSize.height/6 + screenSize.height/2
        let centerPoint = CGPoint(x: self.tableView.frame.width/2 , y: centerHeightPt)
        self.loadingIndicator.center = centerPoint
        
        guard self.dishes.count > 0 else{
            return
        }
        
        if (Int(scrollView.contentOffset.y + scrollView.frame.size.height) == Int(scrollView.contentSize.height + scrollView.contentInset.bottom)) {
            if !isFetching && lastObjectFetched != nil{
                isFetching = true
                self.lastObjectFetched = dishes.last?.uniqueID
                self.dataHandler.getAdditionalDishesStarting(at: dishes.last?.uniqueID, numberOfDishes: 11)
            }
        }
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard self.dishes.count > 0 else{
            return
        }
        self.parent?.performSegue(withIdentifier: "showFoodDetails", sender: self.dishes[indexPath.row])
    }
    
    func showStarPopUp(){
        let centerHeightPt = screenSize.height/2 - screenSize.height/10
        let centerPoint = CGPoint(x: self.tableView.frame.width/2 , y: centerHeightPt)
        let popup = popupFadeIn((self.parent?.view)!, imageName: "SavePopup",centerPoint:centerPoint)
        popupFadeOut(popup)
    }
    
    
    // MARK : Delegate Methods
    
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
        if self.currentSwipeIndex != nil{
            self.tableView.reloadRows(at: [self.currentSwipeIndex!], with: .right)
        }else{
            self.tableView.reloadData()
        }
        
    }
    
    func reload(){
        self.tableView.reloadData()
    }
    
    func getLastObjectFetched(lastObject: Any?) {
        self.lastObjectFetched = lastObject
        self.loadingIndicator.isHidden = true
    }
    
    func didFetchAdditionalDishes(value: NSDictionary?) {
        isFetching = false
        print("fetched next objects")
        self.refreshControl?.endRefreshing()
        //let indexPath = NSIndexPath(row: self.dishes.count-1, section: 0)
        var newDishes =  FirebaseObjectConverter.dishArrayFrom(dictionary: value!)
        if(newDishes.count > 1){
            newDishes.remove(at: 0)
        }else{
            return
        }
        self.dishes.append(contentsOf:newDishes)
        //self.tableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        self.tableView.reloadData()
        self.loadingIndicator.isHidden = true
    }
    
}





