//
//  MAPostPictureCollectionViewController.swift
//  MenuApp
//
//  Created by Jenny Kwok on 2/28/16.
//  Copyright © 2016 Jenny. All rights reserved.
//

import UIKit

private let reuseIdentifier = "dishThumbnailCell"

class MAPostPictureCollectionViewController: UICollectionViewController,ImagePickerHandlerDelegate {
    
    var imagesToPost:[UIImage] = [UIImage]()
    var imagePicker: ImagePickerHandler?


    override func viewDidLoad() {
        super.viewDidLoad()

        //Initialize image picker
        imagePicker = ImagePickerHandler(currentViewController: self, withCropping: true)
        imagePicker!.delegate = self
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        if section == 0{
            return 1
        }else{
           return self.imagesToPost.count
        }
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dishThumbnailCell", for: indexPath) as! DishThumbnailCollectionViewCell
        
        // Configure the cell
        if((indexPath as NSIndexPath).section == 0){
            cell.backgroundColor = UIColor(red: 235.0/255, green: 235.0/255, blue: 235.0/255, alpha: 1)
            let cameraImageView = UIImageView(frame: CGRect(x: 17.5, y: 17.5, width: 35, height: 35))
            cameraImageView.image =  UIImage(named: "Review")!
            
            
            //cameraImageView.center = cell.center
            cell.layer.cornerRadius = 9
            cell.clipsToBounds = true
            cell.addSubview(cameraImageView)
            
            //cell.setUpCellFromImage(UIImage(named: "Camera.png")!)
        }else{
            cell.setUpCellFromImage(self.imagesToPost[(indexPath as NSIndexPath).row],square: false)
        }
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).section == 0{
            if self.imagesToPost.count < 3{
                imagePicker?.showOptions()
            }else{
                let alert = UIAlertController(title: "Too many pictures", message: "Sorry you can only upload up to 3 pictures at a time", preferredStyle: UIAlertControllerStyle.alert)
                //Add alert action that closes the VC when done is pressed
               alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                //Persent alert
                self.present(alert, animated: true, completion: nil)

            }
            
        }
    }
    
    // MARK: - Handler Delegate
    func handlerDidFinishPickingImage(_ image: UIImage) {
        self.imagesToPost.append(image)
        self.collectionView?.reloadData()
    }


}
