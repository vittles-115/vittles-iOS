//
//  UtilityFunctions.swift
//  MenuApp
//
//  Created by Jenny Kwok on 2/21/16.
//  Copyright © 2016 Jenny. All rights reserved.
//

import UIKit
import Foundation

//Take UIImage and radius of image and returns a rounded image. Assume image is square
func maskRoundedImage(_ image: UIImage, radius: Float, hasBorder:Bool) -> UIImage {
    
    //Load imageView with Image
    let imageView: UIImageView = UIImageView(image: image)
    
    //User imageView Layer to set corner radius and round image
    var layer: CALayer = CALayer()
    layer = imageView.layer
    layer.masksToBounds = true
    layer.cornerRadius = CGFloat(radius)
    if hasBorder{
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
    }
    
    //Render image from ImageView
    UIGraphicsBeginImageContext(imageView.bounds.size)
    layer.render(in: UIGraphicsGetCurrentContext()!)
    let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
    
    //Stop rendering and return image
    UIGraphicsEndImageContext()
    return roundedImage!
}


//Takes image and new size and returns the resized image
func imageResize(_ imageObj:UIImage, sizeChange:CGSize)-> UIImage {
    
    // Automatically use scale factor of main screen
    let scale: CGFloat = 0.0

    //Start redrawing image
    UIGraphicsBeginImageContextWithOptions(sizeChange, true, scale)
    imageObj.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
    
    //Get instance of redrawn image and stop rendering
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    //Return the scaled Image
    return scaledImage!
}

//Add border to view
func addBorder(_ view:UIView, thickness:CGFloat, color: UIColor){
    view.layer.borderWidth = thickness
    view.layer.borderColor = color.cgColor
}

func dateToString(_ date:Date,dateFormat:String)->String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    return dateFormatter.string(from: date)
}

//Display an image popup on view controller
func popupFadeIn(_ mainView:UIView, imageName:String)->UIView{
    let popup = UIView(frame: CGRect(x: 0, y: 0, width: mainView.frame.width, height: mainView.frame.height))
    let image = UIImage(named: imageName)
    let imageView = UIImageView(image: image)
    imageView.center = popup.center
    
    popup.addSubview(imageView)
    popup.alpha = 0
    
    UIView.animate(withDuration: 0.5, animations: {
        popup.alpha = 1.0
        popup.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    });
    
    mainView.addSubview(popup)
    return popup
}

func addPullToRefresh(){
    var refreshControl: UIRefreshControl!
    refreshControl = UIRefreshControl()
    
    refreshControl.backgroundColor = UIColor.white
    refreshControl.tintColor = MA_Red

}

//Display an image popup on view controller
func popupFadeIn(_ mainView:UIView, image:UIImage)->UIView{
    let popup = UIView(frame: CGRect(x: 0, y: 0, width: mainView.frame.width, height: mainView.frame.height))
    let imageView = UIImageView(image: image)
    imageView.center = popup.center
    
    popup.addSubview(imageView)
    popup.alpha = 0
    
    UIView.animate(withDuration: 0.5, animations: {
        popup.alpha = 1.0
        popup.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    });
    
    mainView.addSubview(popup)
    return popup
}

//Remove a popup image from
func popupFadeOut(_ popup:UIView){
    UIView.animate(withDuration: 0.5, animations: {
        popup.alpha = 0
        popup.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                popup.removeFromSuperview()
            }
            
    });
    
}

//Function to add blur effect to background
func addBlur(_ view:UIView){
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = view.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
    view.addSubview(blurEffectView)
}

//Function to add a line at the bottom of a view 
func addBottomDivider(_ view:UIView, thickness:CGFloat, color:UIColor){
    let frame = CGRect(x: 0, y: view.frame.height-thickness, width: view.frame.width, height: thickness)
    let divider = UIView(frame: frame)
    divider.backgroundColor = color
    view.addSubview(divider)
}

//Function to add a line at the top of a view
func addTopDivider(_ view:UIView, thickness:CGFloat, color:UIColor){
    let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: thickness)
    let divider = UIView(frame: frame)
    divider.backgroundColor = color
    view.addSubview(divider)
}

//Function to add corner radius
func addCornerRadius(_ view:UIView,radius:CGFloat){
    view.layer.cornerRadius = radius
    view.clipsToBounds = true
}

//Utility Extesnsion to remove an element from a collection (array)
extension RangeReplaceableCollection where Iterator.Element : Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(_ object : Iterator.Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
}



//Utility Extensions for UITableView cells
extension UITableViewCell{
    public func addBottomDivider(_ thickness:CGFloat, color:UIColor){
        let frame = CGRect(x: 0, y: self.frame.height-thickness, width: self.frame.width, height: thickness)
        let divider = UIView(frame: frame)
        divider.backgroundColor = color
        self.addSubview(divider)
    }
}

//Looking into updates for this method
/*
//synchronously fetch image from url
func fetchImageFromUrl(_ urlString: String, completion:@escaping (_ fetchedImage:UIImage) ->Void ){
    if let url = URL(string: urlString) {
        let request = URLRequest(url: url)
        

        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) {
            (response: URLResponse?, data: Data?, error: NSError?) -> Void in
            if let imageData = data as Data? {
                completion(fetchedImage: UIImage(data: imageData)!)

            }
        } as! (URLResponse?, Data?, Error?) -> Void as! (URLResponse?, Data?, Error?) -> Void as! (URLResponse?, Data?, Error?) -> Void as! (URLResponse?, Data?, Error?) -> Void as! (URLResponse?, Data?, Error?) -> Void as! (URLResponse?, Data?, Error?) -> Void as! (URLResponse?, Data?, Error?) -> Void
    }
}
 
 */


//Utility Extensions for UIImageView
extension UIImageView {
    
    //Looking into updates for this method
    /*
    //allows UIImageView to fetch image from url in the background
    public func imageFromUrl(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            
            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) {
                (response: URLResponse?, data: Data?, error: NSError?) -> Void in
                if let imageData = data as Data? {
                    self.image = UIImage(data: imageData)
                }
            } as! (URLResponse?, Data?, Error?) -> Void as! (URLResponse?, Data?, Error?) -> Void as! (URLResponse?, Data?, Error?) -> Void as! (URLResponse?, Data?, Error?) -> Void as! (URLResponse?, Data?, Error?) -> Void as! (URLResponse?, Data?, Error?) -> Void as! (URLResponse?, Data?, Error?) -> Void
        }
    }
 */
    
    //allows easy setting of rounded corners
    public func setCornerRadius(_ cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }

}


//Utility Extensions for UIView
extension UIView{
    func addGradient(_ colors:[CGColor], gradientLocations:[NSNumber]){
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = colors
        gradient.locations = gradientLocations
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        
        self.layer.insertSublayer(gradient, at: 0)
    }
}




