//
//  DPLoadingIndicator.swift
//  Vittles
//
//  Created by Jenny Kwok on 11/1/16.
//  Copyright © 2016 Jenny Kwok. All rights reserved.
//

import UIKit

class DPLoadingIndicator: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    static let sharedInstance = DPLoadingIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 100), loadingImages: [UIImage(named:"icons7")!, UIImage(named:"icons6")!, UIImage(named:"icons5")!,UIImage(named:"icons4")!,UIImage(named:"icons3")!,UIImage(named:"icons2")!,UIImage(named:"icons1")!] )
    
    
    convenience init(frame: CGRect, loadingImages:[UIImage]) {
        self.init(frame: frame)
        self.animationImages = loadingImages
        self.animationDuration = 2
        self.alpha = 0.7
        self.setCornerRadius(9)
        self.start()
    }
    
    func start(){
        self.startAnimating()
    }
    
    func stop(){
        self.stopAnimating()
    }
    
    class func loadingIndicator()->DPLoadingIndicator{
        return DPLoadingIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 100), loadingImages: [UIImage(named:"icons7")!, UIImage(named:"icons6")!, UIImage(named:"icons5")!,UIImage(named:"icons4")!,UIImage(named:"icons3")!,UIImage(named:"icons2")!,UIImage(named:"icons1")!] )
    }

}
