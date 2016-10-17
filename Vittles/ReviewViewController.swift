//
//  ReviewViewController.swift
//  Vittles
//


import UIKit
import Cosmos
import FirebaseAuth

class ReviewViewController: UIViewController,UITextFieldDelegate, UITextViewDelegate, UIPopoverPresentationControllerDelegate,FirebaseDataHandlerDelegate {

    @IBOutlet weak var restaurantTextfield: UITextField!
    @IBOutlet weak var restaurantLabelView: UIView!
    @IBOutlet weak var reviewTitleTextfield: UITextField!
    @IBOutlet weak var reviewBodyTextView: UITextView!
    @IBOutlet weak var startRatingView: CosmosView!
    
    var pickedRestaurant:RestaurantObject?
    var pickedDish:DishObject?
    
    var dataHandler:FirebaseDataHandler = FirebaseDataHandler()
    
    @IBOutlet var swipeGuestureRecognizer: UISwipeGestureRecognizer!
    
    @IBOutlet weak var dishTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        restaurantTextfield.delegate = self
        dishTextfield.delegate = self
        reviewTitleTextfield.delegate = self
        reviewBodyTextView.delegate = self
        dataHandler.delegate = self
        
        self.title = "Review"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("text field editing")
        if textField == self.restaurantTextfield {
            self.view.endEditing(true)
            self.performSegue(withIdentifier: "showRestaurantPicker", sender: self)
        }
        
        if textField == self.dishTextfield {
            
            guard self.pickedRestaurant != nil else {
                self.presentSimpleAlert(title: "Whoops!", message: "Please pick a restaurant first.")
                return
            }
            self.view.endEditing(true)
            self.performSegue(withIdentifier: "showMenuPicker", sender: self)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

    @IBAction func didFinishPickingRestaurant(_ segue: UIStoryboardSegue) {
        print("returned from pick   ", self.pickedRestaurant?.name)
        guard (self.pickedRestaurant?.name) != nil else{
            return
        }
        self.restaurantTextfield.text = self.pickedRestaurant?.name
    }
    
    @IBAction func didFinishPickingDish(_ segue: UIStoryboardSegue) {
    
        guard (self.pickedDish?.name) != nil else{
            return
        }
        self.dishTextfield.text = self.pickedDish?.name
    }

    @IBAction func swipedDown(_ sender: AnyObject) {
        self.reviewBodyTextView.resignFirstResponder()
        self.reviewTitleTextfield.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func clearButtonPressed(_ sender: AnyObject) {
        self.pickedRestaurant = nil
        self.pickedDish = nil
        self.restaurantTextfield.text = ""
        self.dishTextfield.text = ""
        self.reviewTitleTextfield.text = ""
        self.reviewBodyTextView.text = ""
        self.view.endEditing(true)
    }
    
    @IBAction func postButtonPressed(_ sender: AnyObject) {
        guard let reviewBody = reviewBodyTextView.text else {
            self.presentSimpleAlert(title: "Whoops!", message: "Please enter a your review.")
            return
        }
        
        let rating = startRatingView.rating
        
        guard let reviewerUDID = FIRAuth.auth()?.currentUser?.uid else {
            self.presentSimpleAlert(title: "Whoops!", message: "You are not currently logged in.")
            return
        }
        
//        guard let reviewerName =  FIRAuth.auth()?.currentUser?.displayName else {
//            self.presentSimpleAlert(title: "Whoops!", message: "You are not currently logged in.")
//            return
//        }
        
        guard let reviewTitle = reviewTitleTextfield.text else {
            self.presentSimpleAlert(title: "Whoops!", message: "Please enter a title for the review.")
            return
        }
       
        //NOTE: need to update this after we have login / signup
       let aReview = ReviewObject(title: reviewTitle, body: reviewBody, rating: rating, reviewer_name: "Jenny Kwok", reviewer_UDID: reviewerUDID)
        dataHandler.postReviewFor(dishID: (self.pickedDish?.uniqueID)!, reviewDictionary: aReview.asDictionary())
        self.view.endEditing(true)
        
    }
    
    func successPostingReview() {
        presentSimpleAlert(title: "Success!", message: "Successfully posted review!")
        self.clearButtonPressed(self)
    }
    
    func failurePostingReview() {
        presentSimpleAlert(title: "Failed!", message: "Failed to posted review!")

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showRestaurantPicker"{
            
            let destinationVC = segue.destination as! UINavigationController
            //let rootVC = destinationVC.viewControllers.first
            let controller = destinationVC.popoverPresentationController;
            controller?.sourceView = self.view
            controller?.sourceRect = CGRect(x:self.view.bounds.midX, y:self.view.bounds.midY,width: 0, height: 0)
            controller?.delegate = self
            
        }
        
        if segue.identifier == "showMenuPicker"{
            let destinationVC = segue.destination as! UINavigationController
            
            let rootView = destinationVC.viewControllers.first as! ReviewPickDishMainViewController
            rootView.restaurant = self.pickedRestaurant
            let controller = destinationVC.popoverPresentationController;
            controller?.sourceView = self.view
            controller?.sourceRect = CGRect(x:self.view.bounds.midX, y:self.view.bounds.midY,width: 0, height: 0)
            controller?.delegate = self
            
        }
    }
    

}