//
//  AllDishImageCollectionViewController.swift
//  Vittles
//
//  Created by Jenny Kwok on 10/29/16.
//  Copyright © 2016 Jenny Kwok. All rights reserved.
//

import UIKit

private let reuseIdentifier = "dishThumbnailCell"

class AllDishImageCollectionViewController: DishImageCollectionViewController {

    var dish:DishObject?
    let imageHandler:FirebaseImageHandler = FirebaseImageHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard dish != nil else {
            return
        }
        imageHandler.delegate = self
        imageHandler.getImageThumbnailUrlsFor(dishID: (dish?.uniqueID)!, imageCount: 200)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> DishThumbnailCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DishThumbnailCollectionViewCell
        
        // Configure the cell
        cell.setUpCellFromURL(self.imageURLS[indexPath.row].0, square: true)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let width = screenSize.width / 3
        return CGSize(width: width, height: width)
        
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
