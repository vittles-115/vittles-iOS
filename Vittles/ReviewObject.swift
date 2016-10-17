//
//  ReviewObject.swift
//  Vittles
//

import Foundation
import UIKit

class ReviewObject: NSObject {
    var uniqueID:String = ""
    var title:String = ""
    var body:String = ""
    var rating:Double = 0.0
    var reviewer_name:String = ""
    var reviewer_UDID:String = ""
    
    convenience init(uniqueID:String, title:String, body:String, rating:Double, reviewer_name:String, reviewer_UDID:String ) {
        self.init()
        self.uniqueID = uniqueID
        self.title = title
        self.body = body
        self.rating = rating
        self.reviewer_name = reviewer_name
        self.reviewer_UDID = reviewer_UDID
    }
    
    convenience init(title:String, body:String, rating:Double, reviewer_name:String, reviewer_UDID:String ) {
        self.init()
        self.title = title
        self.body = body
        self.rating = rating
        self.reviewer_name = reviewer_name
        self.reviewer_UDID = reviewer_UDID
    }
    
    func asDictionary()->NSDictionary{
        return [FirebaseReviewKey_reviewTitle : self.title, FirebaseReviewKey_reviewBody : self.body, FirebaseReviewKey_reviewRating : self.rating, FirebaseReviewKey_reviewerName : self.reviewer_name, FirebaseReviewKey_reviewUserID : self.reviewer_UDID]
    }
}
