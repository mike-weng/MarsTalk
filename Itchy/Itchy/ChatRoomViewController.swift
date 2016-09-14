//
//  ChatViewController.swift
//  SwiftExample
//
//  Created by Dan Leonard on 5/11/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import PubNub

class ChatRoomViewController: JSQMessagesViewController, PNObjectEventListener {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var chatRoom: ChatRoom!
    var messages = [JSQMessage]()
    let defaults = NSUserDefaults.standardUserDefaults()
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    private var displayName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ChatRoom"
        self.loadMessages()
        appDelegate.client!.addListener(self)
        appDelegate.client!.subscribeToChannels([chatRoom.chatRoomChannel], withPresence: true)
        
        if defaults.boolForKey(Setting.removeBubbleTails.rawValue) {
            // Make taillessBubbles
            incomingBubble = JSQMessagesBubbleImageFactory(bubbleImage: UIImage.jsq_bubbleCompactTaillessImage(), capInsets: UIEdgeInsetsZero, layoutDirection: UIApplication.sharedApplication().userInterfaceLayoutDirection).incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
            outgoingBubble = JSQMessagesBubbleImageFactory(bubbleImage: UIImage.jsq_bubbleCompactTaillessImage(), capInsets: UIEdgeInsetsZero, layoutDirection: UIApplication.sharedApplication().userInterfaceLayoutDirection).outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
        } else {
            // Bubbles with tails
            incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
            outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
        }
        
        /**
         *  Example on showing or removing Avatars based on user settings.
         */
        
