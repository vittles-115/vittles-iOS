//
//  FirebaseLoginSignupHandler.swift
//  Vittles
//


/*-----------------FirebaseUserHandler-----------------
 Purpose of this class is to manage all user data between the app and Firebase.
 All data should pass though this class and use callbacks to provide updates to the UI.
 Includes handling:
    - User Login / Signup
    - Logout
    - Profile updates
    - Save dishes / restaurants
 */

import Foundation
import Firebase

typealias UserProfileCallback = (NSDictionary?) -> Void

@objc protocol FirebaseLoginSignupDelegate {
    //Login Callbacks
    @objc optional func loginSucceeded()
    @objc optional func loginFailedWithError(error:String)

    //Signup Callbacks
    @objc optional func signupSucceeded(user:FIRUser)
    @objc optional func signupFailedWithError(error:String)

}

@objc protocol FirebaseProfileDelegate{
    @objc optional func didLoadUserProfile()
    @objc optional func failedToLoadUserProfile()
}

@objc protocol FirebaseSaveDelegate{
    //Save / Update Methods
    @objc optional func didUpdateSaveDish()
    @objc optional func didUpdateSaveRestaurant()
    
    @objc optional func failedToUpdateSaveDish()
    @objc optional func failedToUpdateSaveRestaurant()
    
    //Fetching Methods
    @objc optional func didFetchSavedDishes(dishes:NSDictionary)
    @objc optional func failedToFetchSavedDishes(error:String)
    
    @objc optional func didFetchSavedRestaurants()
    @objc optional func failedToFetchSavedRestaurants(error:String)
}


class FirebaseUserHandler{
    
    var firebaseLoginSignupDelegate:FirebaseLoginSignupDelegate?
    var firebaseProfileDelegate:FirebaseProfileDelegate?
    var firebaseSaveDegate:FirebaseSaveDelegate?
    
    static let sharedInstance = FirebaseUserHandler()
    static var currentUserDictionary:NSDictionary?
    static var currentUDID:String?
    static var currentUserObject:UserObject?

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
                self.firebaseLoginSignupDelegate?.loginFailedWithError?(error: error.localizedDescription)
                print("login fail")
                return
            }
            print("login success")
            self.firebaseLoginSignupDelegate?.loginSucceeded?()
            self.getCurrentUser()
        }
    }
    
    func signupWithEmail(email:String, password:String){
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                self.firebaseLoginSignupDelegate?.signupFailedWithError?(error: error.localizedDescription)
                return
            }
        
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: loggedInNotificationKey), object: self)
            self.firebaseLoginSignupDelegate?.signupSucceeded?(user: user!)
        }
    }
    
    func setUserProfile(UDID:String, name:String, generalLocation:String, profileURL:String){
        
        FirebaseUserRef.child(UDID).child(FirebaseUserKey_name).setValue(name)
        FirebaseUserRef.child(UDID).child(FirebaseUserKey_generalLocation).setValue(generalLocation)
        FirebaseUserRef.child(UDID).child(FirebaseUserKey_thumbnail_URL).setValue(profileURL)
        self.getCurrentUser()
    }
    
    func logoutCurrentUser(){
        try! FIRAuth.auth()?.signOut()
      
        FirebaseUserHandler.currentUserDictionary = nil
        FirebaseUserHandler.currentUDID = nil
        FirebaseUserHandler.currentUserObject = nil
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
            if FirebaseUserHandler.currentUserDictionary == nil{
                FirebaseUserHandler.currentUserDictionary = userDictionary
                NotificationCenter.default.post(name: Notification.Name(rawValue: loggedInNotificationKey), object: self)
            }else{
                FirebaseUserHandler.currentUserDictionary = userDictionary
            }
            FirebaseUserHandler.currentUserObject = FirebaseObjectConverter.dictionaryToUserObject(dictionary: userDictionary, UDID: (FIRAuth.auth()?.currentUser?.uid)!)
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
            
            var savedDishDict:NSMutableDictionary?
            if let savedDictionary = FirebaseUserHandler.currentUserDictionary?.object(forKey: "SavedDishes") as? NSMutableDictionary{
                savedDishDict = savedDictionary
            }else{
                savedDishDict = NSMutableDictionary()
            }
            
            
            guard let value = (snapshot.value as? Bool) else{
                FirebaseSavedDishRef(for: UDID).child(dishID).setValue(true)
                savedDishDict?.setValue(true, forKey: dishID)
                self.firebaseSaveDegate?.didUpdateSaveDish?()
                return
            }
            FirebaseSavedDishRef(for: UDID).child(dishID).setValue(!value)
            savedDishDict?.setValue(!value, forKey: dishID)
            self.firebaseSaveDegate?.didUpdateSaveDish?()
            self.getCurrentUser()
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
            
            
            guard FirebaseUserHandler.currentUserDictionary != nil else{
                self.firebaseSaveDegate?.failedToUpdateSaveDish?()
                return
            }
            
            var savedRestDict:NSMutableDictionary?
            
            if let savedDict = FirebaseUserHandler.currentUserDictionary?.object(forKey: "SavedRestaurants") as? NSMutableDictionary{
                savedRestDict = savedDict
            }else{
                savedRestDict = NSMutableDictionary()
            }
            
            guard let value = (snapshot.value as? Bool) else{
                FirebaseSavedRestaurantRef(for: UDID).child(restaurantID).setValue(true)
                savedRestDict?.setValue(true, forKey: restaurantID)
                self.firebaseSaveDegate?.didUpdateSaveDish?()
                return
            }
            FirebaseSavedRestaurantRef(for: UDID).child(restaurantID).setValue(!value)
            savedRestDict?.setValue(!value, forKey: restaurantID)
            self.firebaseSaveDegate?.didUpdateSaveRestaurant?()
        }) { (error) in
            self.firebaseSaveDegate?.failedToUpdateSaveDish?()
        }
        
    }
    
}
