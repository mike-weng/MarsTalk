////
////  NSUserData + Settings.swift
////  MarsTalk
////
////  Created by Mike Weng on 8/24/16.
////  Copyright © 2016 Weng. All rights reserved.
////
//
//import Foundation
//
//
//let kSettingExtraMessages = "kSettingExtraMessages"
//let kSettingLongMessage = "kSettingLongMessage"
//let kSettingEmptyMessages = "kSettingEmptyMessages"
//let kSettingSpringiness = "kSettingSpringiness"
//let kSettingIncomingAvatar = "kSettingIncomingAvatar"
//let kSettingOutgoingAvatar = "kSettingOutgoingAvatar"
//let kSettingAccessoryButtonForMedia = "kSettingAccessoryButtonForMedia"
//extension NSUserDefaults {
//
//    class func saveExtraMessagesSetting(value: Bool) {
//        NSUserDefaults.standardUserDefaults().setBool(value, forKey: kSettingExtraMessages)
//    }
//    class func extraMessagesSetting() -> Bool {
//        return NSUserDefaults.standardUserDefaults().boolForKey(kSettingExtraMessages)
//    }
//    
//    class func saveLongMessageSetting(value: Bool) {
//        NSUserDefaults.standardUserDefaults().setBool(value, forKey: kSettingLongMessage)
//    }
//    
//    class func longMessageSetting() -> Bool {
//        return NSUserDefaults.standardUserDefaults().boolForKey(kSettingLongMessage)
//    }
//    
//    class func saveEmptyMessagesSetting(value: Bool) {
//        NSUserDefaults.standardUserDefaults().setBool(value, forKey: kSettingEmptyMessages)
//    }
//    class func emptyMessagesSetting() -> Bool {
//        return NSUserDefaults.standardUserDefaults().boolForKey(kSettingEmptyMessages)
//    }
//    
//    class func saveSpringinessSetting(value: Bool) {
//        NSUserDefaults.standardUserDefaults().setBool(value, forKey: kSettingSpringiness)
//    }
//    
//    class func springinessSetting() -> Bool {
//        return NSUserDefaults.standardUserDefaults().boolForKey(kSettingSpringiness)
//    }
//    
//    class func saveOutgoingAvatarSetting(value: Bool) {
//        NSUserDefaults.standardUserDefaults().setBool(value, forKey: kSettingOutgoingAvatar)
//    }
//    class func outgoingAvatarSetting() -> Bool {
//        return NSUserDefaults.standardUserDefaults().boolForKey(kSettingOutgoingAvatar)
//    }
//    
//    class func saveIncomingAvatarSetting(value: Bool) {
//        NSUserDefaults.standardUserDefaults().setBool(value, forKey: kSettingIncomingAvatar)
//    }
//    
//    class func incomingAvatarSetting() -> Bool {
//        return NSUserDefaults.standardUserDefaults().boolForKey(kSettingIncomingAvatar)
//    }
//    
//    class func accessoryButtonForMediaMessages() -> Bool {
//        return NSUserDefaults.standardUserDefaults().boolForKey(kSettingAccessoryButtonForMedia)
//    }
//    
//    class func saveAccessoryButtonForMediaMessages(value: Bool) {
//        NSUserDefaults.standardUserDefaults().setBool(value, forKey: kSettingAccessoryButtonForMedia)
//    }
//    
//}