//
//  DishLargeImageViewController.swift
//  Vittles
//
//  Created by Jenny Kwok on 11/4/16.
//  Copyright © 2016 Jenny Kwok. All rights reserved.
//

import UIKit
import Pages

class DishLargeImageViewController: PagesController {

    //var index:Int = 0
    var imageURLS:[(String,String)] = [(String,String)]()
    
    override func viewDidLoad(){
    
        var views:[UIViewController] = [UIViewController]()
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        for imageURL in imageURLS{
            print("added image url")
            let newVC = storyboard.instantiateViewController(withIdentifier: "GenericImageViewController") as! GenericImageViewController
            newVC.imageURL = imageURL
            views.append(newVC)
        }
        print("num of vies")
        print(views.count)
        self.add(views)
        
        self.enableSwipe = true
        self.showBottomLine = true
        
        
    }
    
}


