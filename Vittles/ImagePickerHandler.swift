
import Foundation
import UIKit
import MobileCoreServices

protocol ImagePickerHandlerDelegate {
    func handlerDidFinishPickingImage(_ image: UIImage)
}

class ImagePickerHandler: NSObject, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate {
    var currentViewController: UIViewController?
    fileprivate lazy var cameraUI = UIImagePickerController()
    var delegate: ImagePickerHandlerDelegate?
    var withCropping = true
    var sourceView: UIView?
    
    init(currentViewController: UIViewController, withCropping: Bool) {
        self.currentViewController = currentViewController
        self.withCropping = withCropping
    }
    
    func showOptions() {
        print("show options")
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let option1 = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.default, handler: {(actionSheet: UIAlertAction) in (self.presentCamera())})
            let option2 = UIAlertAction(title: "Choose Existing Photo", style: UIAlertActionStyle.default, handler: {(actionSheet: UIAlertAction) in (self.presentCameraRoll())})
            let option3 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(actionSheet: UIAlertAction) in ()})
            
            actionSheet.addAction(option1)
            actionSheet.addAction(option2)
            actionSheet.addAction(option3)
            
            actionSheet.popoverPresentationController?.sourceView = currentViewController!.view
            actionSheet.popoverPresentationController?.sourceRect = currentViewController!.view.frame
            
            currentViewController!.present(actionSheet, animated: true, completion: nil)
        } else {
            presentCameraRoll()
        }
    }
    
    fileprivate func presentCamera() {
        cameraUI = UIImagePickerController()
        cameraUI.delegate = self
        cameraUI.sourceType = UIImagePickerControllerSourceType.camera
        cameraUI.mediaTypes = NSArray(object: kUTTypeImage) as! [String]
        cameraUI.allowsEditing = withCropping
        currentViewController!.present(cameraUI, animated: true, completion: nil)
    }
    
    fileprivate func presentCameraRoll() {
        cameraUI = UIImagePickerController()
        cameraUI.delegate = self
        cameraUI.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        cameraUI.mediaTypes = NSArray(object: kUTTypeImage) as! [String]
        cameraUI.allowsEditing = withCropping
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let popover = UIPopoverController(contentViewController: cameraUI)
            
            if let source = sourceView {
                popover.present(from: source.frame, in: currentViewController!.view, permittedArrowDirections: UIPopoverArrowDirection.up, animated: true)
            } else {
                popover.present(from: currentViewController!.view.frame, in: currentViewController!.view, permittedArrowDirections: UIPopoverArrowDirection(), animated: true)
            }
        } else {
            currentViewController!.present(cameraUI, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var resultingImage: UIImage?
        
        if withCropping {
            resultingImage = info[UIImagePickerControllerEditedImage] as? UIImage
            
        } else {
            resultingImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        delegate?.handlerDidFinishPickingImage(resultingImage!)
        currentViewController!.dismiss(animated: true, completion: nil)
    }
}
