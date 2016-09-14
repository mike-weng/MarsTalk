//
//  SelectChatFriendsViewController.swift
//  MarsTalk
//
//  Created by Mike Weng on 9/5/16.
//  Copyright © 2016 Weng. All rights reserved.
//

import UIKit
import PubNub
import FoldingTabBar


class SelectChatFriendsViewController: UIViewController,  YALTabBarDelegate{
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    @IBOutlet weak var tableView: UITableView!
    var selectedUsers: [User] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = true
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        selectedUsers = []
        self.navigationItem.hidesBackButton = true
        self.appDelegate.tabBarController.tabBarView.setExtraRightTabBarButtonImage(UIImage(named: "DoneIcon"), index: 1)
        self.appDelegate.tabBarController.tabBarView.setExtraLeftTabBarButtonImage(UIImage(named: "BackIcon"), index: 1)
    }
    
    func tabBarDidSelectExtraLeftItem(tabBar: YALFoldingTabBar!) {
        tabBar.swapExtraLeftTabBarItem()
        tabBar.swapExtraRightTabBarItem()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tabBarDidSelectExtraRightItem(tabBar: YALFoldingTabBar!) {
        AlertController.sharedInstance.startNormalActivityIndicator(self)
        tabBar.swapExtraLeftTabBarItem()
        tabBar.swapExtraRightTabBarItem()
        
        if let indexPaths = tableView.indexPathsForSelectedRows {
            
            var userIDs: [String] = []
            for indexPath in indexPaths {
                let selectedFriend = User.currentUser.friendList[indexPath.row]
                userIDs.append(selectedFriend.userID)
                selectedUsers.append(selectedFriend)
            }
            userIDs.append(User.currentUser.userID)
            selectedUsers.append(User.currentUser)
            
            var channel = ""
            for id in userIDs.sort() {
                channel += id
            }
            
            let newChatRoom = ChatRoom(users: selectedUsers, chatRoomChannel: channel)
            let chatRoomViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ChatRoomViewController") as! ChatRoomViewController
            
            self.checkChatRoomExistence(newChatRoom, completionHandler: { (exists) in
                if exists {
                    chatRoomViewController.chatRoom = newChatRoom
                    self.navigationController?.popViewControllerAnimated(true)
                    self.navigationController?.pushViewController(chatRoomViewController, animated: true)
                    AlertController.sharedInstance.stopNormalActivityIndicator()
                }  else {
                    let pfChatRoom = PFObject(className: "ChatRoom")
                    pfChatRoom.setValue(channel, forKey: "channel")
                    pfChatRoom.setObject(userIDs, forKey: "userIDs")
                    if let imageData = UIImagePNGRepresentation(newChatRoom.chatRoomImage) {
                        if let file = PFFile(data: imageData) {
                            pfChatRoom.setObject(file, forKey: "chatRoomImage")
                        }
                    }
                    let usersRelation = pfChatRoom.relationForKey("users")
                    for user in self.selectedUsers {
                        usersRelation.addObject(user.pfUser)
                    }
                    
                    pfChatRoom.saveInBackgroundWithBlock { (success, error) -> Void in
                        if success {
                            let chatRoomRelation = PFUser.currentUser()!.relationForKey("chatRooms")
                            chatRoomRelation.addObject(pfChatRoom)
                            PFUser.currentUser()!.saveInBackgroundWithBlock { (success, error) -> Void in
                                if success {
//                                    User.currentUser.chatRooms.append(newChatRoom)
                                    chatRoomViewController.chatRoom = newChatRoom
//                                    self.enablePushNotification(newChatRoom)
                                    self.navigationController?.popViewControllerAnimated(true)
                                    self.navigationController?.pushViewController(chatRoomViewController, animated: true)
                                } else {
                                    AlertController.sharedInstance.showOneActionAlert("Error", body: error!.userInfo["error"] as! String, actionTitle: "Retry", viewController: self)
                                }
                            }
                        } else {
                            AlertController.sharedInstance.showOneActionAlert("Error", body: error!.userInfo["error"] as! String, actionTitle: "Retry", viewController: self)
                        }
                        AlertController.sharedInstance.stopNormalActivityIndicator()
                    }
                }

            })
            
        } else {
            AlertController.sharedInstance.showOneActionAlert("Oops", body: "You didn't select any friends", actionTitle: "Retry", viewController: self)
        }
    }
    
    func checkChatRoomExistence(chatRoom: ChatRoom, completionHandler: (exists: Bool) -> Void) {
        let searchQuery = PFQuery(className: "ChatRoom")
        searchQuery.whereKey("channel", equalTo: chatRoom.chatRoomChannel)
        searchQuery.findObjectsInBackgroundWithBlock({ (result, error) -> Void in
            if let result = result {
                if (result.isEmpty) {
                    completionHandler(exists: false)
                }
                completionHandler(exists: true)
            } else {
                AlertController.sharedInstance.showOneActionAlert("Error", body: error!.userInfo["error"] as! String, actionTitle: "Retry", viewController: self)
            }
        })
    }
    
    func enablePushNotification(chatRoom: ChatRoom) {
        let deviceToken = NSUserDefaults.standardUserDefaults().objectForKey("DeviceToken") as! NSData
        appDelegate.client!.addPushNotificationsOnChannels([chatRoom.chatRoomChannel],
                                                           withDevicePushToken: deviceToken,
                                                           andCompletion: { (status) -> Void in
                                                            
                                                            if !status.error {
                                                                // Handle successful push notification enabling on passed channels.
                                                            }
                                                            else {
                                                                
                                                                // Handle modification error. Check 'category' property
                                                                // to find out possible reason because of which request did fail.
                                                                // Review 'errorData' property (which has PNErrorData data type) of status
                                                                // object to get additional information about issue.
                                                                //
                                                                // Request can be resent using: status.retry()
                                                                let errorMsg = status.error.description
                                                                AlertController.sharedInstance.showOneActionAlert("Sent Error", body: errorMsg, actionTitle: "Retry", viewController: self)
                                                                
                                                            }
        })
    }

}

extension SelectChatFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return User.currentUser.friendList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath)
        let friend = User.currentUser.friendList[indexPath.row]
        cell.textLabel?.text = friend.firstName
        cell.detailTextLabel?.text = friend.userID
        cell.imageView!.image = friend.profileImage
        cell.imageView!.layer.cornerRadius = 10
        cell.imageView!.clipsToBounds = true
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        cell.accessoryType = .Checkmark
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        cell.accessoryType = .None
    }
    
    
    
    
}
