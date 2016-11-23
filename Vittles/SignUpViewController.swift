//
//  SignUpViewController.swift
//  Vittles
//
//  Created by Jenny Kwok on 11/20/16.
//  Copyright © 2016 Jenny Kwok. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController, FirebaseLoginSignupDelegate {

    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var locationTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    
    var signupHandler = FirebaseUserHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        signupHandler.firebaseLoginSignupDelegate = self
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func createAccountPressed(_ sender: Any) {
        guard nameTextfield.text != nil && (nameTextfield.text?.characters.count)! > 5 else {
            self.presentSimpleAlert(title: "Whoops!", message: "Name needs to be at least 5 characters long.")
            return
        }
        
        guard locationTextfield.text != nil && locationTextfield.text != "" else {
            self.presentSimpleAlert(title: "Whoops!", message: "You forgot to add a location.")
            return
        }
        
        guard emailTextfield.text != nil && (emailTextfield.text?.contains("@"))! else {
            self.presentSimpleAlert(title: "Whoops!", message: "Please enter a valid email address.")
            return
        }
        
        guard passwordTextfield.text != nil && (passwordTextfield.text?.characters.count)! >= 8 else {
            self.presentSimpleAlert(title: "Whoops!", message: "Password needs to be at least 8 characters long.")
            return
        }
        
        signupHandler.signupWithEmail(email: self.emailTextfield.text!, password: self.passwordTextfield.text!)
        
    }
   

    func signupSucceeded(user:FIRUser){
        FirebaseUserRef.child(user.uid).child(FirebaseUserKey_name).setValue(self.nameTextfield.text)
        FirebaseUserRef.child(user.uid).child(FirebaseUserKey_generalLocation).setValue(self.locationTextfield.text)
        
        
        //DEV NOTE: Temporarly hardcoded image urls due to time constraints
        let default0 = "https://firebasestorage.googleapis.com/v0/b/vittles-1c0fb.appspot.com/o/defualtProfileAvatars%2FprofileDefault0.png?alt=media&token=7196fcf4-b52f-4d1b-b5ae-851518ee1af5"
        let default1 = "https://firebasestorage.googleapis.com/v0/b/vittles-1c0fb.appspot.com/o/defualtProfileAvatars%2FprofileDefault1.png?alt=media&token=7b2cb919-34fd-436c-952c-e08896137494"
        let default2 = "https://firebasestorage.googleapis.com/v0/b/vittles-1c0fb.appspot.com/o/defualtProfileAvatars%2FprofileDefault2.png?alt=media&token=cb075494-22bf-4b4b-8015-090d7a49ed07"

        switch arc4random() % 3 {
        case 0:
            FirebaseUserHandler.sharedInstance.setUserProfile(UDID: user.uid, name: self.nameTextfield.text!, generalLocation: self.locationTextfield.text!, profileURL: default0)
            break
        case 1:
            FirebaseUserHandler.sharedInstance.setUserProfile(UDID: user.uid, name: self.nameTextfield.text!, generalLocation: self.locationTextfield.text!, profileURL: default1)
            break
        case 2:
            FirebaseUserHandler.sharedInstance.setUserProfile(UDID: user.uid, name: self.nameTextfield.text!, generalLocation: self.locationTextfield.text!, profileURL: default2)
            break
        default:
            break
        }
        
        self.performSegue(withIdentifier: "loggedIn", sender: nil)
        
    }
    
    func signupFailedWithError(error:String){
        
    }

    @IBAction func swipeDown(_ sender: Any) {
        self.view.endEditing(true)
    }
    

}