        if defaults.boolForKey(Setting.removeAvatar.rawValue) {
            collectionView?.collectionViewLayout.incomingAvatarViewSize = .zero
            collectionView?.collectionViewLayout.outgoingAvatarViewSize = .zero
        } else {
            collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault + 5, height:kJSQMessagesCollectionViewAvatarSizeDefault + 5)
            collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault + 5, height:kJSQMessagesCollectionViewAvatarSizeDefault + 5)
        }
        
        // Show Button to simulate incoming messages
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.jsq_defaultTypingIndicatorImage(), style: .Plain, target: self, action: #selector(receiveMessagePressed))
        
        // This is a beta feature that mostly works but to make things more stable it is disabled.
        collectionView?.collectionViewLayout.springinessEnabled = false
        
        automaticallyScrollsToMostRecentMessage = true

        self.collectionView?.reloadData()
        self.collectionView?.layoutIfNeeded()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.appDelegate.tabBarController.tabBarView.hidden = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.appDelegate.tabBarController.tabBarView.hidden = false
    }
    
    func receiveMessagePressed(sender: UIBarButtonItem) {
//        handleRecievedData((self.messages.last?.text)!)
    }
    
    func handleRecievedData(fromUser: User, message: String) {
        
        /**
         *  Show the typing indicator to be shown
         */
        self.showTypingIndicator = !self.showTypingIndicator
        
        /**
         *  Scroll to actually view the indicator
         */
        self.scrollToBottomAnimated(true)
        
        /**
         *  Copy last sent message, this will be the new "received" message
         */
//        var copyMessage = self.messages.last?.copy()
        
        
        
//        if (copyMessage == nil) {
//            copyMessage = JSQMessage(senderId: user.userID, displayName: user.firstName + " " + user.lastName, text: "First received!")
//        }
        
        let newMessage:JSQMessage = JSQMessage(senderId: fromUser.userID, displayName: fromUser.firstName + " " + fromUser.lastName, text: message)
//        var newMediaData:JSQMessageMediaData!
//        var newMediaAttachmentCopy:AnyObject?
        
//        if copyMessage!.isMediaMessage() {
//            /**
//             *  Last message was a media message
//             */
//            let copyMediaData = copyMessage!.media
//            
//            switch copyMediaData {
//            case is JSQPhotoMediaItem:
//                let photoItemCopy = (copyMediaData as! JSQPhotoMediaItem).copy() as! JSQPhotoMediaItem
//                photoItemCopy.appliesMediaViewMaskAsOutgoing = false
//                
//                newMediaAttachmentCopy = UIImage(CGImage: photoItemCopy.image!.CGImage!)
//                
//                /**
//                 *  Set image to nil to simulate "downloading" the image
//                 *  and show the placeholder view5017
//                 */
//                photoItemCopy.image = nil;
//                
//                newMediaData = photoItemCopy
//            case is JSQLocationMediaItem:
//                let locationItemCopy = (copyMediaData as! JSQLocationMediaItem).copy() as! JSQLocationMediaItem
//                locationItemCopy.appliesMediaViewMaskAsOutgoing = false
//                newMediaAttachmentCopy = locationItemCopy.location!.copy()
//                
//                /**
//                 *  Set location to nil to simulate "downloading" the location data
//                 */
//                locationItemCopy.location = nil;
//                
//                newMediaData = locationItemCopy;
//            case is JSQVideoMediaItem:
//                let videoItemCopy = (copyMediaData as! JSQVideoMediaItem).copy() as! JSQVideoMediaItem
//                videoItemCopy.appliesMediaViewMaskAsOutgoing = false
//                newMediaAttachmentCopy = videoItemCopy.fileURL!.copy()
//                
//                /**
//                 *  Reset video item to simulate "downloading" the video
//                 */
//                videoItemCopy.fileURL = nil;
//                videoItemCopy.isReadyToPlay = false;
//                
//                newMediaData = videoItemCopy;
//            case is JSQAudioMediaItem:
//                let audioItemCopy = (copyMediaData as! JSQAudioMediaItem).copy() as! JSQAudioMediaItem
//                audioItemCopy.appliesMediaViewMaskAsOutgoing = false
//                newMediaAttachmentCopy = audioItemCopy.audioData!.copy()
//                
//                /**
//                 *  Reset audio item to simulate "downloading" the audio
//                 */
//                audioItemCopy.audioData = nil;
//                
//                newMediaData = audioItemCopy;
//            default:
//                assertionFailure("Error: This Media type was not recognised")
//            }
//            
//            
//            newMessage = JSQMessage(senderId: user.userID, displayName: user.firstName + " " + user.lastName, media: newMediaData)
//        } else {
//            /**
//             *  Last message was a text message
//             */
//            
//            newMessage = JSQMessage(senderId: user.userID, displayName: user.firstName + " " + user.lastName, text: copyMessage!.text)
//        }
        
        /**
         *  Upon receiving a message, you should:
         *
         *  1. Play sound (optional)
         *  2. Add new JSQMessageData object to your data source
         *  3. Call `finishReceivingMessage`
         */
        
        self.messages.append(newMessage)
        self.finishReceivingMessageAnimated(true)
        
//        if newMessage.isMediaMessage {
//            /**
//             *  Simulate "downloading" media
//             */
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
//                /**
//                 *  Media is "finished downloading", re-display visible cells
//                 *
//                 *  If media cell is not visible, the next time it is dequeued the view controller will display its new attachment data
//                 *
//                 *  Reload the specific item, or simply call `reloadData`
//                 */
//                
//                switch newMediaData {
//                case is JSQPhotoMediaItem:
//                    (newMediaData as! JSQPhotoMediaItem).image = newMediaAttachmentCopy as? UIImage
//                    self.collectionView!.reloadData()
//                case is JSQLocationMediaItem:
//                    (newMediaData as! JSQLocationMediaItem).setLocation(newMediaAttachmentCopy as? CLLocation, withCompletionHandler: {
//                        self.collectionView!.reloadData()
//                    })
//                case is JSQVideoMediaItem:
//                    (newMediaData as! JSQVideoMediaItem).fileURL = newMediaAttachmentCopy as? NSURL
//                    (newMediaData as! JSQVideoMediaItem).isReadyToPlay = true
//                    self.collectionView!.reloadData()
//                case is JSQAudioMediaItem:
//                    (newMediaData as! JSQAudioMediaItem).audioData = newMediaAttachmentCopy as? NSData
//                    self.collectionView!.reloadData()
//                default:
//                    assertionFailure("Error: This Media type was not recognised")
//                }
//            }
//        }
    }
    
    
    // MARK: JSQMessagesViewController method overrides
    override func didPressSendButton(button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: NSDate) {
        /**
         *  Sending a message. Your implementation of this method should do *at least* the following:
         *
         *  1. Play sound (optional)
         *  2. Add new id<JSQMessageData> object to your data source
         *  3. Call `finishSendingMessage`
         */
        
        
        
        
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        self.messages.append(message)
        
        
        let messageDict: NSDictionary? = [
            "message_text" : text,
            "user_id" : User.currentUser.userID
        ]
        
        let alertMsg = "message from " + User.currentUser.firstName + " " + User.currentUser.lastName
        let payload = ["aps" : ["alert" : alertMsg]]
        appDelegate.client!.publish(messageDict, toChannel: chatRoom.chatRoomChannel, mobilePushPayload: payload, storeInHistory: true, compressed: false, withCompletion: { (status) -> Void in
            if !status.error {
                // Message successfully published to specified channel.

            } else {
                
                // Handle message publish error. Check 'category' property
                // to find out possible reason because of which request did fail.
                // Review 'errorData' property (which has PNErrorData data type) of status
                // object to get additional information about issue.
                //
                // Request can be resent using: status.retry()
                let errorMsg = status.error.description
                AlertController.sharedInstance.showOneActionAlert("Sent Error", body: errorMsg, actionTitle: "Retry", viewController: self)
            }
            
        })
        self.finishSendingMessageAnimated(true)
    }
    
        
    func client(client: PubNub, didReceiveMessage message: PNMessageResult) {
        
        // Handle new message stored in message.data.message
        if message.data.actualChannel != nil {
            // Message has been received on channel group stored in
            // message.data.subscribedChannel
            
        } else {
            
            // Message has been received on channel stored in
            // message.data.subscribedChannel
        }
        let messageDict = message.data.message as! NSDictionary
        let text = messageDict["message_text"] as! String
        let senderID = messageDict["user_id"] as! String
        if senderID == User.currentUser.userID {
            return
        }
        var sender: User!
        for user in User.currentUser.friendList {
            if senderID == user.userID {
                sender = user
                break
            }
        }
        self.handleRecievedData(sender, message: text)
//        print("Received message: \(message.data.message) on channel " +
//            "\((message.data.actualChannel ?? message.data.subscribedChannel)!) at " +
//            "\(message.data.timetoken)")
        
    }
    
    override func didPressAccessoryButton(sender: UIButton) {
        self.inputToolbar.contentView!.textView!.resignFirstResponder()
        
        let sheet = UIAlertController(title: "Media messages", message: nil, preferredStyle: .ActionSheet)
        
        let photoAction = UIAlertAction(title: "Send photo", style: .Default) { (action) in
            /**
             *  Create fake photo
             */
            let photoItem = JSQPhotoMediaItem(image: UIImage(named: "goldengate"))
            self.addMedia(photoItem)
        }
        
        let locationAction = UIAlertAction(title: "Send location", style: .Default) { (action) in
            /**
             *  Add fake location
             */
            let locationItem = self.buildLocationItem()
            
            self.addMedia(locationItem)
        }
        
        let videoAction = UIAlertAction(title: "Send video", style: .Default) { (action) in
            /**
             *  Add fake video
             */
            let videoItem = self.buildVideoItem()
            
            self.addMedia(videoItem)
        }
        
        let audioAction = UIAlertAction(title: "Send audio", style: .Default) { (action) in
            /**
             *  Add fake audio
             */
            let audioItem = self.buildAudioItem()
            
            self.addMedia(audioItem)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        sheet.addAction(photoAction)
        sheet.addAction(locationAction)
        sheet.addAction(videoAction)
        sheet.addAction(audioAction)
        sheet.addAction(cancelAction)
        
        self.presentViewController(sheet, animated: true, completion: nil)
    }
    
    func buildVideoItem() -> JSQVideoMediaItem {
        let videoURL = NSURL(fileURLWithPath: "file://")
        
        let videoItem = JSQVideoMediaItem(fileURL: videoURL, isReadyToPlay: true)
        
        return videoItem
    }
    
    func buildAudioItem() -> JSQAudioMediaItem {
        let sample = NSBundle.mainBundle().pathForResource("jsq_messages_sample", ofType: "m4a")
        let audioData = NSData(contentsOfFile: sample!)
        
        let audioItem = JSQAudioMediaItem(data: audioData)
        
        return audioItem
    }
    
    func buildLocationItem() -> JSQLocationMediaItem {
        let ferryBuildingInSF = CLLocation(latitude: 37.795313, longitude: -122.393757)
        
        let locationItem = JSQLocationMediaItem()
        locationItem.setLocation(ferryBuildingInSF) {
            self.collectionView!.reloadData()
        }
        
        return locationItem
    }
    
    func addMedia(media:JSQMediaItem) {
        let message = JSQMessage(senderId: self.senderId(), displayName: self.senderDisplayName(), media: media)
        self.messages.append(message)
        
        //Optional: play sent sound
        
        self.finishSendingMessageAnimated(true)
    }
    
    
    //MARK: JSQMessages CollectionView DataSource
    
    override func senderId() -> String {
        return User.currentUser.userID
    }
    
    override func senderDisplayName() -> String {
        return User.currentUser.firstName
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, messageDataForItemAtIndexPath indexPath: NSIndexPath) -> JSQMessageData {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath) -> JSQMessageBubbleImageDataSource {
        
        return messages[indexPath.item].senderId == self.senderId() ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath) -> JSQMessageAvatarImageDataSource? {
        let message = messages[indexPath.item]
        return self.getAvatarImage(message.senderId)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString? {
        /**
         *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
         *  The other label text delegate methods should follow a similar pattern.
         *
         *  Show a timestamp for every 3rd message
         */
        if (indexPath.item % 3 == 0) {
            let message = self.messages[indexPath.item]
            
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
        }
        
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString? {
        let message = messages[indexPath.item]
        
        // Displaying names above messages
        //Mark: Removing Sender Display Name
        /**
         *  Example on showing or removing senderDisplayName based on user settings.
         *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
         */
        if defaults.boolForKey(Setting.removeSenderDisplayName.rawValue) {
            return nil
        }
        
        if message.senderId == self.senderId() {
            return nil
        }

        return NSAttributedString(string: message.senderDisplayName)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        /**
         *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
         */
        
        /**
         *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
         *  The other label height delegate methods should follow similarly
         *
         *  Show a timestamp for every 3rd message
         */
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        return 0.0
    }

    override func collectionView(collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        /**
         *  Example on showing or removing senderDisplayName based on user settings.
         *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
         */
        if defaults.boolForKey(Setting.removeSenderDisplayName.rawValue) {
            return 0.0
        }
        
        /**
         *  iOS7-style sender name labels
         */
        let currentMessage = self.messages[indexPath.item]
        
        if currentMessage.senderId == self.senderId() {
            return 0.0
        }
        
        if indexPath.item - 1 > 0 {
            let previousMessage = self.messages[indexPath.item - 1]
            if previousMessage.senderId == currentMessage.senderId {
                return 0.0
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    func getAvatarImage(id: String) -> JSQMessagesAvatarImage{
        for user in chatRoom.users {
            if (user.userID == id) {
                let avatar = JSQMessagesAvatarImageFactory().avatarImageWithPlaceholder(user.profileImage)
                return avatar
            }
        }
        return JSQMessagesAvatarImageFactory().avatarImageWithPlaceholder(UIImage(named: "AvatarPlaceholder")!)
    }
    
    func loadMessages() {
        appDelegate.client?.historyForChannel(chatRoom.chatRoomChannel, start: nil, end: nil, limit: 100, reverse: false, includeTimeToken: true, withCompletion: { (result, status) -> Void in
            if status == nil {
                for messageDict in result!.data.messages {
                    let messageDict = messageDict as! NSDictionary
                    if let messagePayload = messageDict["message"] as? NSDictionary {
                        let text = messagePayload["message_text"] as! String
                        let senderID = messagePayload["user_id"] as! String
                        var sender: User!
                        for user in self.chatRoom.users {
                            print(user.userID)
                            print(senderID)

                            if senderID == user.userID {
                                sender = user
                                break
                            }
                        }
                        let newMessage:JSQMessage = JSQMessage(senderId: sender.userID, displayName: sender.firstName + " " + sender.lastName, text: text)
                        self.messages.append(newMessage)
                    }
                }
                self.collectionView!.reloadData()
                // Handle downloaded history using:
                //   result.data.start - oldest message time stamp in response
                //   result.data.end - newest message time stamp in response
                //   result.data.messages - list of messages
            }
            else {
                
                // Handle message history download error. Check 'category' property
                // to find out possible reason because of which request did fail.
                // Review 'errorData' property (which has PNErrorData data type) of status
                // object to get additional information about issue.
                //
                // Request can be resent using: status.retry()
                AlertController.sharedInstance.showOneActionAlert("Sent Error", body: (status?.errorData.information)!, actionTitle: "Retry", viewController: self)
            }
        })
    }

}
