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

//File Storage
let FirebaseImageStorage = FIRStorage.storage()
let FirebaseImageRef = FirebaseImageStorage.reference(forURL: "gs://vittles-1c0fb.appspot.com")
let FirebaseFoodImageRef = FirebaseImageRef.child("FoodImages")

//Firebase Object Keys 
