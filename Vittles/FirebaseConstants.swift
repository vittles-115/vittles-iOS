//
//  FirebaseConstants.swift
//  Vittles
//


import Foundation
import Firebase
import FirebaseStorage

//Dev note: need to change refrence urls for new firebase account

//Real-time Database
let FirebaseRootRef = FIRDatabase.database().reference()
let FirebaseUserRef = FirebaseRootRef.child("Users")
let FirebaseResturantRef = FirebaseRootRef.child("Restaurants")
let FirebaseMenuRef = FirebaseRootRef.child("Menus")
let FirebaseDishRef = FirebaseRootRef.child("Dishes")
let FirebaseReviewRef = FirebaseRootRef.child("Reviews")
let FirebaseImagePathRef = FirebaseRootRef.child("ImagePaths")
let FirebaseDishImagePathRef = FirebaseImagePathRef.child("Dishes")
let FirebaseDishListRef = FirebaseRootRef.child("DishLists")
let FirebaseRestaurantListRef = FirebaseRootRef.child("RestaurantLists")



let FirebaseUserReviewRef = FirebaseRootRef.child("UserPostedReviews")
let FirebaseUserPostedImageRef = FirebaseRootRef.child("UserPostedImages")


func FirebaseSavedDishRef(for userID:String)->FIRDatabaseReference{
    return FirebaseUserRef.child(userID).child("SavedDishes")
}

func FirebaseSavedRestaurantRef(for userID:String)->FIRDatabaseReference{
    return FirebaseUserRef.child(userID).child("SavedRestaurants")
}

//func FirebaseReviewRef(for userID:String)->FIRDatabaseReference{
//    return FirebaseUserReviewRef.child(userID)
//}
//
//func FirebaseImageRef(for userID:String)->FIRDatabaseReference{
//    return FirebaseUserPostedImageRef.child(userID)
//}



//File Storage
let FirebaseImageStorage = FIRStorage.storage()
let FirebaseImageRef = FirebaseImageStorage.reference(forURL: "gs://vittles-1c0fb.appspot.com")
let FirebaseImageThumbnailRef = FirebaseImageRef.child("thumbnailSized")
let FirebaseImageFullSizedRef = FirebaseImageRef.child("fullSizedImage")


//Firebase Object Keys

//Review
let FirebaseReviewKey_reviewTitle = "title"
let FirebaseReviewKey_reviewBody = "body"
let FirebaseReviewKey_reviewRating = "rating"
let FirebaseReviewKey_reviewUserID = "reviewer_UID"
let FirebaseReviewKey_reviewerName = "reviewer_name"
let FirebaseReviewKey_reviewDate = "date"

//Dish
let FirebaseDishKey_averageRating = "averageRating"
let FirebaseDishKey_name = "name"
let FirebaseDishKey_numberOfRatings = "number_of_ratings"
let FirebaseDishKey_restaurantID = "restaurant"
let FirebaseDishKey_restaurantName = "restaurant_name"
let FirebaseDishKey_type = "type"
let FirebaseDishKey_thumbnail = "thumbnail_URL"

//User
let FirebaseUserKey_name = "name"
let FirebaseUserKey_generalLocation = "general_location"
let FirebaseUserKey_thumbnail_URL = "thumbnail_URL"
let FirebaseUserKey_savedDishes = "SavedDishes"

//Images
let FirebaseImageKey_thumbnail = "thumbnailSized"
let FirebaseImageKey_fullSized = "fullSizedImage"
let FirebaseImageKey_uploader = "uploader_UDID"




