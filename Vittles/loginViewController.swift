//
//  loginViewController.swift
//  Vittles
//
//  Created by Jenny Kwok on 10/19/16.
//  Copyright © 2016 Jenny Kwok. All rights reserved.
//

import UIKit
import FirebaseAuth

class loginViewController: UIViewController,FirebaseLoginSignupDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet var swipeRecognizer: UISwipeGestureRecognizer!
    @IBOutlet var panRecognizer: UIPanGestureRecognizer!
    
    
    var lastLocation:CGPoint = CGPoint(x:0,y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(self.parent)
        
        // Do any additional setup after loading the view.
        FirebaseUserHandler.sharedInstance.firebaseLoginSignupDelegate = self
        self.loginButton.addBorder(width: 1, radius: 8, color: UIColor.white)
        self.cancelButton.addBorder(width: 1, radius: 8, color: UIColor.white)
        //self.signUpButton.addBorder(width: 0.5, radius: 8, color: UIColor.white)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "dismissLoginView", sender: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        FirebaseUserHandler.sharedInstance.loginWithEmail(email: self.emailTextField.text!, password: self.passwordTextField.text!)
    }
    
    func loginSucceeded(){
        self.performSegue(withIdentifier: "loggedIn", sender: nil)
    }
    
    func loginFailedWithError(error:String){
        self.presentSimpleAlert(title: "Error", message: "Incorrect email or password")
    }
    @IBAction func swipedDown(_ sender: UISwipeGestureRecognizer) {
        self.view.endEditing(true)
        self.panRecognizer.isEnabled = true
        print("guresture rec")
    }
    
    @IBAction func pannedDown(_ sender: UIPanGestureRecognizer) {
        
        let translation  = sender.translation(in: self.view)
        
        if lastLocation.y + translation.y < screenSize.height/2{
            return
        }
        self.view.center = CGPoint(x:lastLocation.x, y: lastLocation.y + translation.y)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.emailTextField.isFirstResponder || self.passwordTextField.isFirstResponder {
            self.panRecognizer.isEnabled = false
        }else{
            self.panRecognizer.isEnabled = true
        }
        
        
        // Remember original location
        lastLocation = self.view.center

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.view.center.y > 3*screenSize.height/4 {
            
            self.performSegue(withIdentifier: "dismissLoginView", sender: nil)
            //self.dismiss(animated: true, completion: nil)
        }else{
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.center = CGPoint(x: screenSize.width/2, y: screenSize.height/2)
            })
            
        }

    }
    

}
