//
//  ProfileMainViewController.swift
//  Vittles
//

import UIKit

class ProfileMainViewController: UIViewController,ImagePickerHandlerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tapToEditImageButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var imagePicker: ImagePickerHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker = ImagePickerHandler(currentViewController: self, withCropping: true)
        imagePicker!.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func picturePressed(_ sender: AnyObject) {
        
        imagePicker?.showOptions()
        
    }
    
    // MARK: - Image Picker Delegate
    func handlerDidFinishPickingImage(_ image: UIImage) {
        
       self.profileImageView.image = image
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
