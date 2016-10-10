//
//  FirebaseImageHandler.swift
//  Vittles
//


import Foundation
import FirebaseStorage
import UIKit

class FirebaseImageHandler{
    
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
    
    class func downloadImage(imagePath:String)->UIImage{
        var downloadedImage:UIImage?
        
        let imageToDownloadRef = FirebaseImageRef.child(imagePath)
        imageToDownloadRef.downloadURL { (URL, error) -> Void in
            if (error != nil) {
                // Handle any errors
            } else {
                // Get the download URL for 'images/stars.jpg'
            }
        }
        
        return downloadedImage!
    }
}



