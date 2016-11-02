//
//  FoodDishTableViewController.swift
//  Vittles
//


import UIKit

class FoodDishTableViewController: UITableViewController ,FirebaseDataHandlerDelegate{

    var dataHandler:FirebaseDataHandler = FirebaseDataHandler()
    var dishes:[DishObject] = [DishObject]()
    var loadingIndicator = DPLoadingIndicator.loadingIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "MAFoodItemTableViewCell", bundle: nil), forCellReuseIdentifier: "foodCell")
        dataHandler.delegate = self
        dataHandler.getDishes(numberOfDishes: 10)
//            FirebaseResturantRef.child("-KTBwNgW2e3fWmLpypWj").child("lowercased_name").setValue("munch")
//            FirebaseResturantRef.child("-KTBwzEo1iRuMH8732bE").child("lowercased_name").setValue("burger.")
//                FirebaseDishRef.child("-KTD3kA15O5pPCIv_ep5").child("food_description").setValue("A tasty burger topped with grilled onions, mayo, and house made dressing.")
        
        
 
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
 
    //Hide keyboard when tableview moves
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        (self.parent as? HomeSearchViewController)?.searchBar.resignFirstResponder()
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.parent?.performSegue(withIdentifier: "showFoodDetails", sender: self.dishes[indexPath.row])
    }
    
    
    func didFetchDishes(value:NSDictionary?) {
        
        self.dishes = FirebaseObjectConverter.dishArrayFrom(dictionary: value!)
        self.tableView.reloadData()
        self.loadingIndicator.isHidden = true

        //print("dishes",foodArray)
    }
    
    func failedToFetchDishes(errorString: String) {
        print("error is: ",errorString)
        self.dishes.removeAll()
        self.tableView.reloadData()
        self.loadingIndicator.isHidden = true
    }
    
    func willBeginTask(){
        self.loadingIndicator.isHidden = false
    }
    
}
