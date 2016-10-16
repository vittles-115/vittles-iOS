//
//  FirebaseObjectConverter.swift
//  Vittles
//

import Foundation
import UIKit

class FirebaseObjectConverter {
    
    class func dishArrayFrom(dictionary:NSDictionary)->[DishObject]{
        var arrayOfDishes:[DishObject] = [DishObject]()
        for (key,dish) in dictionary{
            
            //Set values, if dictionary is not complete skip this object and continue
            
            guard let uniqueID = key as? String else{
                print("key not found")
                continue
            }
            
            guard let name = (dish as! NSDictionary).object(forKey: "name") as? String else{
                print("name not found")
                continue
            }
            guard let foodDescription = (dish as! NSDictionary).object(forKey: "food_description") as? String else{
                print("food description not found")
                continue
            }
            guard let averageRating = (dish as! NSDictionary).object(forKey: "averageRating") as? Double else{
                print("averageRating not found")
                continue
            }
            guard let numberOfRatings = (dish as! NSDictionary).object(forKey: "number_of_ratings") as? Int else{
                print("number_of_ratings not found")
                continue
            }
            guard let type =  (dish as! NSDictionary).object(forKey: "type") as? String else{
                print("type not found")
                continue
            }
            guard let restaurantName =  (dish as! NSDictionary).object(forKey: "restaurant_name") as? String else{
                print("restaurantName not found")
                continue
            }
            guard let restaurantRefID =  (dish as! NSDictionary).object(forKey: "restaurant") as? String else{
                print("restaurantRefID not found")
                continue
            }
            
            let aDish = DishObject(uniqueID:uniqueID,name:name,foodDescription:foodDescription, averageRating:averageRating,numberOfRatings:numberOfRatings,type:type,restaurantName:restaurantName,restaurantRefID:restaurantRefID)
            arrayOfDishes.append(aDish)
        }
        return arrayOfDishes
    }
    
    class func restaurantArrayFrom(dictionary:NSDictionary)->[RestaurantObject]{
        var arrayOfRestaurants:[RestaurantObject] = [RestaurantObject]()
        
        for (key,value) in dictionary{
            guard let uniqueID = key as? String else{
                print("key not found")
                continue
            }
            
            guard let name = (value as! NSDictionary).object(forKey: "name") as? String else{
                print("name not found")
                continue
            }
            
            guard let address = (value as! NSDictionary).object(forKey: "address") as? String else{
                print("address not found")
                continue
            }

            guard let categories = (value as! NSDictionary).object(forKey: "categories") as? [String] else{
                print("categories not found")
                continue
            }
            
            guard let menuTitles = (value as! NSDictionary).object(forKey: "menu_titles") as? [String] else{
                print("menu_titles not found")
                continue
            }
            
            let aRestaurant = RestaurantObject(uniqueID: uniqueID, name: name, address: address, categories: categories, menuTitles: menuTitles)
            arrayOfRestaurants.append(aRestaurant)
            
        }
        
        return arrayOfRestaurants
    }
    
}





