//
//  ProfileMainViewController.swift
//  Vittles
//

import UIKit
import FirebaseAuth
import Kingfisher

class ProfileMainViewController: UIViewController,ImagePickerHandlerDelegate,FirebaseProfileDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tapToEditImageButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var darkOverlayView: UIView!
    
    var imagePicker: ImagePickerHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker = ImagePickerHandler(currentViewController: self, withCropping: true)
        imagePicker!.delegate = self
        
        profileImageView.setCornerRadius(9)
        self.setUserProfile()
        FirebaseUserHandler.sharedInstance.firebaseProfileDelegate = self
        self.darkOverlayView.isHidden = true

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func picturePressed(_ sender: AnyObject) {
        
        imagePicker?.showOptions()
        
    }
    
    // MARK: - Image Picker Delegate
    func handlerDidFinishPickingImage(_ image: UIImage) {
        
       self.profileImageView.image = image
    }

    @IBAction func didLogin(_ segue: UIStoryboardSegue) {
        self.darkOverlayView.isHidden = true
        self.navigationController?.navigationBar.layer.zPosition = 1;
        self.setUserProfile()
    }
    
    @IBAction func unwindFromLogin(_ segue: UIStoryboardSegue) {
        self.darkOverlayView.isHidden = true
        self.navigationController?.navigationBar.layer.zPosition = 1
    }
    
    func setUserProfile(){
        if FIRAuth.auth()?.currentUser != nil{
            self.usernameLabel.text = FIRAuth.auth()?.currentUser?.email
            let currentUserDict = FirebaseUserHandler.currentUserDictionary

            guard let currentUDID = FirebaseUserHandler.currentUDID else{
                return
            }
            
            guard let currentUser = FirebaseObjectConverter.dictionaryToUserObject(dictionary: currentUserDict!, UDID: currentUDID) else{
                return
            }

            self.profileImageView.kf.setImage(with: URL(string: (currentUser.thumbnail_URL)), placeholder: UIImage(named: "placeholderPizza")!)
            self.usernameLabel.text = currentUser.name
            self.locationLabel.text = currentUser.generalLocation
        }

    }
    
    func clearUserProfile(){
        self.profileImageView.image = UIImage(named:"icons1")!
        self.usernameLabel.text = "Not Logged In"
        self.locationLabel.text = ""
    }
    
    func didLoadUserProfile() {
        self.setUserProfile()
        (self.childViewControllers.first as! MAProfileOptionsTableViewController).viewDidLoad()
        (self.childViewControllers.first as! MAProfileOptionsTableViewController).tableView.reloadData()
    }

}
