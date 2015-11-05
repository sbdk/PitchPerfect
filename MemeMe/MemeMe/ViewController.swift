//
//  ViewController.swift
//  MemeMe
//
//  Created by Li Yin on 10/29/15.
//  Copyright © 2015 Li Yin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var NaviBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    //define text attributes for both textfield
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName :UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    
    //hide status bar for bigger editing area
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        //disable share button when no image selected
        if imagePickerView.image == nil  {
            
            shareButton.enabled = false
        }
        
        subscribeToKeyboarWillShowdNotifications()
        subscribeToKeyboarWillHidedNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.text = "TOP"
        topTextField.layer.zPosition = 1
        topTextField.delegate = self
        topTextField.textAlignment = NSTextAlignment.Center
      
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.text = "BOTTOM"
        bottomTextField.layer.zPosition = 1
        bottomTextField.delegate = self
        bottomTextField.textAlignment = NSTextAlignment.Center
        
        //put navigation bar and toolbar on top of main editing view
        NaviBar.layer.zPosition = 2
        toolBar.layer.zPosition = 2
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    //define all button action function below:
    
    @IBAction func pickImage(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func takePhoto(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
       
    }
    
    @IBAction func sharePhoto(sender: AnyObject) {
        
        let finishedImage = generateMemedImage()
        
        let shareViewController = UIActivityViewController(activityItems: [finishedImage], applicationActivities: nil)

        shareViewController.completionWithItemsHandler = {
            activity, completed, items, error in
            if completed {
                self.saveMeme()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        presentViewController(shareViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelMeme(sender: AnyObject) {
        
        var initView = UIViewController()
        initView = (storyboard?.instantiateViewControllerWithIdentifier("memeEditViewController"))!
        
        presentViewController(initView, animated: false, completion: nil)
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboarWillShowdNotifications()
        unsubscribeFromKeyboarWillHidedNotifications()
    }
    
    
    
    //define all custom function below:
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let tempImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = tempImage
            dismissViewControllerAnimated(true, completion: nil)
            
        //enable share button when finish picking image
        shareButton.enabled = true
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //clear textfield if they contain default stings.
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    //dismiss keyboard when user hit return while in textfield
    func textFieldShouldReturn(textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         return true
    }
    
    
    
    
    //define view rise effect useing keyboard notification below:
    
    func keyboardWillShow(notification: NSNotification) {
        
        //make view rise or fall effect only valid for bottom textfield
        if bottomTextField.editing {
        view.frame.origin.y -= getKeyboardHeight(notification)
        }
        else {
            
        }
    }
    
    func keyboardWillHide(notifiction: NSNotification) {
        
        //make view rise or fall effect only valid for bottom textfield
        if bottomTextField.editing {
        view.frame.origin.y += getKeyboardHeight(notifiction)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat
    {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    
    
    
    func subscribeToKeyboarWillShowdNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboarWillShowdNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    func subscribeToKeyboarWillHidedNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboarWillHidedNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    
    
    //generate final image and save object below:
    
    func generateMemedImage() -> UIImage {
        
        NaviBar.hidden = true
        toolBar.hidden = true
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        
        NaviBar.hidden = false
        toolBar.hidden = false
        
        return memedImage
    }
    
    func saveMeme() {
        
        struct Meme {
            var topText: String
            var bottomText: String
            var pickedImage: UIImage
            var memedImage: UIImage
        }
        
        let meme = Meme (topText: topTextField.text!, bottomText: bottomTextField.text!, pickedImage: imagePickerView.image!, memedImage: generateMemedImage())
        
    }
    
}

