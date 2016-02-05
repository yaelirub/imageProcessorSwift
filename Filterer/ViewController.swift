//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

public enum FilterType : Int {
     case filterTypeGreyScale  = 1, filterTypeBlurry , filterTypeBight , filterTypeDark , filterTypeBlue , filterTypeSepia

}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIGestureRecognizerDelegate {

    var filteredImage: UIImage?
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    @IBOutlet var compareButton: UIButton!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var originalLabel: UILabel!
    
    var originalImage : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        
        originalImage = imageView.image
        compareButton.enabled = false
        imageView.userInteractionEnabled = true
        let imageTapRecognizer = UILongPressGestureRecognizer(target: self, action: "handleImageTap:")
        imageView.addGestureRecognizer(imageTapRecognizer)
        imageTapRecognizer.delegate = self
    }

    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        if (sender.selected) {
            hideSecondaryMenu()
            compareButton.selected = false
            compareButton.enabled = false
            sender.selected = false
        } else {
            showSecondaryMenu()
            sender.selected = true
        }
    }
    
    //MARK : Secondery menu
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }

    func hideSecondaryMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        }
    }
    
    @IBAction func onSelectedFilter(sender:UIButton) {

        let image = self.originalImage
        var filterName : String!
        switch sender.tag {

        case FilterType.filterTypeGreyScale.rawValue:
            filterName = "greyscale"
            
        case FilterType.filterTypeBlurry.rawValue :
            filterName = "blurry"
            
        case FilterType.filterTypeBight.rawValue:
            filterName = "bright"
            
        case FilterType.filterTypeDark.rawValue:
            filterName = "dark"
            
        case FilterType.filterTypeBlue.rawValue:
            filterName = "blue"
            
        case FilterType.filterTypeSepia.rawValue:
            filterName = "sepia"
        
        default :
            filterName = "none"
        }
        compareButton.enabled = true
        filteredImage = MyImageProcessor().filter(image, filterName: filterName)
        imageView.image = filteredImage
        originalLabel.hidden = true
    }
    
    //MARK  compare
    
    @IBAction func onCompare(sender: UIButton) {

        if (sender.selected) {
            imageView.image = filteredImage
            originalLabel.hidden = true
            sender.selected = false
        } else {
            filteredImage = imageView.image
            imageView.image = self.originalImage
            originalLabel.hidden = false
            sender.selected = true
            
        }
    }
    
    //long press image to show the original image
    func handleImageTap(gestureRecognizer : UILongPressGestureRecognizer)
    {
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            imageView.image = self.originalImage
            originalLabel.hidden = false
        }
        else if gestureRecognizer.state == UIGestureRecognizerState.Ended {
            if (self.filteredImage != nil) {
                originalLabel.hidden = true
                imageView.image = self.filteredImage
            }
        }
        
    }

}