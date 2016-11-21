//
//  FirebaseImageHandler.swift
//  Vittles
//


import Foundation
import UIKit
import FirebaseStorage

typealias ImageCallback = (UIImage?,NSError?) -> Void
typealias ImageSingleURLCallback = (String?) -> Void
typealias ImageURLsCallback = (NSDictionary?) -> Void

protocol FirebaseImageHandlerDelegate {
    func didFetchUrls(urlDictArray:[NSDictionary])
    func failedToFetchURLS(errorString:String)
}

class FirebaseImageHandler{
    
    static let sharedInstance = FirebaseImageHandler()
    var delegate:FirebaseImageHandlerDelegate?
    
    
    class func getImageUrlFor(userUDID:String?,completion:@escaping ImageSingleURLCallback){
        
        guard userUDID != nil || userUDID == "" else{
            completion(nil)
            return
        }
        
        let userRef = FirebaseUserRef.child(userUDID!)
        userRef.child(FirebaseUserKey_thumbnail_URL).observeSingleEvent(of: .value, with: { (snapshot) in
            
      
            guard (snapshot.value as? String) != nil else{
                completion(nil)
                return
            }
            completion(snapshot.value as? String)
            
        }) { (error) in
            print(error.localizedDescription)
            completion(nil)
            
        }

    }
    
    
    class func getImageThumbnailUrlsFor(dishID:String,imageCount:UInt,completion:@escaping ImageURLsCallback){
        
        let imageUrlRef = FirebaseDishImagePathRef.child(dishID)
        imageUrlRef.queryLimited(toFirst: imageCount).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            guard let urlDict = (snapshot.value as? NSDictionary) else{
                completion(nil)
                return
            }
  
            completion(urlDict)
            
        }) { (error) in
            print(error.localizedDescription)
            completion(nil)
            
        }
        
    }
    
    func getImageThumbnailUrlsFor(dishID:String,imageCount:UInt){
        
        let imageUrlRef = FirebaseDishImagePathRef.child(dishID)
        imageUrlRef.queryLimited(toFirst: imageCount).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            guard let urlDict = (snapshot.value as? NSDictionary) else{
                self.delegate?.failedToFetchURLS(errorString: "Failed to fetch image urls")
                return
            }
            
            var urlDictArray = [NSDictionary]()
            for value in urlDict.allValues{
                guard let currValue = value as? NSDictionary else{
                    self.delegate?.failedToFetchURLS(errorString: "Failed to fetch image urls")
                    return
                }
                urlDictArray.append(currValue)
            }
            
             self.delegate?.didFetchUrls(urlDictArray: urlDictArray)
            
        }) { (error) in
            print(error.localizedDescription)
            self.delegate?.failedToFetchURLS(errorString: "Failed to fetch image urls")
            
        }
        
    }
    
    
    
    //DEV NOTE: Working but imcomplete
    class func uploadImage(for dish:DishObject, image:UIImage, uploaderUDID:String){
        
        //Convert image to data and create path to image in Firebase storage
        
        
        let fullSizedImageData = UIImagePNGRepresentation(image)
        let thumbnailJPEGData = image.jpegData(.lowest)
        let thumbnailPNGData = UIImagePNGRepresentation(UIImage(data: thumbnailJPEGData!)!)
        
        let thumbnailImageRef = FirebaseImageThumbnailRef.child("Dishes").child(dish.uniqueID)
        let fullSizedImageRef = FirebaseImageFullSizedRef.child("Dishes").child(dish.uniqueID)


        let firebaseThumbnailImage = thumbnailImageRef.child("\(NSUUID().uuidString).png")
        let firebaseFullSizedImage = fullSizedImageRef.child("\(NSUUID().uuidString).png")
        
        //Set meta data
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/png"
        
        let imageUrlRef = FirebaseDishImagePathRef.child(dish.uniqueID).childByAutoId()
        
        //Upload image data + meta data
        firebaseThumbnailImage.put(thumbnailPNGData!, metadata: metadata).observe(.success) { (snapshot) in
            // When the image has successfully uploaded, we get it's download URL
            let text = snapshot.metadata?.downloadURL()?.absoluteString
            // Set the download URL to the message box, so that the user can send it to the database
            //print(text)
            
            let thumbnailRef = imageUrlRef.child(FirebaseImageKey_thumbnail)
            thumbnailRef.setValue(text)
            let uploaderUDIDRef = imageUrlRef.child(FirebaseImageKey_uploader)
            uploaderUDIDRef.setValue(uploaderUDID)
        }
        
        //Upload image data + meta data
        firebaseFullSizedImage.put(fullSizedImageData!, metadata: metadata).observe(.success) { (snapshot) in
            // When the image has successfully uploaded, we get it's download URL
            let text = snapshot.metadata?.downloadURL()?.absoluteString
            // Set the download URL to the message box, so that the user can send it to the database
            //print(text)
            let fullSizedRef = imageUrlRef.child(FirebaseImageKey_fullSized)
            fullSizedRef.setValue(text)
            let uploaderUDIDRef = imageUrlRef.child(FirebaseImageKey_uploader)
            uploaderUDIDRef.setValue(uploaderUDID)
        }
    }
    
    
    
}



