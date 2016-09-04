//
//  LoginViewController.swift
//  Itchy
//
//  Created by Mike Weng on 6/29/16.
//  Copyright © 2016 Weng. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SSBouncyButton
import Parse
import FBSDKCoreKit
import SVProgressHUD
import ParseFacebookUtilsV4
import SVProgressHUD
import FoldingTabBar
import DisplaySwitcher


class LoginViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var loginButton: SSBouncyButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var emailTextfield: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordTextfield: SkyFloatingLabelTextFieldWithIcon!
    var keyboardController: KeyboardController!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.initializeFoldingTabBarController()
        keyboardController = KeyboardController(viewController: self)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        keyboardController.registerTapToHideKeyboard()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardController.unregisterTapToHideKeyboard()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        autoLogin()
    }
    
    func autoLogin() {
        if PFUser.currentUser()?.objectId != nil {
            let user = PFUser.currentUser()!
            let currentUser = User(user: user)
            User.currentUser = currentUser
            
            // load user image
            if let profileImage = user["profileImage"] {
                profileImage.getDataInBackgroundWithBlock { (result, error) -> Void in
                    if let imageData = result {
                        currentUser.profileImage = UIImage(data: imageData)!
                    }
                }
            }
            
            self.presentViewController(self.appDelegate.tabBarController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func loginButtonTouchUp(sender: AnyObject) {
        if (emailTextfield.text == "" || passwordTextfield.text == "") {
            AlertController.sharedInstance.showOneActionAlert("Empty username/passwords", body: "Please enter username and passwords", actionTitle: "Retry", viewController: self)
        } else {
            AlertController.sharedInstance.startNormalActivityIndicator(self)
            loginWithEmail(emailTextfield.text!, password: passwordTextfield.text!)
        }
    }
    
    func loginWithEmail(email: String, password: String) {
        PFUser.logInWithUsernameInBackground(email, password: password, block: { (user: PFUser?, error: NSError?) in
            if let user = user {
                let currentUser = User(user: user)
                User.currentUser = currentUser
                
                // load user image
                if let profileImage = user["profileImage"] {
                    profileImage.getDataInBackgroundWithBlock { (result, error) -> Void in
                        if let imageData = result {
                            currentUser.profileImage = UIImage(data: imageData)!
                        }
                    }
                }
                
                // bind push installation to user
                let currentInstallation = PFInstallation.currentInstallation()!
                currentInstallation["user"] = user
                currentInstallation.saveInBackground()
                print("binded")
                
            } else {
                let errorMsg = error!.userInfo["error"] as? String
                AlertController.sharedInstance.showOneActionAlert("Login Failed", body: errorMsg!, actionTitle: "Retry", viewController: self)
            }
            AlertController.sharedInstance.stopNormalActivityIndicator()
            self.presentViewController(self.appDelegate.tabBarController, animated: true, completion: nil)
        })
        
    }

    
    @IBAction func facebookLoginTouchUp(sender: AnyObject) {
        AlertController.sharedInstance.startNormalActivityIndicator(self)
        let permission = ["public_profile", "user_friends", "email"]
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permission) { (user, error) -> Void in
            if let user = user {
                if user.isNew {
                    self.getFBUserInfo()
                }
                
                let currentUser = User(user: user)
                User.currentUser = currentUser
                
                // load user image
                if let profileImage = user["profileImage"] {
                    profileImage.getDataInBackgroundWithBlock { (result, error) -> Void in
                        if let imageData = result {
                            currentUser.profileImage = UIImage(data: imageData)!
                        }
                    }
                }
                
                
                // bind push installation to user
                let currentInstallation = PFInstallation.currentInstallation()!
                currentInstallation["user"] = user
                currentInstallation.saveInBackground()
                print("binded")
            } else {
                let errorMsg = error!.userInfo["error"] as? String
                AlertController.sharedInstance.showOneActionAlert("Login Failed", body: errorMsg!, actionTitle: "Ok", viewController: self)
            }
            AlertController.sharedInstance.stopNormalActivityIndicator()
            self.presentViewController(self.appDelegate.tabBarController, animated: true, completion: nil)
        }
    }
    
    func getFBUserInfo() {
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "first_name, last_name, email"])
        graphRequest.startWithCompletionHandler { (connection, result, error) in
            if let result = result as? [String:String] {
                let currentUser: PFUser = PFUser.currentUser()!
                currentUser["firstName"] = result["first_name"]
                currentUser["lastName"] = result["last_name"]
                currentUser["email"] = result["email"]
                let userID = result["id"]
                self.getFBProfileImage(userID!)
                
                currentUser.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if !success {
                        AlertController.sharedInstance.showOneActionAlert("Error", body: error!.userInfo["error"] as! String, actionTitle: "Retry", viewController: self)
                    }
                })
            } else {
                AlertController.sharedInstance.showOneActionAlert("Error", body: error!.userInfo["error"] as! String, actionTitle: "Retry", viewController: self)
            }
        }

    }
    func getFBProfileImage(userID: String) {
        let urlString = "https://graph.facebook.com/" + userID + "/picture?type=large"
        if let url = NSURL(string: urlString) {
            if let data = NSData(contentsOfURL: url) {
                if let file = PFFile(data: data) {
                    let currentUser: PFUser = PFUser.currentUser()!
                    currentUser["profileImage"] = file
                }
            }
        }
    }
    
        
    @IBAction func registerTouchUp(sender: AnyObject) {
        let signupViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SignupViewController") as! SignupViewController
        self.presentViewController(signupViewController, animated: true, completion: nil)
    }
    
    func initializeFoldingTabBarController() {
        self.appDelegate.tabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as! YALFoldingTabBarController
        let item1: YALTabBarItem = YALTabBarItem(itemImage: UIImage(named: "ProfileIcon")!, leftItemImage: UIImage(named: "RotateIcon")!, rightItemImage: nil)
        let item2: YALTabBarItem = YALTabBarItem(itemImage: UIImage(named: "ChatIcon")!, leftItemImage: UIImage(named: "SearchIcon")!, rightItemImage: UIImage(named: "NewChatIcon")!)
        let item3: YALTabBarItem = YALTabBarItem(itemImage: UIImage(named: "GroupIcon")!, leftItemImage: UIImage(named: "SearchIcon")!, rightItemImage: UIImage(named: "NewChatIcon")!)
        let item4: YALTabBarItem = YALTabBarItem(itemImage: UIImage(named: "SettingIcon")!, leftItemImage: nil, rightItemImage: nil)
        self.appDelegate.tabBarController.leftBarItems = [item1, item2]
        self.appDelegate.tabBarController.rightBarItems = [item3, item4]
        self.appDelegate.tabBarController.centerButtonImage = UIImage(named: "PlusIcon")!
        self.appDelegate.tabBarController.selectedIndex = 0
        self.appDelegate.tabBarController.tabBarView.extraTabBarItemHeight = YALExtraTabBarItemsDefaultHeight
        self.appDelegate.tabBarController.tabBarView.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset
        self.appDelegate.tabBarController.tabBarView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        self.appDelegate.tabBarController.tabBarView.tabBarColor = UIColor.blackColor()
        self.appDelegate.tabBarController.tabBarViewHeight = YALTabBarViewDefaultHeight
        self.appDelegate.tabBarController.tabBarView.tabBarViewEdgeInsets = YALTabBarViewHDefaultEdgeInsets
        self.appDelegate.tabBarController.tabBarView.tabBarItemsEdgeInsets = YALTabBarViewItemsDefaultEdgeInsets
        self.appDelegate.tabBarController.tabBarView.offsetForExtraTabBarItems = 24
    }
    
    func configureUI() {
        self.view.backgroundColor = UIColor.blackColor()
        self.view.sendSubviewToBack(backgroundImageView)
        configureemailTextfield()
        configurePasswordTextField()
    }
    
    func configureemailTextfield() {
        self.emailTextfield.delegate = self
        self.emailTextfield.placeholder = "Username"
        self.emailTextfield.title = "Username"
        
        self.emailTextfield.tintColor = UIColor.whiteColor()
        self.emailTextfield.lineColor = UIColor.whiteColor()
        self.emailTextfield.titleColor = UIColor.whiteColor()
        
        self.emailTextfield.selectedTitleColor = UIColor.whiteColor()
        self.emailTextfield.selectedLineColor = UIColor.whiteColor()
        // Set icon properties
        self.emailTextfield.iconColor = UIColor.whiteColor()
        self.emailTextfield.selectedIconColor = UIColor.whiteColor()
        self.emailTextfield.iconFont = UIFont(name: "FontAwesome", size: 18)
        self.emailTextfield.iconText = "\u{f007}" // plane icon as per https://fortawesome.github.io/Font-Awesome/cheatsheet/
        self.emailTextfield.iconMarginBottom = 4.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        self.emailTextfield.iconMarginLeft = 2.0
    }
    
    func configurePasswordTextField() {
        self.passwordTextfield.delegate = self
        self.passwordTextfield.placeholder = "Password"
        self.passwordTextfield.title = "Password"
        
        self.passwordTextfield.tintColor = UIColor.whiteColor()
        self.passwordTextfield.lineColor = UIColor.whiteColor()
        self.passwordTextfield.titleColor = UIColor.whiteColor()
        
        self.passwordTextfield.selectedTitleColor = UIColor.whiteColor()
        self.passwordTextfield.selectedLineColor = UIColor.whiteColor()
        
        // Set icon properties
        self.passwordTextfield.iconColor = UIColor.whiteColor()
        self.passwordTextfield.selectedIconColor = UIColor.whiteColor()
        self.passwordTextfield.iconFont = UIFont(name: "FontAwesome", size: 18)
        self.passwordTextfield.iconText = "\u{f023}" // plane icon as per https://fortawesome.github.io/Font-Awesome/cheatsheet/
        self.passwordTextfield.iconMarginBottom = 4.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        self.passwordTextfield.iconMarginLeft = 2.0

    }

    
}

