//
//  ReviewViewController.swift
//  Vittles
//


import UIKit
import Cosmos
import FirebaseAuth
import Firebase

class ReviewViewController: UIViewController,UITextFieldDelegate, UITextViewDelegate, UIPopoverPresentationControllerDelegate,FirebaseDataHandlerDelegate {

    @IBOutlet weak var restaurantTextfield: UITextField!
    @IBOutlet weak var restaurantLabelView: UIView!
    @IBOutlet weak var reviewTitleTextfield: UITextField!
    @IBOutlet weak var reviewBodyTextView: UITextView!
    @IBOutlet weak var startRatingView: CosmosView!
    
    @IBOutlet weak var overlayView: UIView!
    
    
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
        if self.pickedDish != nil{
            self.dishTextfield.text = pickedDish?.name
            self.restaurantTextfield.text = pickedDish?.restaurantName
        }
        
        addBottomDivider(self.reviewBodyTextView, thickness: 1, color: UIColor(red: 235.0/255, green: 235.0/255, blue: 235.0/255, alpha: 0.8))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if self.pickedDish != nil{
            self.dishTextfield.text = pickedDish?.name
            self.restaurantTextfield.text = pickedDish?.restaurantName
        }
        
        guard FirebaseUserHandler.currentUDID != nil else {
            self.presentSimpleAlert(title: "Whoops!", message: "You are not currently logged in.")
            return
        }

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
        
        if let childVC = self.childViewControllers.first as? MAPostPictureCollectionViewController{
            childVC.imagesToPost.removeAll()
            childVC.collectionView?.reloadData()
        }
        
        guard self.restaurantTextfield != nil else {
            return
        }
        guard self.dishTextfield != nil else {
            return
        }
        guard self.restaurantTextfield != nil else {
            return
        }
        guard self.reviewTitleTextfield != nil else {
            return
        }
        guard self.reviewBodyTextView != nil else {
            return
        }
        self.restaurantTextfield.text = ""
        self.dishTextfield.text = ""
        self.reviewTitleTextfield.text = ""
        self.reviewBodyTextView.text = "Type review here"
        self.view.endEditing(true)
    }
    
    @IBAction func postButtonPressed(_ sender: AnyObject) {
        let reviewBody = reviewBodyTextView.text
        guard reviewBodyTextView.text != "Type review here" else {
            self.presentSimpleAlert(title: "Whoops!", message: "Please enter a your review.")
            return
        }
        
        let rating = startRatingView.rating
        
        guard let reviewerUDID = FIRAuth.auth()?.currentUser?.uid else {
            self.presentSimpleAlert(title: "Whoops!", message: "You are not currently logged in.")
            return
        }

        
        guard reviewTitleTextfield.text != "" else {
            self.presentSimpleAlert(title: "Whoops!", message: "Please enter a title for the review.")
            return
        }
       
        //NOTE: need to update this after we have login / signup
        //NOTE: need to add check to see if user has correct date set on device
        
        var aReview:ReviewObject?
        if let username = FirebaseUserHandler.currentUserObject?.name{
            aReview = ReviewObject(title: reviewTitleTextfield.text!, body: reviewBody!, rating: rating, reviewer_name: username, reviewer_UDID: reviewerUDID,date: NSDate())
        }else{
              aReview = ReviewObject(title: reviewTitleTextfield.text!, body: reviewBody!, rating: rating, reviewer_name: " ", reviewer_UDID: reviewerUDID,date: NSDate())
        }
        
//        let aReview = ReviewObject(title: reviewTitleTextfield.text!, body: reviewBody!, rating: rating, reviewer_name: "Jenny Kwok", reviewer_UDID: reviewerUDID,date: NSDate())
        dataHandler.postReviewFor(dishID: (self.pickedDish?.uniqueID)!, reviewDictionary: (aReview?.asDictionary())!)
        self.view.endEditing(true)
        
        
        let childVC = self.childViewControllers.first as! MAPostPictureCollectionViewController
        for image in childVC.imagesToPost{
            FirebaseImageHandler.uploadImage(for: pickedDish!, image: image, uploaderUDID: reviewerUDID)
        }
        
    }
    
    func successPostingReview() {
        //presentSimpleAlert(title: "Success!", message: "Successfully posted review!")
        
        let message = "Your review has successfully been posted!"
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.alert)

        
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler:{(actionSheet: UIAlertAction) in ((self.doneButtonPressed() ) )}  ))
        
        //Persent alert
        self.present(alert, animated: true, completion: nil)

    }
    
    func doneButtonPressed(){
        pushFoodDetailVC(self.pickedDish!)
        self.clearButtonPressed(self)
    }
    
    func failurePostingReview() {
        presentSimpleAlert(title: "Failed!", message: "Failed to posted review!")

    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == " Type review here"{
            textView.text = ""
            textView.textColor = UIColor.black
            textView.layer.opacity = 1
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = " Type review here"
            textView.textColor = UIColor.lightGray
            textView.layer.opacity = 0.8
            textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
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
