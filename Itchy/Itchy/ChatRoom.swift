//
//  ChatRoom.swift
//  MarsTalk
//
//  Created by Mike Weng on 9/11/16.
//  Copyright © 2016 Weng. All rights reserved.
//

import UIKit
import Parse


public class ChatRoom {
    
    var users: [User] = []
    var chatRoomImage: UIImage
    var chatRoomChannel: String
    
    init(users: [User], chatRoomChannel: String) {
        self.users = users
        self.chatRoomChannel = chatRoomChannel
        if (users.count == 2) {
            chatRoomImage = users[0].profileImage
        } else {
            chatRoomImage = UIImage(named: "AvatarPlaceholder")!
        }
    }
    
    init(chatRoom: PFObject) {
        chatRoomChannel = chatRoom.objectForKey("channel") as! String
        let userIDs = chatRoom.objectForKey("userIDs") as! [String]
        for id in userIDs {
            for friend in User.currentUser.friendList {
                if (id == friend.userID) {
                    users.append(friend)
                    break
                }
            }
        }
        self.chatRoomImage = UIImage(named: "AvatarPlaceholder")!
    }
    
    public func chatExistsIn(chatRooms: [ChatRoom]) -> Bool {
        for chatRoom in chatRooms {
            if chatRoom.chatRoomChannel == self.chatRoomChannel {
                return true
            }
        }
        return false
    }
    
}
