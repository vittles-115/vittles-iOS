//
//  FirebaseLoginSignupHandler.swift
//  Vittles
//

import Foundation
import Firebase

typealias UserProfileCallback = (NSDictionary?) -> Void

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

@objc protocol FirebaseSaveDelegate{
    @objc optional func didUpdateSaveDish()
    @objc optional func didUpdateSaveRestaurant()
    
    @objc optional func failedToUpdateSaveDish()
    @objc optional func failedToUpdateSaveRestaurant()
}

class FirebaseUserHandler{
    
    var firebaseLoginSignupDelegate:FirebaseLoginSignupDelegate?
    var firebaseProfileDelegate:FirebaseProfileDelegate?
    var firebaseSaveDegate:FirebaseSaveDelegate?
    static let sharedInstance = FirebaseUserHandler()
    static var currentUserDictionary:NSDictionary?
    static var currentUDID:String?
    

    class func getUserPublicProfileFor(userUDID:String?,completion:@escaping UserProfileCallback){
        
        guard userUDID != nil || userUDID == "" else{
            completion(nil)
            return
        }
        
        let userRef = FirebaseUserRef.child(userUDID!)
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            guard (snapshot.value as? NSDictionary) != nil else{
                completion(nil)
                return
            }
            completion(snapshot.value as? NSDictionary)
            
        }) { (error) in
            print(error.localizedDescription)
            completion(nil)
            
        }
        
    }
    
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
    
    
    
    func updateSavedDish(for dishID:String){
        guard let UDID = FirebaseUserHandler.currentUDID else{
            self.firebaseSaveDegate?.failedToUpdateSaveDish?()
            return
        }
        
        FirebaseSavedDishRef(for: UDID).child(dishID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            guard let value = (snapshot.value as? Bool) else{
                FirebaseSavedDishRef(for: UDID).child(dishID).setValue(true)
                self.firebaseSaveDegate?.didUpdateSaveDish?()
                return
            }
            FirebaseSavedDishRef(for: UDID).child(dishID).setValue(!value)
            self.firebaseSaveDegate?.didUpdateSaveDish?()
            
        }) { (error) in
            self.firebaseSaveDegate?.failedToUpdateSaveDish?()
        }

        
    }
    
    
    func updateSavedRestaurant(for restaurantID:String){
        guard let UDID = FirebaseUserHandler.currentUDID else{
            self.firebaseSaveDegate?.failedToUpdateSaveRestaurant?()
            return
        }
        
        FirebaseSavedRestaurantRef(for: UDID).child(restaurantID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            guard let value = (snapshot.value as? Bool) else{
                FirebaseSavedRestaurantRef(for: UDID).child(restaurantID).setValue(true)
                self.firebaseSaveDegate?.didUpdateSaveDish?()
                return
            }
            FirebaseSavedRestaurantRef(for: UDID).child(restaurantID).setValue(!value)
            self.firebaseSaveDegate?.didUpdateSaveRestaurant?()
            
        }) { (error) in
            self.firebaseSaveDegate?.failedToUpdateSaveDish?()
        }
        
    }
    
    
}
