////
////  DemoModelData.swift
////  MarsTalk
////
////  Created by Mike Weng on 8/24/16.
////  Copyright © 2016 Weng. All rights reserved.
////
//
//import Foundation
//import UIKit
//import CoreLocation
//import JSQMessagesViewController
//
//let kJSQDemoAvatarDisplayNameSquires = "Jesse Squires"
//let kJSQDemoAvatarDisplayNameCook = "Tim Cook"
//let kJSQDemoAvatarDisplayNameJobs = "Jobs"
//let kJSQDemoAvatarDisplayNameWoz = "Steve Wozniak"
//let kJSQDemoAvatarIdSquires = "053496-4509-289"
//let kJSQDemoAvatarIdCook = "468-768355-23123"
//let kJSQDemoAvatarIdJobs = "707-8956784-57"
//let kJSQDemoAvatarIdWoz = "309-41802-93823"
//
//class DemoModelData: NSObject {
//    var messages = [AnyObject]()
//    var avatars = [NSObject : AnyObject]()
//    var outgoingBubbleImageData: JSQMessagesBubbleImage!
//    var incomingBubbleImageData: JSQMessagesBubbleImage!
//    var users = [NSObject : AnyObject]()
//
//    override init() {
//        super.init()
//        if (self) {
//            if NSUserDefaults.emptyMessagesSetting() {
//                self.messages = [AnyObject]()
//            }
//            else {
//                self.loadFakeMessages()
//            }
//            /**
//             *  Create avatar images once.
//             *
//             *  Be sure to create your avatars one time and reuse them for good performance.
//             *
//             *  If you are not using avatars, ignore this.
//             */
//            var avatarFactory = JSQMessagesAvatarImageFactory()
//            var jsqImage = avatarFactory.avatarImageWithUserInitials("JSQ", backgroundColor: UIColor(white: 0.85, alpha: 1.0), textColor: UIColor(white: 0.60, alpha: 1.0), font: UIFont.systemFontOfSize(14.0))
//            var cookImage = avatarFactory.avatarImageWithImage(UIImage(named: "demo_avatar_cook")!)
//            var jobsImage = avatarFactory.avatarImageWithImage(UIImage(named: "demo_avatar_jobs")!)
//            var wozImage = avatarFactory.avatarImageWithImage(UIImage(named: "demo_avatar_woz")!)
//            self.avatars = [kJSQDemoAvatarIdSquires: jsqImage, kJSQDemoAvatarIdCook: cookImage, kJSQDemoAvatarIdJobs: jobsImage, kJSQDemoAvatarIdWoz: wozImage]
//            self.users = [kJSQDemoAvatarIdJobs: kJSQDemoAvatarDisplayNameJobs, kJSQDemoAvatarIdCook: kJSQDemoAvatarDisplayNameCook, kJSQDemoAvatarIdWoz: kJSQDemoAvatarDisplayNameWoz, kJSQDemoAvatarIdSquires: kJSQDemoAvatarDisplayNameSquires]
//            /**
//             *  Create message bubble images objects.
//             *
//             *  Be sure to create your bubble images one time and reuse them for good performance.
//             *
//             */
//            var bubbleFactory = JSQMessagesBubbleImageFactory()
//            self.outgoingBubbleImageData = bubbleFactory!.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
//            self.incomingBubbleImageData = bubbleFactory!.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
//        }
//        return self
//    }
//
//    func loadFakeMessages() {
//        /**
//         *  Load some fake messages for demo.
//         *
//         *  You should have a mutable array or orderedSet, or something.
//         */
//        self.messages = [JSQMessage(senderId: kJSQDemoAvatarIdSquires, senderDisplayName: kJSQDemoAvatarDisplayNameSquires, date: NSDate.distantPast(), text: NSLocalizedString("Welcome to JSQMessages: A messaging UI framework for iOS.")), JSQMessage(senderId: kJSQDemoAvatarIdWoz, senderDisplayName: kJSQDemoAvatarDisplayNameWoz, date: NSDate.distantPast(), text: NSLocalizedString("It is simple, elegant, and easy to use. There are super sweet default settings, but you can customize like crazy.")), JSQMessage(senderId: kJSQDemoAvatarIdSquires, senderDisplayName: kJSQDemoAvatarDisplayNameSquires, date: NSDate.distantPast(), text: NSLocalizedString("It even has data detectors. You can call me tonight. My cell number is 123-456-7890. My website is www.hexedbits.com.")), JSQMessage(senderId: kJSQDemoAvatarIdJobs, senderDisplayName: kJSQDemoAvatarDisplayNameJobs, date: NSDate(), text: NSLocalizedString("JSQMessagesViewController is nearly an exact replica of the iOS Messages App. And perhaps, better.")), JSQMessage(senderId: kJSQDemoAvatarIdCook, senderDisplayName: kJSQDemoAvatarDisplayNameCook, date: NSDate(), text: NSLocalizedString("It is unit-tested, free, open-source, and documented.")), JSQMessage(senderId: kJSQDemoAvatarIdSquires, senderDisplayName: kJSQDemoAvatarDisplayNameSquires, date: NSDate(), text: NSLocalizedString("Now with media messages!"))]
//        self.addPhotoMediaMessage()
//        self.addAudioMediaMessage()
//        /**
//         *  Setting to load extra messages for testing/demo
//         */
//        if NSUserDefaults.extraMessagesSetting() {
//            var copyOfMessages = self.messages
//            for i in 0..<4 {
//                self.messages.addObjectsFromArray(copyOfMessages)
//            }
//        }
//        /**
//         *  Setting to load REALLY long message for testing/demo
//         *  You should see "END" twice
//         */
//        if NSUserDefaults.longMessageSetting() {
//            var reallyLongMessage = JSQMessage.messageWithSenderId(kJSQDemoAvatarIdSquires, displayName: kJSQDemoAvatarDisplayNameSquires, text: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? END Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? END")
//            self.messages.append(reallyLongMessage!)
//        }
//    }
//    
//    // The output below is limited by 1 KB.
//    // Please Sign Up (Free!) to remove this limitation.
//    
//    
//    func addAudioMediaMessage() {
//        let sample = NSBundle.mainBundle().pathForResource("jsq_messages_sample", ofType: "m4a")!
//        let audioData = NSData(contentsOfFile: sample)!
//        let audioItem = JSQAudioMediaItem(data: audioData)
//        let audioMessage = JSQMessage.messageWithSenderId(kJSQDemoAvatarIdSquires, displayName: kJSQDemoAvatarDisplayNameSquires, media: audioItem)
//        self.messages.append(audioMessage!)
//    }
//    
//    func addPhotoMediaMessage() {
//        let photoItem = JSQPhotoMediaItem(image: UIImage(named: "goldengate")!)
//        let photoMessage = JSQMessage.messageWithSenderId(kJSQDemoAvatarIdSquires, displayName: kJSQDemoAvatarDisplayNameSquires, media: photoItem!)
//        self.messages.append(photoMessage!)
//    }
//    
//    func addLocationMediaMessageCompletion(completion: JSQLocationMediaItemCompletionBlock) {
//        let ferryBuildingInSF = CLLocation(latitude: 37.795313, longitude: -122.393757)
//        let locationItem = JSQLocationMediaItem()
//        locationItem.setLocation(ferryBuildingInSF, withCompletionHandler: completion)
//        let locationMessage = JSQMessage.messageWithSenderId(kJSQDemoAvatarIdSquires, displayName: kJSQDemoAvatarDisplayNameSquires, media: locationItem)
//        self.messages.append(locationMessage!)
//    }
//    
//    func addVideoMediaMessage() {
//        // don't have a real video, just pretending
//        let videoURL = NSURL(string: "file://")!
//        let videoItem = JSQVideoMediaItem(fileURL: videoURL, isReadyToPlay: true)
//        let videoMessage = JSQMessage.messageWithSenderId(kJSQDemoAvatarIdSquires, displayName: kJSQDemoAvatarDisplayNameSquires, media: videoItem!)
//        self.messages.append(videoMessage!)
//    }
//}