//
//  MemeEditorViewController
//  PickImage
//
//  Created by William Oanta on 08/07/2017.
//  Copyright © 2017 William Oanta. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let top = "TOP"
    let bottom = "BOTTOM"

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var memes: [Meme] = []
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
//        if memes.isEmpty {
//            self.cancelButton.isEnabled = false
//        } else {
//            self.cancelButton.isEnabled = true
//        }
        configureDefaultTextAttributes()
        resetToLaunchState()
        topTextField.delegate = self
        bottomTextField.delegate = self
    }
    
    func configureDefaultTextAttributes() {
        
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "Impact", size: 40)!,
            NSStrokeWidthAttributeName: CGFloat(-2.5)]
        
        self.prepareTextField(textField: topTextField, memeTextAttributes: memeTextAttributes)
        self.prepareTextField(textField: bottomTextField, memeTextAttributes: memeTextAttributes)
    }
    
    func prepareTextField(textField: UITextField, memeTextAttributes: [String:Any]) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.center
    }
    
    func resetToLaunchState() {
        topTextField.text = top
        bottomTextField.text = bottom
        imageView.image = nil
        shareButton.isEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Pick Image Actions
    
    func pick(sourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func pickImageFromAlbum(_ sender: Any) {
        self.pick(sourceType: .photoLibrary)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        self.pick(sourceType: .camera)
    }
    
    // MARK: Image Picker Callbacks
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            shareButton.isEnabled = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Text Field Callbacks
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text! == top || textField.text! == bottom {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    // MARK: Keyboard Notifications
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isEditing {
            self.view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK: Cancel Action
    
    @IBAction func onCancelPressed(_ sender: Any) {
        resetToLaunchState()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Share Action
    
    @IBAction func onShareButtonPressed(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController.init(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { activityType, completed, items, error in
            
            if completed {
                self.saveMeme()
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        self.toolbar.isHidden = true
        self.navbar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Hide toolbar and navbar
        self.toolbar.isHidden = false
        self.navbar.isHidden = false
        
        return memedImage
    }
    
    func saveMeme() {
        // Create the meme
        let meme = Meme(top: topTextField.text!, bottom: bottomTextField.text!, image: imageView.image, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

