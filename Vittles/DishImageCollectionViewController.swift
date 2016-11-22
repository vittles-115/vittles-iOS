//
//  DishImageCollectionViewController.swift
//  Vittles
//
//  Created by Jenny Kwok on 10/28/16.
//  Copyright © 2016 Jenny Kwok. All rights reserved.
//

import UIKit
import Pages

private let reuseIdentifier = "dishThumbnailCell"

class DishImageCollectionViewController: UICollectionViewController ,FirebaseImageHandlerDelegate{
    
    var imageURLS:[(String,String)] = [(String,String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(DishThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imageURLS.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> DishThumbnailCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DishThumbnailCollectionViewCell
    
        // Configure the cell
        cell.setUpCellFromURL(self.imageURLS[indexPath.row].0, square: false)
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //(self.parent as! FoodDetailViewController).performSegue(withIdentifier: "viewLargeImage", sender: self.imageURLS
        var views:[UIViewController] = [UIViewController]()
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        for imageURL in imageURLS{
            print("added image url")
            let newVC = storyboard.instantiateViewController(withIdentifier: "GenericImageViewController") as! GenericImageViewController
            newVC.imageURL = imageURL
            views.append(newVC)
        }
        
        let pagesVC:PagesController = PagesController(views)
        pagesVC.startPage = indexPath.row
        pagesVC.hidesBottomBarWhenPushed = true
        
    
        if self is AllDishImageCollectionViewController{
            self.navigationController?.pushViewController(pagesVC, animated: true)
        }else{
             self.parent?.navigationController?.pushViewController(pagesVC, animated: true)
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 70, height: 70)
        
    }
    
    func didFetchUrls(urlDictArray:[NSDictionary]){
        //self.dishImageURLs = urlDictionary as! [NSDictionary]
        print("image urls?")
        print(urlDictArray)
        
        for image in urlDictArray{
            
            guard let thumbnailURL = image.value(forKey: FirebaseImageKey_thumbnail) as? String else{
                continue
            }
            guard let fullSizedUrl = image.value(forKey: FirebaseImageKey_fullSized) as? String else{
                continue
            }
            self.imageURLS.append((thumbnailURL,fullSizedUrl))
            
        }
        self.collectionView?.reloadData()
    }
    
    func failedToFetchURLS(errorString:String){
        print(errorString)
    }

}









