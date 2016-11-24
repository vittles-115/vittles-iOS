//
//  StoryboardHelpers.swift
//  Vittles
//
//  Created by Jenny Kwok on 10/29/16.
//  Copyright © 2016 Jenny Kwok. All rights reserved.
//

import Foundation
import UIKit

func pushFoodDetailVC(_ dish:DishObject){
    

    let tabBarController = appDelegate.window!.rootViewController as! UITabBarController
    tabBarController.selectedIndex = 0
    
    let storyboard =  UIStoryboard(name: "Home", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "FoodDetailViewController") as! FoodDetailViewController
    
    
    vc.dish = dish
    vc.view.frame = UIScreen.main.bounds
    
    let callingVC = tabBarController.selectedViewController!
    
    if(callingVC is UINavigationController){
        print("naviController ")
        (callingVC as! UINavigationController).popViewController(animated: false)
        (callingVC as! UINavigationController).pushViewController(vc, animated: true)
    }else{
        print("push to navi controller ")
        callingVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

func pushReviewVC(dish:DishObject, restaurant:RestaurantObject){
    let tabBarController = appDelegate.window!.rootViewController as! UITabBarController
    tabBarController.selectedIndex = 1
    let reviewVC = (tabBarController.selectedViewController as! UINavigationController).viewControllers.first as! ReviewViewController
    reviewVC.clearButtonPressed(reviewVC)
    reviewVC.pickedRestaurant = restaurant
    reviewVC.pickedDish = dish

}
