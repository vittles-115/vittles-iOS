//
//  UserObject.swift
//  Vittles
//

import Foundation
import UIKit

class UserObject: NSObject {
    var name:String = ""
    var generalLocation:String = ""
    var UDID:String = ""
    var thumbnail_URL:String = ""
    
    convenience init(name:String,generalLocation:String, UDID:String) {
        self.init()
        self.name = name
        self.generalLocation = generalLocation
        self.UDID = UDID
    }
    
    convenience init(name:String,generalLocation:String, UDID:String, thumbnail_URL:String) {
        self.init()
        self.name = name
        self.generalLocation = generalLocation
        self.UDID = UDID
        self.thumbnail_URL = thumbnail_URL
    }
}
