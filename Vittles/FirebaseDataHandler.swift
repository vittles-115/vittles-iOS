//
//  FirebaseDataHandler.swift
//  Vittles
//

/*-----------------FirebaseDataHandler-----------------
 Purpose of this class is to manage all general data between the app and Firebase.
 All data should pass though this class and use callbacks to provide updates to the UI.
 Includes handling:
    - Fetching Dishes
    - Fetching Restaurants
    - Fetching Reviews
 */

import Foundation
import FirebaseStorage
import FirebaseAuth
import UIKit

typealias FirebaseResponse = (NSDictionary?) -> Void

@objc protocol FirebaseDataHandlerDelegate {
    
    @objc optional func willBeginTask()
    
    @objc optional func didFetchDishes(value:NSDictionary?)
    @objc optional func didFetchAdditionalDishes(value:NSDictionary?)
    @objc optional func didFetchDishesForMenu(value:NSDictionary?)
    @objc optional func failedToFetchDishes(errorString:String)
    
    @objc optional func getLastObjectFetched(lastObject:Any?)
    
    @objc optional func didFetchRestaurants(value:NSDictionary?)
    @objc optional func failedToFetchRestaurants(errorString:String)
    
    @objc optional func successPostingReview()
    @objc optional func failurePostingReview()

    @objc optional func didFetchReviews(value:NSDictionary?)
    @objc optional func failedToFetchReviews(errorString:String)
}

class FirebaseDataHandler{
    
    static let sharedInstance = FirebaseDataHandler()
    var delegate:FirebaseDataHandlerDelegate?

    //Mark : DISHES
    
    func getDishes(numberOfDishes:UInt){
        delegate?.willBeginTask?()
        
        FirebaseDishRef.queryOrderedByKey().queryLimited(toFirst: numberOfDishes).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else{
                self.delegate?.failedToFetchDishes?(errorString: "Dishes Not found")
                return
            }
  
            self.delegate?.didFetchDishes?(value:value)
            let lastObject = value.allKeys.last
            print("last object: \(lastObject)")
            self.delegate?.getLastObjectFetched?(lastObject: lastObject)
            
        }) { (error) in
            print(error.localizedDescription)
            self.delegate?.failedToFetchDishes?(errorString: error.localizedDescription)
        }
    }
    
    func getAdditionalDishesStarting(at startingObject:Any?, numberOfDishes:UInt){
        delegate?.willBeginTask?()
        
        FirebaseDishRef.queryOrderedByKey().queryStarting(atValue: startingObject).queryLimited(toFirst: numberOfDishes).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let value = snapshot.value as? NSMutableDictionary else{
                self.delegate?.failedToFetchDishes?(errorString: "Dishes Not found")
                return
            }
            
            (value as? NSMutableDictionary)?.removeObject(forKey: startingObject)
            self.delegate?.didFetchAdditionalDishes?(value:value)
            let lastObject = value.allKeys.last
            print("last object: \(lastObject)")
            self.delegate?.getLastObjectFetched?(lastObject: lastObject)
            
        }) { (error) in
            print(error.localizedDescription)
            self.delegate?.failedToFetchDishes?(errorString: error.localizedDescription)
        }
    }
    
    
    
    func getDishesFor(restaurantID:String, menuNamed:String){
        delegate?.willBeginTask?()
        FirebaseMenuRef.child(restaurantID).child(menuNamed).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let menuObjects = snapshot.value as? NSDictionary else{
                self.delegate?.failedToFetchDishes?(errorString: "Menu doesnt exist")
                return
            }
            
            let dishDictionary:NSMutableDictionary = NSMutableDictionary()
            let numberOfObjects = menuObjects.count
            var currObject = 0
            for (key, _) in menuObjects{
                
                FirebaseDishRef.child(key as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                    // do some stuff once
                    guard let value = snapshot.value as? NSDictionary else{
                        self.delegate?.failedToFetchDishes?(errorString: "Dishes Not found")
                        return
                    }
                    dishDictionary[key] = value
                    currObject += 1;
                    if currObject == numberOfObjects{
                        self.delegate?.didFetchDishesForMenu?(value:dishDictionary)
                    }
                })
                
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
            self.delegate?.failedToFetchDishes?(errorString: error.localizedDescription)
        }

        
