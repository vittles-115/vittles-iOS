//
//  File.swift
//  Vittles
//

import Foundation

class RestaurantObject: NSObject {
    var uniqueID:String = ""
    var name:String = ""
    var address:String = ""
    var categories:[String]?
    var menuTitles:[String]?
    
    convenience init(uniqueID:String, name:String, address:String, categories:[String],menuTitles:[String]) {
        self.init()
        self.uniqueID = uniqueID
        self.name = name
        self.address = address
        self.categories = categories
        self.menuTitles = menuTitles
    }
}
