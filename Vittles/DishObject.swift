//
//  DishObject.swift
//  Vittles
//

import UIKit
import Foundation

class DishObject: NSObject {
    var uniqueID:String = ""
    var name:String = ""
    var foodDescription:String = ""
    var averageRating:Double = 0.0
    var numberOfRatings:Int = 0
    var type:String = ""
    var restaurantName:String = ""
    var restaurantRefID:String = ""
    
    convenience init(uniqueID:String,name:String, foodDescription:String, averageRating:Double,numberOfRatings:Int,type:String,restaurantName:String,restaurantRefID:String) {
        
        self.init()
        self.uniqueID = uniqueID
        self.name = name
        self.foodDescription = foodDescription
        self.averageRating = averageRating
        self.numberOfRatings = numberOfRatings
        self.type = type
        self.restaurantName = restaurantName
        self.restaurantRefID = restaurantRefID
    }
    
}
