//
//  FirebaseImageHandler.swift
//  Vittles
//


import Foundation
import UIKit
import FirebaseStorage
import AlamofireImage
import Alamofire

typealias ImageCallback = (UIImage?,NSError?) -> Void

class FirebaseImageHandler{
    
    static let sharedInstance = FirebaseUserHandler()
    // 100MB  maximum capacity
    //  60MB  preferred capacity
    let imageCache = AutoPurgingImageCache(
        memoryCapacity: 100 * 1024 * 1024,
        preferredMemoryUsageAfterPurge: 60 * 1024 * 1024
    )
    
    let imageDownloader = ImageDownloader(
        configuration: ImageDownloader.defaultURLSessionConfiguration(),
        downloadPrioritization: .fifo,
        maximumActiveDownloads: 5,
        imageCache: AutoPurgingImageCache()
    )
    
    
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
    
    class func downloadImage(URL:String, imageCallback:@escaping ImageCallback){
        //var downloadedImage:UIImage?
        
        Alamofire.request(URL).responseImage { response in
            debugPrint(response)
            
            print(response.request)
            print(response.response)
            debugPrint(response.result)
            
            if let image = response.result.value {
                print("image downloaded: \(image)")
                imageCallback(image,nil)
            }else{
                let error = NSError(domain: "Failed to fetch Image", code: 420, userInfo: nil)
                imageCallback(nil,error)
            }
        }
    
    }
    
    
    
    
    func downloadImageUsingImageCache(URL:String,imageCallback:@escaping ImageCallback){
        guard let image = cachedImage(urlString: URL) else{
            Alamofire.request(URL).responseImage { response in
                debugPrint(response)
                
                print(response.request)
                print(response.response)
                debugPrint(response.result)
                
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    self.imageCache.add(image, withIdentifier: URL)
                    imageCallback(image,nil)
                }else{
                    let error = NSError(domain: "Failed to fetch Image", code: 420, userInfo: nil)
                    imageCallback(nil,error)
                }
            }
            return
        }
        imageCallback(image, nil)
    }
    
    func cachedImage(urlString: String) -> Image? {
        return imageCache.image(withIdentifier: urlString)
    }
    
    
    
}



