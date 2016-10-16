//
//  ReviewViewController.swift
//  Vittles
//


import UIKit

class ReviewViewController: UIViewController,UITextFieldDelegate,UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var restaurantTextfield: UITextField!
    @IBOutlet weak var restaurantLabelView: UIView!
    
    @IBOutlet weak var dishTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        restaurantTextfield.delegate = self
        dishTextfield.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("text field editing")
        if textField == self.restaurantTextfield {
            self.view.endEditing(true)
            self.performSegue(withIdentifier: "showRestaurantPicker", sender: self)
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showRestaurantPicker"{
            let destinationVC = segue.destination as! ReviewPickRestaurantMainViewController
            
            let controller = destinationVC.popoverPresentationController;
            controller?.sourceView = self.view
            controller?.sourceRect = CGRect(x:self.view.bounds.midX, y:self.view.bounds.midY,width: 0, height: 0)
            controller?.delegate = self
            
            
        }
    }
    

}
