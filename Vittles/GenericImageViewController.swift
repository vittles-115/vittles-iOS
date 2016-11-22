//
//  GenericImageViewController.swift
//  Vittles
//
//  Created by Jenny Kwok on 11/21/16.
//  Copyright © 2016 Jenny Kwok. All rights reserved.
//

import UIKit

class GenericImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var imageURL:(String,String)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard imageURL != nil else{
            return
        }
        self.imageView.kf.setImage(with: URL(string: (imageURL?.1)!), placeholder: UIImage(named: "placeholderPizza")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
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
