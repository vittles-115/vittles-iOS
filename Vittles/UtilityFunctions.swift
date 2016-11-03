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



extension UIView{
    
    func addGradient(_ colors:[CGColor], gradientLocations:[NSNumber]){
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = colors
        gradient.locations = gradientLocations
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    public func setCornerRadius(_ cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    public func clipToCircle(){
        self.layer .cornerRadius = self.frame.width/2
        self.layer.borderWidth = 2
        self.clipsToBounds = true
    }
    
    public func clipToCircle(borderWidth:CGFloat, borderColor:UIColor){
        self.layer .cornerRadius = self.frame.width/2
        self.layer.borderWidth = 2
        self.layer.borderColor = borderColor.cgColor
        self.clipsToBounds = true
    }
    
    public func clipToCircle(borderWidth:CGFloat, borderColor:UIColor,backgroundColor:UIColor){
        self.layer .cornerRadius = self.frame.width/2
        self.layer.borderWidth = 2
        self.layer.borderColor = borderColor.cgColor
        self.layer.backgroundColor = backgroundColor.cgColor
        self.clipsToBounds = true
    }
    
    public func addDropShadow(opacity:Float, radius:CGFloat, color:UIColor, offset:CGSize){
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
    }
    
    public func addBorder(width:CGFloat, radius:CGFloat, color:UIColor){
        self.layer.borderWidth = width
        self.layer.cornerRadius = radius
        self.layer.borderColor = color.cgColor
    }
    
    public func addBlur(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    
}

extension UIButton{
    override public func setCornerRadius(_ cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    override public func addDropShadow(opacity:Float, radius:CGFloat, color:UIColor, offset:CGSize){
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
    }
}

extension UITextView{
    override public func setCornerRadius(_ cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    override public func addDropShadow(opacity:Float, radius:CGFloat, color:UIColor, offset:CGSize){
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
    }
}


extension UIViewController{
    
    func presentSimpleAlert(title:String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }

    
    public func setViewForContainer(container:UIView, viewController:UIViewController){
        self.addChildViewController(viewController)
        viewController.view.frame = CGRect(x:0, y:0, width:container.frame.size.width, height:container.frame.size.height);
        container.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
    }
    
    public func setNavigationBarClear(){
        guard self.navigationController != nil else {
            return
        }
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
}


extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (unshuffledCount, firstUnshuffled) in zip(stride(from: c, to: 1, by: -1), indices) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

//EXAMPLE USAGE:
//if let imageData = image.jpegData(.lowest) {
//    print(imageData.count)
//}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in PNG format
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    ///
    /// Returns a data object containing the PNG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    var pngData: Data? { return UIImagePNGRepresentation(self) }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpegData(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
}

extension UISegmentedControl {
    func removeBorders() {
        setBackgroundImage(imageWithColor(color: backgroundColor!), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x:0.0,y: 0.0,width: 1.0,height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}
