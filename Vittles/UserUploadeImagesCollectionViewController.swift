//
//  UserUploadeImagesCollectionViewController.swift
//  Vittles
//
//  Created by Jenny Kwok on 10/30/16.
//  Copyright © 2016 Jenny Kwok. All rights reserved.
//

import UIKit
import FirebaseAuth

class UserUploadeImagesCollectionViewController: AllDishImageCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imageHandler.delegate = self
        guard FirebaseUserHandler.currentUDID != nil else {
            print("NO USER LOGGED IN")
            return
        }
        
        imageHandler.getImageThumbnailUrlsFor(userID: (FIRAuth.auth()?.currentUser?.uid)!, imageCount: 10)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
