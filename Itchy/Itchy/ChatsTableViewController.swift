//
//  InitalTableViewController.swift
//  SwiftExample
//
//  Created by P D Leonard on 7/22/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

import UIKit
import FoldingTabBar

let cellIdentifier = "cellIdentifier"

class ChatsTableViewController: UITableViewController, YALTabBarDelegate {
    
    //MARK: - View lifecycle
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chats"
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.appDelegate.tabBarController.tabBarView.setExtraRightTabBarButtonImage(UIImage(named: "NewChatIcon"), index: 1)
        self.appDelegate.tabBarController.tabBarView.setExtraLeftTabBarButtonImage(UIImage(named: "SearchIcon"), index: 1)
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch (section) {
        case 0:
            return User.currentUser.chatRooms.count
        case 1:
            return 2
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case 0:
            let chatRoom = User.currentUser.chatRooms[indexPath.row]
            let users: [User] = chatRoom.users
            if (users.count == 2) {
                cell.textLabel?.text = users[0].firstName + " " + users[0].lastName
            } else {
                cell.textLabel?.text = chatRoom.chatRoomChannel
            }
            cell.imageView?.image = chatRoom.chatRoomImage
            cell.imageView!.layer.cornerRadius = cell.imageView!.frame.size.width / 2
            cell.imageView!.clipsToBounds = true
            break
        case 1:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Conversation between two people"
                break
            case 1:
                cell.textLabel?.text = "Group Conversation"
                break
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Settings"
                break
            default:
                break
            }
        default:
            break
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Chat Rooms"
        case 1:
            return "Examples"
        case 2:
            return "Options"
        default:
            return nil
        }
    }
    
    //Mark: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            let chatRoomViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ChatRoomViewController") as! ChatRoomViewController
//            chatRoomViewController.messages = makeNormalConversation()
            chatRoomViewController.chatRoom = User.currentUser.chatRooms[indexPath.row]
            self.navigationController?.pushViewController(chatRoomViewController, animated: true)
        case 1:
            switch indexPath.row {
            case 0:
                let chatRoomViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ChatRoomViewController") as! ChatRoomViewController
                chatRoomViewController.messages = makeNormalConversation()
                self.navigationController?.pushViewController(chatRoomViewController, animated: true)
            case 1:
                let chatView = ChatRoomViewController()
                chatView.messages = makeGroupConversation()
                let chatNavigationController = UINavigationController(rootViewController: chatView)
                presentViewController(chatNavigationController, animated: true, completion: nil)
            default:
                return
            }
        case 2:
            switch indexPath.row {
            case 0:
                self.presentViewController(UINavigationController(rootViewController: SettingsTableViewController()), animated: true, completion: nil)
            default:
                return
            }
        default:
            return
        }
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setSelected(false, animated: true)
    }
    
    func tabBarDidSelectExtraRightItem(tabBar: YALFoldingTabBar!) {
        let selectChatFriendsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SelectChatFriendsViewController") as! SelectChatFriendsViewController
        tabBar.swapExtraRightTabBarItem()
        tabBar.swapExtraLeftTabBarItem()
        self.navigationController?.pushViewController(selectChatFriendsViewController, animated: true)

    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        loadChatRooms()
        sender.endRefreshing()
    }
    
    
    func loadChatRooms() {
        AlertController.sharedInstance.startNormalActivityIndicator(self)
        User.currentUser.chatRooms.removeAll()
        let query = PFQuery(className: "ChatRoom")
        query.whereKey("channel", containsString: User.currentUser.userID)
        query.findObjectsInBackgroundWithBlock { (chatRooms, error) in
            if let chatRooms = chatRooms {
                
                if (chatRooms.isEmpty) {
                    self.tableView.reloadData()
                    AlertController.sharedInstance.stopNormalActivityIndicator()
                }
                
                for chatRoom in chatRooms {
                    let newChatRoom = ChatRoom(chatRoom: chatRoom)
                    User.currentUser.chatRooms.append(newChatRoom)
                    // get image data
                    if let chatRoomImage = chatRoom["chatRoomImage"] {
                        let imageFile = chatRoomImage as! PFFile
                        imageFile.getDataInBackgroundWithBlock { (result, error) -> Void in
                            if let imageData = result {
                                newChatRoom.chatRoomImage = UIImage(data: imageData)!
                            }
                            self.tableView.reloadData()
                        }
                    }
                    
                }
                self.tableView.reloadData()
                AlertController.sharedInstance.stopNormalActivityIndicator()
            } else {
                AlertController.sharedInstance.showOneActionAlert("Error", body: error!.userInfo["error"] as! String, actionTitle: "Retry", viewController: self)
            }
        }

        
        
    }

    

    
}
