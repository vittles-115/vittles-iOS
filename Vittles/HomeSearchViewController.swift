//
//  HomeSearchViewController.swift
//  Vittles
//


import UIKit

class HomeSearchViewController: UIViewController,UISearchBarDelegate {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var foodDishContainer: UIView!
    @IBOutlet weak var resturantContainer: UIView!
    
    var restaurantVC:RestaurantTableViewController?
    var dishVC:FoodDishTableViewController?
    
    //Create searchBar to be used in NavigationBar
    lazy var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.segmentedControl.selectedSegmentIndex = 0
        self.foodDishContainer.isHidden = false
        self.resturantContainer.isHidden = true
        setUpSearchBar()
                
        for childVC in self.childViewControllers{
            if childVC is RestaurantTableViewController{
                restaurantVC = childVC as? RestaurantTableViewController
            }
            
            if childVC is FoodDishTableViewController{
                dishVC = childVC as? FoodDishTableViewController
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Search
    
    func setUpSearchBar(){
        //Setup and put searchBar in navigationBar
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Search"
        self.searchBar.backgroundColor = MA_Red
        self.navigationItem.titleView = searchBar
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.restaurantVC?.dataHandler.getRestaurants(numberOfRestaurants: 10)
        self.dishVC?.dataHandler.getDishes(numberOfDishes: 10)
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Placeholder Code: ",searchBar.text)
        
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            dishVC?.dataHandler.getDishesWhereName(startsWith: searchBar.text!, numberOfDishes: 10)
            break
        case 1:
            restaurantVC?.dataHandler.getRestaurantsWhereName(startsWith: searchBar.text!.lowercased(), numberOfRestaurants: 10)
            break
        default:
            break
        }
        
        self.searchBar.resignFirstResponder()
    }

    // MARK: - Segment Control
    
    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {
        
        self.searchBar.text = ""
        switch sender.selectedSegmentIndex {
        case 0:
            self.foodDishContainer.isHidden = false
            self.resturantContainer.isHidden = true
            break
        case 1:
            self.foodDishContainer.isHidden = true
            self.resturantContainer.isHidden = false
            break
        default:
            break
        }
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "showFoodDetails"{
            let destinationVC = segue.destination as! FoodDetailViewController
            destinationVC.dish = sender as? DishObject
        }
    }
    

}
