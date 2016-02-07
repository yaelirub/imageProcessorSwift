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
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var filteredImageView: UIImageView!
    
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var greyScaleFilterButton: UIButton!
    @IBOutlet var blurryFilterButton: UIButton!
    @IBOutlet var brightFilterButton: UIButton!
    @IBOutlet var darktFilterButton: UIButton!
    @IBOutlet var bluetFilterButton: UIButton!
    @IBOutlet var sepiatFilterButton: UIButton!
    
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
        self.setFilterButtonsImages()
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
            imageView.image = originalImage
            UIView.animateWithDuration(0.4, animations:{
                self.filteredImageView.alpha = 0
            })
            
        } else {
            showSecondaryMenu()
            sender.selected = true
        }
    }
    
    //MARK : Secondery menu
    
    func setFilterButtonsImages()
    {
        var filteredImage = MyImageProcessor().filter(originalImage, filterName: "greyscale")
        greyScaleFilterButton.setBackgroundImage(filteredImage, forState: (UIControlState.Normal))
        
        filteredImage = MyImageProcessor().filter(originalImage, filterName: "blurry")
        blurryFilterButton.setBackgroundImage(filteredImage, forState: (UIControlState.Normal))
        
        filteredImage = MyImageProcessor().filter(originalImage, filterName: "bright")
        brightFilterButton.setBackgroundImage(filteredImage, forState: (UIControlState.Normal))
        
        filteredImage = MyImageProcessor().filter(originalImage, filterName: "dark")
        darktFilterButton.setBackgroundImage(filteredImage, forState: (UIControlState.Normal))
        
        filteredImage = MyImageProcessor().filter(originalImage, filterName: "blue")
        bluetFilterButton.setBackgroundImage(filteredImage, forState: (UIControlState.Normal))
        
        filteredImage = MyImageProcessor().filter(originalImage, filterName: "sepia")
        sepiatFilterButton.setBackgroundImage(filteredImage, forState: (UIControlState.Normal))
        
    }
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
        filteredImageView.image = MyImageProcessor().filter(image, filterName: filterName)
        filteredImageView.alpha = 0.0
        UIView.animateWithDuration(0.4, animations: {
            self.filteredImageView.alpha = 1.0
        })
        
        originalLabel.hidden = true
    }
    
    //MARK  compare
    
    @IBAction func onCompare(sender: UIButton) {
        if (sender.selected) {
            UIView.animateWithDuration(0.4, animations: {
                self.filteredImageView.alpha = 1.0
            })
            originalLabel.hidden = true
            sender.selected = false
        } else {
            UIView.animateWithDuration(0.4, animations: {
                self.filteredImageView.alpha = 0.0
            })
            originalLabel.hidden = false
            sender.selected = true
            
        }
    }
    
    //long press image to show the original image
    func handleImageTap(gestureRecognizer : UILongPressGestureRecognizer)
    {
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            self.filteredImageView.alpha = 0.0
            originalLabel.hidden = false
        }
        else if gestureRecognizer.state == UIGestureRecognizerState.Ended {
                self.filteredImageView.alpha = 1.0
                originalLabel.hidden = true
        }
        
    }
    
    
}