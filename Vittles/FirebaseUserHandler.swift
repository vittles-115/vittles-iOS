//
//  FirebaseLoginSignupHandler.swift
//  Vittles
//

import Foundation
import Firebase

protocol FirebaseLoginSignupDelegate {
    //Login Callbacks
    func loginSucceeded()
    func loginFailedWithError(error:String)

    //Signup Callbacks
    func signupSucceeded()
    func signupFailedWithError(error:String)

}

@objc protocol FirebaseProfileDelegate{
    @objc optional func didLoadUserProfile()
    @objc optional func failedToLoadUserProfile()
}

class FirebaseUserHandler{
    
    var firebaseLoginSignupDelegate:FirebaseLoginSignupDelegate?
    var firebaseProfileDelegate:FirebaseProfileDelegate?
    static let sharedInstance = FirebaseUserHandler()
    static var currentUserDictionary:NSDictionary?
    static var currentUDID:String?
    
    func loginWithEmail(email:String, password:String){
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                self.firebaseLoginSignupDelegate?.loginFailedWithError(error: error.localizedDescription)
                print("login fail")
                return
            }
            print("login success")
            self.firebaseLoginSignupDelegate?.loginSucceeded()
            self.getCurrentUser()
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
    
    func logoutCurrentUser(){
        try! FIRAuth.auth()?.signOut()
        FirebaseUserHandler.currentUserDictionary = nil
        FirebaseUserHandler.currentUDID = nil
    }
    
    private func getCurrentUser(){
        guard FIRAuth.auth()?.currentUser != nil else{
            return
        }
        
        FirebaseUserRef.child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? NSDictionary else{
                self.firebaseProfileDelegate?.failedToLoadUserProfile?()
                return
            }
            FirebaseUserHandler.currentUserDictionary = userDictionary
            FirebaseUserHandler.currentUDID = (FIRAuth.auth()?.currentUser?.uid)!
            self.firebaseProfileDelegate?.didLoadUserProfile?()
            
            
        }) { (error) in
            print(error.localizedDescription)
            self.firebaseProfileDelegate?.failedToLoadUserProfile?()
        }
    }
    
}
