//
//  loginViewController.swift
//  Vittles
//
//  Created by Jenny Kwok on 10/19/16.
//  Copyright © 2016 Jenny Kwok. All rights reserved.
//

import UIKit

class loginViewController: UIViewController,FirebaseLoginSignupDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
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
        self.dismiss(animated: true, completion: nil)
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
    
    func signupSucceeded(){
        
    }
    
    func signupFailedWithError(error:String){
        
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
