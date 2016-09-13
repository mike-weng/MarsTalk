//
//  User.swift
//

import UIKit
import Parse


public class User {
    
    var firstName: String
    var lastName: String
    var profileImage: UIImage
    var userID: String
    var friendList: [User] = []
    var chatRooms: [ChatRoom] = []
    var pfUser: PFUser
    static var currentUser: User!
    
//    init(firstName: String, lastName: String, profileImage: UIImage, userID: String) {
//        self.firstName = firstName
//        self.lastName = lastName
//        self.userID = userID
//        self.profileImage = profileImage
//    }
//    
    init(user: PFUser) {
        self.firstName = user["firstName"] as! String
        self.lastName = user["lastName"] as! String
        self.profileImage = UIImage(named: "AvatarPlaceholder")!
        self.userID = user["userID"] as! String
        self.pfUser = user
    }

    
}