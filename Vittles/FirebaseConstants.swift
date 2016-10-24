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
let FirebaseResturantRef = FirebaseRootRef.child("Resturants")
let FirebaseMenuRef = FirebaseRootRef.child("Menus")
let FirebaseDishRef = FirebaseRootRef.child("Dishes")
let FirebaseReviewRef = FirebaseRootRef.child("Reviews")
let FirebaseImagePathRef = FirebaseRootRef.child("ImagePaths")

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

//Dish
let FirebaseDishKey_averageRating = "averageRating"
let FirebaseDishKey_name = "name"
let FirebaseDishKey_numberOfRatings = "number_of_ratings"
let FirebaseDishKey_restaurantID = "restaurant"
let FirebaseDishKey_restaurantName = "restaurant_name"
let FirebaseDish_Keytype = "type"