//        FirebaseDishRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            guard let value = snapshot.value as? NSDictionary else{
//                self.delegate?.failurePostingReview?()
//                return
//            }
//            
//            self.delegate?.didFetchDishes?(value:value)
//            
//        }) { (error) in
//            print(error.localizedDescription)
//            self.delegate?.failedToFetchDishes?(errorString: error.localizedDescription)
//        }
    }
    
    func getDishesWhereName(startsWith:String,numberOfDishes:UInt){
        delegate?.willBeginTask?()
        let endingString = startsWith.lowercased() + "\u{f8ff}"
        FirebaseDishRef.queryOrdered(byChild: "lowercased_name").queryStarting(atValue: startsWith.lowercased()).queryEnding(atValue: endingString).queryLimited(toFirst: numberOfDishes).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else{
                self.delegate?.failedToFetchDishes?(errorString: "Dish Not found")
                return
            }
            self.delegate?.didFetchDishes!(value:value)
            let lastObject = value.allKeys.last
            print("last object: \(lastObject)")
            self.delegate?.getLastObjectFetched?(lastObject: lastObject)
            
        }) { (error) in
            print(error.localizedDescription)
            self.delegate?.failedToFetchDishes?(errorString: error.localizedDescription)
        }
    }
    
    
    func getSavedDishesFor(userID:String){
        delegate?.willBeginTask?()
        FirebaseSavedDishRef(for: userID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let savedDishDictionary = snapshot.value as? NSDictionary else{
                self.delegate?.failedToFetchDishes?(errorString: "Saved Dishes failed to fetch")
                return
            }
            
            let dishDictionary:NSMutableDictionary = NSMutableDictionary()
            let numberOfObjects = savedDishDictionary.count
            var currObject = 0
            for (key, value) in savedDishDictionary{
                
                currObject += 1
                if (value as! Bool) == false {continue}
                FirebaseDishRef.child(key as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                    // do some stuff once
                    guard let value = snapshot.value as? NSDictionary else{
                        self.delegate?.failedToFetchDishes?(errorString: "Dishes Not found")
                        return
                    }
                    dishDictionary[key] = value
                    if currObject == numberOfObjects{
                        self.delegate?.didFetchDishes?(value:dishDictionary)
                    }
                })
                
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
            self.delegate?.failedToFetchDishes?(errorString: error.localizedDescription)
        }
        
    }

    //Mark : Restaurants
    
    func getSavedRestaurantsFor(userID:String){
        delegate?.willBeginTask?()
        FirebaseSavedRestaurantRef(for: userID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let savedRestaurantDictionary = snapshot.value as? NSDictionary else{
                self.delegate?.failedToFetchRestaurants?(errorString: "Saved Restaurants failed to fetch")
                return
            }
            
            let restaurantDict:NSMutableDictionary = NSMutableDictionary()
            let numberOfObjects = savedRestaurantDictionary.count
            var currObject = 0
            for (key, value) in savedRestaurantDictionary{
                
                currObject += 1
                if (value as! Bool) == false {continue}
                FirebaseResturantRef.child(key as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                    // do some stuff once
                    guard let value = snapshot.value as? NSDictionary else{
                        self.delegate?.failedToFetchRestaurants?(errorString: "Restaurants Not found")
                        return
                    }
                    restaurantDict[key] = value
                    if currObject == numberOfObjects{
                        self.delegate?.didFetchRestaurants?(value:restaurantDict)
                    }
                })
                
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
            self.delegate?.failedToFetchRestaurants?(errorString: "Restaurants Not found")
        }
        

    }

    
    
    func getRestaurants(numberOfRestaurants:UInt){
        delegate?.willBeginTask?()
        FirebaseResturantRef.queryLimited(toFirst: numberOfRestaurants).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else{
                self.delegate?.failedToFetchRestaurants?(errorString: "Restaurant Not found")
                return
            }
            self.delegate?.didFetchRestaurants?(value:value)
            
        }) { (error) in
            print(error.localizedDescription)
            self.delegate?.failedToFetchRestaurants?(errorString: error.localizedDescription)
        }
    }
    
    func getRestaurantsWhereName(startsWith:String,numberOfRestaurants:UInt){
        delegate?.willBeginTask?()
        let endingString = startsWith + "\u{f8ff}"
        FirebaseResturantRef.queryOrdered(byChild: "lowercased_name").queryStarting(atValue: startsWith).queryEnding(atValue: endingString).queryLimited(toFirst: numberOfRestaurants).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else{
                 self.delegate?.failedToFetchRestaurants?(errorString: "Restaurant Not found")
                return
            }
            self.delegate?.didFetchRestaurants?(value:value)
            
        }) { (error) in
            print(error.localizedDescription)
            self.delegate?.failedToFetchRestaurants?(errorString: error.localizedDescription)
        }
    }
    

    //Mark : REVIEWS 
    
    //NOTE: Need to do error checking
    func postReviewFor(dishID:String, reviewDictionary:NSDictionary){
        delegate?.willBeginTask?()
        FirebaseDishRef.child(dishID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else{
                self.delegate?.failedToFetchRestaurants?(errorString: "Restaurant Not found")
                return
            }
            
            var newAverageRating = (value[FirebaseDishKey_averageRating] as! Double) * Double(value[FirebaseDishKey_numberOfRatings] as! Int)
            newAverageRating += reviewDictionary[FirebaseReviewKey_reviewRating] as! Double
            let newNumberOfRatings:Int = value[FirebaseDishKey_numberOfRatings] as! Int + 1
            newAverageRating = newAverageRating / Double(newNumberOfRatings)
            
            FirebaseDishRef.child(dishID).child(FirebaseDishKey_numberOfRatings).setValue(newNumberOfRatings)
            FirebaseDishRef.child(dishID).child(FirebaseDishKey_averageRating).setValue(newAverageRating)
            
            let newReview = FirebaseReviewRef.child(dishID).childByAutoId()
            newReview.setValue(reviewDictionary)
            
            FirebaseUserReviewRef.child(newReview.key).setValue(reviewDictionary)
            
            self.delegate?.successPostingReview?()
            
        }) { (error) in
            print(error.localizedDescription)
            self.delegate?.failedToFetchRestaurants?(errorString: error.localizedDescription)
        }
        
    }
    
    func fetchReviewsFor(dishID:String, numberOfReviews:UInt){
        delegate?.willBeginTask?()
//        FirebaseReviewRef.child(dishID).queryOrdered(byChild: FirebaseReviewKey_reviewDate).queryLimited(toFirst: numberOfReviews).observeSingleEvent(of: .value, with: { (snapshot) in
        FirebaseReviewRef.child(dishID).queryOrdered(byChild: FirebaseReviewKey_reviewDate).observeSingleEvent(of: .value, with: { (snapshot) in

            guard let value = snapshot.value as? NSDictionary else{
                self.delegate?.failedToFetchReviews?(errorString: "Reviews Not found")
                return
            }
            self.delegate?.didFetchReviews?(value:value)
            
        }) { (error) in
            self.delegate?.failedToFetchReviews?(errorString: "Reviews Not found")
        }

    }
    
    func fetchReviewsFor(userID:String, numberOfReviews:UInt){
        
        delegate?.willBeginTask?()
        FirebaseUserReviewRef.queryOrdered(byChild: "/reviewer_UID").queryStarting(atValue: userID).queryEnding(atValue: userID + "a").queryLimited(toFirst: numberOfReviews).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else{
                self.delegate?.failedToFetchReviews?(errorString: "Reviews Not found")
                return
            }
            
            for (key,object) in value{
                print(key)
                print(object)
            }
            
            self.delegate?.didFetchReviews?(value:value)
            
        }) { (error) in
            self.delegate?.failedToFetchReviews?(errorString: "Reviews Not found")
        }
        
    }

    
}


