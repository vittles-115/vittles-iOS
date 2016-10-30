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
    class func uploadImage(image:UIImage, path:String){
        
        //Convert image to data and create path to image in Firebase storage
        let imageData = UIImagePNGRepresentation(image)
        let imageRef = FirebaseImageRef.child(path)
        let firebaseImage = imageRef.child("\(NSUUID().uuidString).png")
        
        //Set meta data
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/png"
        
        //Upload image data + meta data
        firebaseImage.put(imageData!, metadata: metadata).observe(.success) { (snapshot) in
            // When the image has successfully uploaded, we get it's download URL
            let text = snapshot.metadata?.downloadURL()?.absoluteString
            // Set the download URL to the message box, so that the user can send it to the database
            print(text)
        }
    }
    
    
    
}



