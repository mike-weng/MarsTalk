//
//  EmailViewController.swift
//  Itchy
//
//  Created by Mike Weng on 7/5/16.
//  Copyright © 2016 Weng. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import MaterialKit
import Presentr
import Parse
import SSBouncyButton

class SignupViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var nextButton: SSBouncyButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var emailTextfield: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordTextfield: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var confirmPasswordTextfield: SkyFloatingLabelTextFieldWithIcon!
    var keyboardController: KeyboardController!
    let presenter: Presentr = {
        let customType = PresentationType.Custom(width: .Custom(size: 300), height: .Custom(size: 400), center: .Center)
        let presenter = Presentr(presentationType: customType)
        presenter.transitionType = .CoverVerticalFromTop
        presenter.roundCorners = true
        presenter.dismissOnTap = false
        
        return presenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyboardController = KeyboardController(viewController: self)
        self.configureUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        keyboardController.registerTapToHideKeyboard()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardController.unregisterTapToHideKeyboard()
    }

    @IBAction func nextButtonTouchUp(sender: AnyObject) {
        AlertController.sharedInstance.startActivityIndicator(self)
        let user = PFUser()
        user.username = emailTextfield.text
        user.password = passwordTextfield.text
        user.email = emailTextfield.text
        
        user.signUpInBackgroundWithBlock({ (success, error) in
            if let error = error {
                let errorMsg = error.userInfo["error"] as? String
                AlertController.sharedInstance.showOneActionAlert("Sign Up Failed", body: errorMsg!, actionTitle: "Retry", viewController: self)
            } else {
                let verificationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("VerificationViewController") as! VerificationViewController
                verificationViewController.userEmail = self.emailTextfield.text
                self.customPresentViewController(self.presenter, viewController: verificationViewController, animated: true, completion: nil)
            }
            AlertController.sharedInstance.stopActivityIndicator()
        })

    }
    
    @IBAction func loginWithExistingAccountButtonTouchUp(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func configureUI() {
        self.view.backgroundColor = UIColor.blackColor()
        self.view.sendSubviewToBack(backgroundImageView)
        self.configureEmailTextfield()
        self.configurePasswordTextfield()
        self.configureConfirmPasswordTextfield()
    }
    
    func configureEmailTextfield() {
        // Set icon properties
        self.emailTextfield.delegate = self
        self.emailTextfield.iconColor = UIColor.whiteColor()
        self.emailTextfield.selectedIconColor = UIColor.whiteColor()
        self.emailTextfield.iconFont = UIFont(name: "FontAwesome", size: 18)
        self.emailTextfield.iconText = "\u{f007}" // plane icon as per https://fortawesome.github.io/Font-Awesome/cheatsheet/
        self.emailTextfield.iconMarginBottom = 4.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        self.emailTextfield.iconMarginLeft = 2.0
        
    }
    
    func configurePasswordTextfield() {
        // Set icon properties
        self.passwordTextfield.delegate = self
        self.passwordTextfield.iconColor = UIColor.whiteColor()
        self.passwordTextfield.selectedIconColor = UIColor.whiteColor()
        self.passwordTextfield.iconFont = UIFont(name: "FontAwesome", size: 18)
        self.passwordTextfield.iconText = "\u{f023}" // plane icon as per https://fortawesome.github.io/Font-Awesome/cheatsheet/
        self.passwordTextfield.iconMarginBottom = 4.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        self.passwordTextfield.iconMarginLeft = 2.0
    }
    
    func configureConfirmPasswordTextfield() {
        // Confirm PasswordTextfield
        self.confirmPasswordTextfield.delegate = self
        self.confirmPasswordTextfield.iconColor = UIColor.whiteColor()
        self.confirmPasswordTextfield.selectedIconColor = UIColor.whiteColor()
        self.confirmPasswordTextfield.iconFont = UIFont(name: "FontAwesome", size: 18)
        self.confirmPasswordTextfield.iconText = "\u{f023}" // plane icon as per https://fortawesome.github.io/Font-Awesome/cheatsheet/
        self.confirmPasswordTextfield.iconMarginBottom = 4.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        self.confirmPasswordTextfield.iconMarginLeft = 2.0
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if let text = textField.text {
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextFieldWithIcon {
                if (floatingLabelTextField == confirmPasswordTextfield) {
                    if(text != passwordTextfield.text) {
                        floatingLabelTextField.errorMessage = "Passwords do not match"
                        self.nextButton.enabled = false
                    } else {
                        // The error message will only disappear when we reset it to nil or empty string
                        self.nextButton.enabled = true
                        floatingLabelTextField.errorMessage = ""
                    }
                }
            }
        }
        return true
    }
}
