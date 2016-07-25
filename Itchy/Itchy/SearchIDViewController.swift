//
//  SearchIDViewController.swift
//  MarsTalk
//
//  Created by Mike Weng on 7/22/16.
//  Copyright © 2016 Weng. All rights reserved.
//

import UIKit
import FoldingTabBar
import MaterialKit

class SearchIDViewController: UIViewController, YALTabBarDelegate, UISearchBarDelegate {
    var keyboardController: KeyboardController!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addButton: MKButton!
    var searchQuery: PFQuery?
    var searchResult = [PFObject]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        keyboardController = KeyboardController(viewController: self)
        self.appDelegate.tabBarController.tabBarView.setExtraLeftTabBarButtonImage(UIImage(named: "BackIcon"), index: 1)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        keyboardController.registerTapToHideKeyboard()
        self.hideResult()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardController.unregisterTapToHideKeyboard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addFriendButtonTouchUp(sender: AnyObject) {
        AlertController.sharedInstance.startNormalActivityIndicator(self)
        let user = PFUser.currentUser()!
        let target = self.searchResult[0] as! PFUser
        let userRelation = user.relationForKey("friends")
        userRelation.addObject(target)
        
        user.saveInBackgroundWithBlock({ (success, error) -> Void in
            if success {
                // send push
                let targetFirstName = target["firstName"] as! String
                let targetLastName = target["lastName"] as! String
                let userQuery = PFUser.query()!
                userQuery.whereKey("username", equalTo:target.username!)
                let pushQuery = PFInstallation.query()
                pushQuery!.whereKey("user", matchesQuery: userQuery)
                let message = targetFirstName + " " + targetLastName + " wants to add you as a friend"
                
                let data = [
                    "alert" : message,
                    "badge" : "Increment",
                    "sounds" : "default"
                ]
                let push = PFPush()
                push.setQuery(pushQuery)
                push.setData(data)
                push.sendPushInBackground()
                AlertController.sharedInstance.showOneActionAlert("Successfully added!", body: "Hurry and start a chat!", actionTitle: "Ok", viewController: self)
            } else {
                AlertController.sharedInstance.showOneActionAlert("Error", body: error!.userInfo["error"] as! String, actionTitle: "Retry", viewController: self)
            }
            self.navigationController?.popViewControllerAnimated(true)
            AlertController.sharedInstance.stopNormalActivityIndicator()
        })
    }
    func tabBarDidSelectExtraLeftItem(tabBar: YALFoldingTabBar!) {
        self.navigationController?.popViewControllerAnimated(true)
        self.appDelegate.tabBarController.tabBarView.setExtraLeftTabBarButtonImage(UIImage(named: "RotateIcon"), index: 1)
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.view.endEditing(true)
        self.showResult()
    }
    
    /* Each time the search text changes we want to cancel any current download and start a new one */
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        /* Cancel the last task */
        if let query = searchQuery {
            query.cancel()
        }
        
        /* If the text is empty we are done */
        if searchText == "" {
            searchResult = [PFObject]()
            self.hideResult()
//            self.tableView.reloadData()
            return
        }
        
        let predicate = NSPredicate(format: "userID BEGINSWITH '\(searchText)'")
        searchQuery = PFQuery(className: "_User", predicate: predicate)
        searchQuery?.limit = 10
        
        searchQuery?.findObjectsInBackgroundWithBlock({ (result, error) -> Void in
            self.searchQuery = nil
            if let result = result {
                self.searchResult = result
                let user = self.searchResult[0] as! PFUser
                let firstName = user["firstName"] as! String
                let lastName = user["lastName"] as! String
                self.nameLabel.text = firstName + " " + lastName
                if let profileImage = user["profileImage"] {
                    let imageFile = profileImage as! PFFile
                    imageFile.getDataInBackgroundWithBlock { (result, error) -> Void in
                        if let imageData = result {
                            self.profileImageView.image = UIImage(data: imageData)
                        } else {
                            AlertController.sharedInstance.showOneActionAlert("Error", body: error!.userInfo["error"] as! String, actionTitle: "Ok", viewController: self)
                        }
                    }
                } else {
                    self.profileImageView.image = UIImage(named: "AvatarPlaceholder")
                }
                self.showResult()
            } else {
                AlertController.sharedInstance.showOneActionAlert("Error", body: error!.userInfo["error"] as! String, actionTitle: "Retry", viewController: self)
            }
        })
        
    }
    
    func showResult() {
        self.profileImageView.hidden = false
        self.nameLabel.hidden = false
        self.addButton.hidden = false
    }
    
    func hideResult() {
        self.profileImageView.hidden = true
        self.nameLabel.hidden = true
        self.addButton.hidden = true
    }

}

