//
//  FirebaseObjectConverter.swift
//  Vittles
//

/*-----------------FirebaseObjectConverter-----------------
 Purpose of this class is to converte JSON data recieved from firebase and converting
 it to custom classes that the app uses.
 */

import Foundation
import UIKit

class FirebaseObjectConverter {
    
    class func dishArrayFrom(dictionary:NSDictionary)->[DishObject]{
        var arrayOfDishes:[DishObject] = [DishObject]()
        for (key,dish) in dictionary{
            
            guard dish is NSDictionary else {
                continue
            }
            
            guard let aDish = dictionaryToDishObject(dictionary: dish as! NSDictionary, uniqueID: key as! String) else{
                continue
            }
            
            arrayOfDishes.append(aDish)
        }
        return arrayOfDishes
    }
    
    class func dictionaryToDishObject(dictionary:NSDictionary, uniqueID:String)->DishObject?{
        
        guard let name = dictionary.object(forKey: "name") as? String else{
            print("name not found")
            return nil
        }
        guard let foodDescription = dictionary.object(forKey: "food_description") as? String else{
            print("food description not found")
            return nil
        }
        guard let averageRating = dictionary.object(forKey: "averageRating") as? Double else{
            print("averageRating not found")
            return nil
        }
        guard let numberOfRatings = dictionary.object(forKey: "number_of_ratings") as? Int else{
            print("number_of_ratings not found")
            return nil
        }
        guard let type =  dictionary.object(forKey: "type") as? String else{
            print("type not found")
            return nil
        }
        guard let restaurantName =  dictionary.object(forKey: "restaurant_name") as? String else{
            print("restaurantName not found")
            return nil
        }
        guard let restaurantRefID =  dictionary.object(forKey: "restaurant") as? String else{
            print("restaurantRefID not found")
            return nil
        }
   
        //Added to fix dishes to include lower cased name
        if let _ = dictionary.object(forKey: "lowercased_name") as? String {
            
        }else{
            FirebaseDishRef.child(uniqueID).child("lowercased_name").setValue(name.lowercased())
        }
        
        var aDish:DishObject?
        if  let imageURL = dictionary.object(forKey: FirebaseDishKey_thumbnail) as? String{
             aDish = DishObject(uniqueID:uniqueID,name:name,foodDescription:foodDescription, averageRating:averageRating,numberOfRatings:numberOfRatings,type:type,restaurantName:restaurantName,restaurantRefID:restaurantRefID,imageURL: imageURL)
        }else{
            aDish = DishObject(uniqueID:uniqueID,name:name,foodDescription:foodDescription, averageRating:averageRating,numberOfRatings:numberOfRatings,type:type,restaurantName:restaurantName,restaurantRefID:restaurantRefID)
        }
        
    
        return aDish!
    }
    
    class func dictionaryToRestaurantObject(dictionary:NSDictionary, uniqueID:String)->RestaurantObject?{
 
    
        guard let name = dictionary.object(forKey: "name") as? String else{
            print("name not found")
            return nil
        }
        
        guard let address = dictionary.object(forKey: "address") as? String else{
            print("address not found")
            return nil
        }
        
        guard let categories = dictionary.object(forKey: "categories") as? [String] else{
            print("categories not found")
            return nil
        }
        
        guard let menuTitles = dictionary.object(forKey: "menu_titles") as? [String] else{
            print("menu_titles not found")
            return nil
        }
        
        if let imageURL = dictionary.object(forKey: "thumbnail_URL") as? String{
            return RestaurantObject(uniqueID: uniqueID, name: name, address: address, categories: categories, menuTitles: menuTitles, imageURL: imageURL)
        }else{
            return RestaurantObject(uniqueID: uniqueID, name: name, address: address, categories: categories, menuTitles: menuTitles)
        }
    

    }
    
    class func restaurantArrayFrom(dictionary:NSDictionary)->[RestaurantObject]{
        var arrayOfRestaurants:[RestaurantObject] = [RestaurantObject]()
        
        for (key,value) in dictionary{
            
            guard let aRestaurant = self.dictionaryToRestaurantObject(dictionary: value as! NSDictionary, uniqueID: key as! String) else{
                continue
            }
            arrayOfRestaurants.append(aRestaurant)
            
        }
        
        return arrayOfRestaurants
    }
    
    
    class func dictionaryToReviewObject(dictionary:NSDictionary, uniqueID:String)->ReviewObject?{
        
        guard uniqueID != nil else{
            print("UniqueID not found")
            return nil
        }
        
        guard let body = dictionary.object(forKey: FirebaseReviewKey_reviewBody) as? String else{
            print("name not found")
            return nil
        }
        guard let rating = dictionary.object(forKey: FirebaseReviewKey_reviewRating) as? Double else{
            print("food description not found")
            return nil
        }
        guard let userID = dictionary.object(forKey: FirebaseReviewKey_reviewUserID) as? String else{
            print("averageRating not found")
            return nil
        }
        guard let reviewerName = dictionary.object(forKey: FirebaseReviewKey_reviewerName) as? String else{
            print("number_of_ratings not found")
            return nil
        }
        guard let title =  dictionary.object(forKey: FirebaseReviewKey_reviewTitle) as? String else{
            print("type not found")
            return nil
        }
        guard let timestamp =  dictionary.object(forKey: FirebaseReviewKey_reviewDate) as? TimeInterval else{
            print("date not found")
            return nil
        }
        
        let date = NSDate(timeIntervalSince1970: timestamp)
        
        let aReview = ReviewObject(uniqueID:uniqueID, title: title, body: body, rating: rating, reviewer_name: reviewerName, reviewer_UDID: userID, date:date)
        return aReview
    }

    class func reviewArrayFrom(dictionary:NSDictionary)->[ReviewObject]{
        var arrayOfReviews:[ReviewObject] = [ReviewObject]()
        for (key,review) in dictionary{
            
            guard review is NSDictionary else {
                continue
            }
            
            guard let aReview = dictionaryToReviewObject(dictionary: review as! NSDictionary, uniqueID: key as! String) else{
                continue
            }
            
            arrayOfReviews.append(aReview)
        }
        return arrayOfReviews
    }
    
    class func dictionaryToUserObject(dictionary:NSDictionary, UDID:String) -> UserObject?{
        guard let name = dictionary.object(forKey: FirebaseUserKey_name) as? String else{
            print("food description not found")
            return nil
        }
        guard let generalLocation = dictionary.object(forKey: FirebaseUserKey_generalLocation) as? String else{
            print("averageRating not found")
            return nil
        }
        
        if let thumbnail_URL =  dictionary.object(forKey: FirebaseUserKey_thumbnail_URL) as? String{
            return UserObject(name: name, generalLocation: generalLocation, UDID: UDID, thumbnail_URL: thumbnail_URL)
        }else{
            return UserObject(name: name, generalLocation: generalLocation, UDID: UDID)

        }
    }
    
}





