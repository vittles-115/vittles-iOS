//
//  FirebaseDataHandler.swift
//  Vittles
//

import Foundation
import FirebaseStorage
import UIKit

typealias FirebaseResponse = (NSDictionary?) -> Void

@objc protocol FirebaseDataHandlerDelegate {
    @objc optional func didFetchDishes(value:NSDictionary?)
    @objc optional func didFetchDishesForMenu(value:NSDictionary?)
    @objc optional func failedToFetchDishes(errorString:String)
    
    @objc optional func didFetchRestaurants(value:NSDictionary?)
    @objc optional func failedToFetchRestaurants(errorString:String)

}

class FirebaseDataHandler{
    
    static let sharedInstance = FirebaseDataHandler()
    var delegate:FirebaseDataHandlerDelegate?

    func getDishes(numberOfDishes:UInt){
        FirebaseDishRef.queryLimited(toFirst: numberOfDishes).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            //print("number of objects is",value!.count," values are :",value)
            
            self.delegate?.didFetchDishes?(value:value)

        }) { (error) in
            print(error.localizedDescription)
            self.delegate?.failedToFetchDishes?(errorString: error.localizedDescription)
        }
    }
    
    func getDishesFor(restaurantID:String, menuNamed:String){
        
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
                    guard let dish = snapshot.value as? NSDictionary else{
                        return
                    }
                    dishDictionary[key] = dish
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

        
        FirebaseDishRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            //print("number of objects is",value!.count," values are :",value)
            
            self.delegate?.didFetchDishes?(value:value)
            
        }) { (error) in
            print(error.localizedDescription)
            self.delegate?.failedToFetchDishes?(errorString: error.localizedDescription)
        }
    }
    
    func getRestaurants(numberOfRestaurants:UInt){
        FirebaseResturantRef.queryLimited(toFirst: numberOfRestaurants).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            print("number of objects is",value!.count," values are :",value)
            // ...
            self.delegate?.didFetchRestaurants?(value:value)
            
        }) { (error) in
            print(error.localizedDescription)
            self.delegate?.failedToFetchRestaurants?(errorString: error.localizedDescription)
        }
    }
    
    func getRestaurantsWhereName(startsWith:String,numberOfRestaurants:UInt){
        let endingString = startsWith + "\u{f8ff}"
        FirebaseResturantRef.queryOrdered(byChild: "lowercased_name").queryLimited(toLast: numberOfRestaurants).queryStarting(atValue: startsWith).queryEnding(atValue: endingString)
        FirebaseResturantRef.queryLimited(toFirst: numberOfRestaurants).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            print("number of objects is",value!.count," values are :",value)
            // ...
            self.delegate?.didFetchRestaurants?(value:value)
            
        }) { (error) in
            print(error.localizedDescription)
            self.delegate?.failedToFetchRestaurants?(errorString: error.localizedDescription)
        }
    }
    
}


