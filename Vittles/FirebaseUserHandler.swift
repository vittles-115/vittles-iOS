//
//  FirebaseLoginSignupHandler.swift
//  Vittles
//

import Foundation
import Firebase

protocol FirebaseLoginSignupDelegate {
    //Login Callbacks
    func loginSucceeded();
    func loginFailedWithError(error:String);
    
    //Signup Callbacks
    func signupSucceeded();
    func signupFailedWithError(error:String);
}

class FirebaseUserHandler{
    
    var firebaseLoginSignupDelegate:FirebaseLoginSignupDelegate?
    
    static let sharedInstance = FirebaseUserHandler()
    
    func loginWithEmail(email:String, password:String){
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                self.firebaseLoginSignupDelegate?.loginFailedWithError(error: error.localizedDescription)
                return
            }
            self.firebaseLoginSignupDelegate?.loginSucceeded()
        }
    }
    
    func signupWithEmail(email:String, password:String){
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                self.firebaseLoginSignupDelegate?.signupFailedWithError(error: error.localizedDescription)
                return
            }
            self.firebaseLoginSignupDelegate?.signupSucceeded()
        }
    }
    
}
