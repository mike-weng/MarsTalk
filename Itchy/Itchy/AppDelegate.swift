//
//  AppDelegate.swift
//  Itchy
//
//  Created by Mike Weng on 6/28/16.
//  Copyright © 2016 Weng. All rights reserved.
//

import UIKit
import PubNub
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4
import FoldingTabBar

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PNObjectEventListener {

    var window: UIWindow?
    var client: PubNub?         //PubNub instance
    var tabBarController: YALFoldingTabBarController!
    
    override init() {
        // Instantiate configuration instance.
        let configuration = PNConfiguration(publishKey: "pub-c-b20b112c-2a5a-488f-bf91-784c62da1988", subscribeKey: "sub-c-c1e2a8f8-3d2b-11e6-ba28-02ee2ddab7fe")
        // Instantiate PubNub client.
        client = PubNub.clientWithConfiguration(configuration)
        
        super.init()
//        client?.addListener(self)
    }
    
//    // Handle new message from one of channels on which client has been subscribed.
//    func client(client: PubNub, didReceiveMessage message: PNMessageResult) {
//        
//        // Handle new message stored in message.data.message
//        if message.data.actualChannel != nil {
//            
//            // Message has been received on channel group stored in
//            // message.data.subscribedChannel
//        }
//        else {
//            
//            // Message has been received on channel stored in
//            // message.data.subscribedChannel
//        }
//        
//        print("Received message: \(message.data.message) on channel " +
//            "\((message.data.actualChannel ?? message.data.subscribedChannel)!) at " +
//            "\(message.data.timetoken)")
//    }
//    
//    // New presence event handling.
//    func client(client: PubNub, didReceivePresenceEvent event: PNPresenceEventResult) {
//        
//        // Handle presence event event.data.presenceEvent (one of: join, leave, timeout,
//        // state-change).
//        if event.data.actualChannel != nil {
//            
//            // Presence event has been received on channel group stored in
//            // event.data.subscribedChannel
//        }
//        else {
//            
//            // Presence event has been received on channel stored in
//            // event.data.subscribedChannel
//        }
//        
//        if event.data.presenceEvent != "state-change" {
//            
//            print("\(event.data.presence.uuid) \"\(event.data.presenceEvent)'ed\"\n" +
//                "at: \(event.data.presence.timetoken) " +
//                "on \((event.data.actualChannel ?? event.data.subscribedChannel)!) " +
//                "(Occupancy: \(event.data.presence.occupancy))");
//        }
//        else {
//            
//            print("\(event.data.presence.uuid) changed state at: " +
//                "\(event.data.presence.timetoken) " +
//                "on \((event.data.actualChannel ?? event.data.subscribedChannel)!) to:\n" +
//                "\(event.data.presence.state)");
//        }
//    }
//    
//    
//    // Handle subscription status change.
//    func client(client: PubNub, didReceiveStatus status: PNStatus) {
//        if status.category == .PNUnexpectedDisconnectCategory {
//            
//            // This event happens when radio / connectivity is lost
//        }
//        else if status.category == .PNConnectedCategory {
//            
//            // Connect event. You can do stuff like publish, and know you'll get it.
//            // Or just use the connected event to confirm you are subscribed for
//            // UI / internal notifications, etc
//            
//            // Select last object from list of channels and send message to it.
////            let targetChannel = client.channels().last!
////            client.publish("Hello from the PubNub Swift SDK", toChannel: targetChannel,
////                compressed: false, withCompletion: { (status) -> Void in
////                    
////                    if !status.error {
////                        
////                        // Message successfully published to specified channel.
////                    }
////                    else{
////                        
////                        // Handle message publish error. Check 'category' property
////                        // to find out possible reason because of which request did fail.
////                        // Review 'errorData' property (which has PNErrorData data type) of status
////                        // object to get additional information about issue.
////                        //
////                        // Request can be resent using: status.retry()
////                    }
////            })
//        }
//        else if status.category == .PNReconnectedCategory {
//            
//            // Happens as part of our regular operation. This event happens when
//            // radio / connectivity is lost, then regained.
//        }
//        else if status.category == .PNDecryptionErrorCategory {
//            
//            // Handle messsage decryption error. Probably client configured to
//            // encrypt messages and on live data feed it received plain text.
//        }
//    }
//    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        PFUser.enableAutomaticUser()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        application.statusBarHidden = false
        application.statusBarStyle = .LightContent

        
        // Subscribe to present channel
        self.client?.subscribeToChannels(["my_channel"], withPresence: true)

        // Enable storing and querying data from Local Datastore.
        // Remove this line if you don't want to use Local Datastore features or want to use cachePolicy.
        Parse.enableLocalDatastore()
        
        // ****************************************************************************
        // Uncomment and fill in with your Parse credentials:
        Parse.setApplicationId("Pg9iY7d1QZRVNfoXTSPZzaeLhyrh8DuJ5vlus59a", clientKey: "87GB4bWIwZPBjq8BLplbHTEOGHgGN95qv1lrP5nu")
        
        // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
        // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
        // Uncomment the line inside ParseStartProject-Bridging-Header and the following line here:
        // ****************************************************************************
        
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        let defaultACL = PFACL();
        
        // If you would like all objects to be private by default, remove this line.
        defaultACL.publicReadAccess = true
        
        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser: true)
        
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector(Selector("backgroundRefreshStatus"))
            let oldPushHandlerOnly = !self.respondsToSelector(#selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)))
            var noPushPayload = false;
            if let options = launchOptions {
                noPushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil;
            }
            if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        
        //  Swift 2.0
        let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
        let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()

//        if #available(iOS 8.0, *) {
//            
//        } else {
//            let types: UIRemoteNotificationType = [.Alert, .Badge, .Sound]
//            application.registerForRemoteNotificationTypes(types)
//        }

        return true
    }

    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Sometimes it’s useful to store the device token in NSUserDefaults
        NSUserDefaults.standardUserDefaults().setObject(deviceToken, forKey: "DeviceToken")
        print(NSUserDefaults.standardUserDefaults().objectForKey("DeviceToken"))
        
        let installation = PFInstallation.currentInstallation()
        installation!.setDeviceTokenFromData(deviceToken)
        installation!.saveInBackground()
        
        
        PFPush.subscribeToChannelInBackground("") { (succeeded: Bool, error: NSError?) in
            if succeeded {
                print("MarsTalk successfully subscribed to push notifications on the broadcast channel.\n");
            } else {
                print("MarsTalk failed to subscribe to push notifications on the broadcast channel with error = %@.\n", error)
            }
        }
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.\n")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@\n", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        let currentInstallation = PFInstallation.currentInstallation()!
        if (currentInstallation.badge != 0) {
            currentInstallation.badge = 0;
            currentInstallation.saveEventually()
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    ///////////////////////////////////////////////////////////
    // Uncomment this method if you want to use Push Notifications with Background App Refresh
    ///////////////////////////////////////////////////////////
     func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
         if application.applicationState == UIApplicationState.Inactive {
             PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
         }
     }
    
    //--------------------------------------
    // MARK: Facebook SDK Integration
    //--------------------------------------
    
    ///////////////////////////////////////////////////////////
    // Uncomment this method if you are using Facebook
    ///////////////////////////////////////////////////////////
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }


}

