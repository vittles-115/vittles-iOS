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
    
    var imagePicker: ImagePickerHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker = ImagePickerHandler(currentViewController: self, withCropping: true)
        imagePicker!.delegate = self
        
        profileImageView.setCornerRadius(9)
        self.setUserProfile()
        FirebaseUserHandler.sharedInstance.firebaseProfileDelegate = self
        
        
//        var loadingImages = [UIImage]()
//        for i in 1 ... 7{
//            let image = UIImage(named: "icons\(i)")
//            print("icons\(i)")
//            loadingImages.append(image!)
//        }
//        loadingImages.reverse()
//        
//        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
//        
//        let loadingIndicator = DPLoadingIndicator(frame: rect, loadingImages: loadingImages)
//        loadingIndicator.center = self.view.center
//        self.view.addSubview(loadingIndicator)
        
       
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
        self.setUserProfile()
    }
    
    func setUserProfile(){
        if FIRAuth.auth()?.currentUser != nil{
            self.usernameLabel.text = FIRAuth.auth()?.currentUser?.email
            let currentUserDict = FirebaseUserHandler.currentUserDictionary
            
            print(FirebaseUserHandler.currentUDID)
            print(FirebaseUserHandler.currentUserDictionary?.object(forKey: FirebaseUserKey_thumbnail_URL))
            
            
            guard let currentUDID = FirebaseUserHandler.currentUDID else{
                return
            }
            
            guard let currentUser = FirebaseObjectConverter.dictionaryToUserObject(dictionary: currentUserDict!, UDID: currentUDID) else{
                return
            }
            print("user image url :",(currentUser.thumbnail_URL))
            self.profileImageView.kf.setImage(with: URL(string: (currentUser.thumbnail_URL)), placeholder: UIImage(named: "icons1")!)
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
    }

}
