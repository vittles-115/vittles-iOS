//
//  AppConstants.swift
//  MenuApp
//
//  Created by Jenny Kwok on 2/21/16.
//  Copyright © 2016 Jenny. All rights reserved.
//

import Foundation
import UIKit

let screenSize = UIScreen.main.bounds
let MA_Red = UIColor(red: 255.0/255.0, green: 45.0/255.0, blue: 85.0/255.0, alpha: 1)
let MA_Yellow = UIColor(red: 255.0/255.0, green: 219.0/255.0, blue: 17.0/255.0, alpha: 1)
let MA_Gray = UIColor(red: 99.0/255.0, green: 100.0/255.0, blue: 102.0/255.0, alpha: 1)
let MA_LightGray = UIColor(red: 160.0/255.0, green: 160.0/255.0, blue: 160.0/255.0, alpha: 1)
let MA_BGGray = UIColor(red: 247.0/255.0, green: 245.0/255.0, blue: 243.0/255.0, alpha: 1)
let MA_TabBarInactiveGray = UIColor(red: 140.0/255.0, green: 140.0/255.0, blue: 140.0/255.0, alpha: 1)
let MA_ActionButtonBorderColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.85)
let MA_NonActionButtonBorderColor = UIColor(red: 255.0/255.0, green: 45.0/255.0, blue: 85.0/255.0, alpha: 0.95)

let appDelegate = UIApplication.shared.delegate as! AppDelegate

let loadingPizza:[UIImage] = [UIImage(named: "icons1")!,UIImage(named: "icons1")!,UIImage(named: "icons2")!,UIImage(named: "icons2")!,UIImage(named: "icons3")!,UIImage(named: "icons3")!,UIImage(named: "icons4")!,UIImage(named: "icons4")!,UIImage(named: "icons5")!,UIImage(named: "icons5")!,UIImage(named: "icons6")!,UIImage(named: "icons6")!,UIImage(named: "icons7")!,UIImage(named: "icons7")!,]

let storyboard = UIStoryboard(name: "Main", bundle: nil)

let networkTimeoutDuration:TimeInterval = 10
