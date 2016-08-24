////
////  ChatsViewController.swift
////  MarsTalk
////
////  Created by Mike Weng on 7/22/16.
////  Copyright © 2016 Weng. All rights reserved.
////
//
//import UIKit
//import JSQMessagesViewController
//
//
//
//class ChatsViewController: JSQMessagesViewController, JSQMessagesComposerTextViewPasteDelegate {
//    
//    var demoData: DemoModelData!
//
//
//////    var keyboardController: KeybvnoardController!
////    override func viewDidLoad() {
////        super.viewDidLoad()
//////        keyboardController = KeyboardController(viewController: self)
////    }
////    
////    override func viewWillAppear(animated: Bool) {
////        super.viewWillAppear(animated)
//////        keyboardController.registerTapToHideKeyboard()
////        
////    }
////    override func viewWillDisappear(animated: Bool) {
////        super.viewWillDisappear(animated)
//////        keyboardController.unregisterTapToHideKeyboard()
////    }
////
////    override func didReceiveMemoryWarning() {
////        super.didReceiveMemoryWarning()
////        // Dispose of any resources that can be recreated.
////    }
////    
//    /**
//     *  Override point for customization.
//     *
//     *  Customize your view.
//     *  Look at the properties on `JSQMessagesViewController` and `JSQMessagesCollectionView` to see what is possible.
//     *
//     *  Customize your layout.
//     *  Look at the properties on `JSQMessagesCollectionViewFlowLayout` to see what is possible.
//     */
////    protocol JSQDemoViewControllerDelegate: NSObject {
////        func didDismissJSQDemoViewController(vc: DemoMessagesViewController)
////    }
////    var delegateModal: JSQDemoViewControllerDelegate
////    var demoData: DemoModelData
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.title = "JSQMessages"
//        self.inputToolbar.contentView.textView.pasteDelegate = self
//        
//        /**
//         *  Load up our fake data for the demo
//         */
//        self.demoData = DemoModelData()
//        /**
//         *  Set up message accessory button delegate and configuration
//         */
//        self.collectionView.accessoryDelegate = self
//        /**
//         *  You can set custom avatar sizes
//         */
//        if !NSUserDefaults.incomingAvatarSetting() {
//        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
//        }
//        if !NSUserDefaults.outgoingAvatarSetting() {
//        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
//        }
//        self.showLoadEarlierMessagesHeader = true
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.jsq_defaultTypingIndicatorImage(), style: .Bordered, target: self, action: #selector(self.receiveMessagePressed))
//        /**
//         *  Register custom menu actions for cells.
//         */
//        JSQMessagesCollectionViewCell.registerMenuAction(#selector(self.customAction))
//        /**
//         *  OPT-IN: allow cells to be deleted
//         */
//        JSQMessagesCollectionViewCell.registerMenuAction(#selector(self.delete))
//        /**
//         *  Customize your toolbar buttons
//         *
//         *  self.inputToolbar.contentView.leftBarButtonItem = custom button or nil to remove
//         *  self.inputToolbar.contentView.rightBarButtonItem = custom button or nil to remove
//         */
//        /**
//         *  Set a maximum height for the input toolbar
//         *
//         *  self.inputToolbar.maximumHeight = 150;
//         */
//        /**
//         *  Customize your toolbar buttons
//         *
//         *  self.inputToolbar.contentView.leftBarButtonItem = custom button or nil to remove
//         *  self.inputToolbar.contentView.rightBarButtonItem = custom button or nil to remove
//         */
//        /**
//         *  Set a maximum height for the input toolbar
//         *
//         *  self.inputToolbar.maximumHeight = 150;
//         */
//    }
//    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        if self.delegateModal {
//            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: #selector(self.closePressed))
//        }
//    }
//    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        /**
//         *  Enable/disable springy bubbles, default is NO.
//         *  You must set this from `viewDidAppear:`
//         *  Note: this feature is mostly stable, but still experimental
//         */
//        self.collectionView.collectionViewLayout.springinessEnabled = NSUserDefaults.springinessSetting()
//        
//    }
//    
//    // MARK: - Custom menu actions for cells
//    
//    
//    override func didReceiveMenuWillShowNotification(notification: NSNotification) {
//        /**
//         *  Display custom menu actions for cells.
//         */
//        let menu: UIMenuController = notification.object
//        menu.menuItems = [UIMenuItem(title: "Custom Action", action: #selector(self.customAction))]
//        super.didReceiveMenuWillShowNotification(notification)
//    }
//    
//    // MARK: - Testing
//    
//    
//    func pushMainViewController() {
//        let sb: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let nc: UINavigationController = sb.instantiateInitialViewController()
//        self.navigationController!.pushViewController(nc.topViewController!, animated: true)
//    }
//    // MARK: - Actions
//    
//    
//    func receiveMessagePressed(sender: UIBarButtonItem) {
//        /**
//         *  DEMO ONLY
//         *
//         *  The following is simply to simulate received messages for the demo.
//         *  Do not actually do this.
//         */
//        /**
//         *  Show the typing indicator to be shown
//         */
//        self.showTypingIndicator = !self.showTypingIndicator
//        /**
//         *  Scroll to actually view the indicator
//         */
//        self.scrollToBottomAnimated(true)
//        /**
//         *  Copy last sent message, this will be the new "received" message
//         */
//        var copyMessage: JSQMessage = self.demoData.messages.last!
//        if !copyMessage {
//            copyMessage = JSQMessage.messageWithSenderId(kJSQDemoAvatarIdJobs, displayName: kJSQDemoAvatarDisplayNameJobs, text: "First received!")
//        }
//        // The output below is limited by 1 KB.
//        // Please Sign Up (Free!) to remove this limitation.
//        
//        /**
//         *  Allow typing indicator to show
//         */
//        dispatch_time(DISPATCH_TIME_NOW, Int64(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue()
//        do {
//            var userIds: [AnyObject] = self.demoData.users.allKeys()
//            userIds.removeAtIndex(userIds.indexOf(self.senderId))
//            var randomUserId: String = userIds[arc4random_uniform(Int(userIds.count))]
//            var newMessage: JSQMessage? = nil
//            var newMediaData: JSQMessageMediaData? = nil
//            var newMediaAttachmentCopy: AnyObject? = nil
//            if copyMessage.isMediaMessage {
//                /**
//                 *  Last message was a media message
//                 */
//                var copyMediaData: JSQMessageMediaData = copyMessage.media
//                if (copyMediaData is JSQPhotoMediaItem) {
//                    var photoItemCopy: JSQPhotoMediaItem = (copyMediaData as! JSQPhotoMediaItem)
//                    photoItemCopy.appliesMediaViewMaskAsOutgoing = false
//                    newMediaAttachmentCopy = UIImage.imageWithCGImage(photoItemCopy.image.CGImage!)
//                    /**
//                     *  Set image to nil to simulate "downloading" the image
//                     *  and show the placeholder view
//                     */
//                    photoItemCopy.image = nil;
//                    
//                    newMediaData = photoItemCopy;
//                } else if (copyMediaData is JSQLocationMediaItem) {
//                    var locationItemCopy: JSQLocationMediaItem = (copyMediaData as! JSQLocationMediaItem)
//                    locationItemCopy.appliesMediaViewMaskAsOutgoing = false
//                    newMediaAttachmentCopy = locationItemCopy.location
//                    /**
//                     *  Set location to nil to simulate "downloading" the location data
//                     */
//                    locationItemCopy.location = nil
//                    newMediaData = locationItemCopy
//                } else if (copyMediaData is JSQVideoMediaItem) {
//                    var videoItemCopy: JSQVideoMediaItem = (copyMediaData as! JSQVideoMediaItem)
//                    videoItemCopy.appliesMediaViewMaskAsOutgoing = false
//                    newMediaAttachmentCopy = videoItemCopy.fileURL
//                    /**
//                     *  Reset video item to simulate "downloading" the video
//                     */
//                    videoItemCopy.fileURL = nil
//                    videoItemCopy.isReadyToPlay = false
//                    newMediaData = videoItemCopy
//                } else if (copyMediaData is JSQAudioMediaItem) {
//                    var audioItemCopy: JSQAudioMediaItem = (copyMediaData as! JSQAudioMediaItem)
//                    audioItemCopy.appliesMediaViewMaskAsOutgoing = false
//                    newMediaAttachmentCopy = audioItemCopy.audioData
//                    /**
//                     *  Reset audio item to simulate "downloading" the audio
//                     */
//                    audioItemCopy.audioData = nil
//                    newMediaData = audioItemCopy
//                } else {
//                    print("error: unrecognized media item")
//
//                }
//                newMessage = JSQMessage.messageWithSenderId(randomUserId, displayName: self.demoData.users[randomUserId], media: newMediaData!)
//            } else {
//                /**
//                 *  Last message was a text message
//                 */
//                newMessage = JSQMessage.messageWithSenderId(randomUserId, displayName: self.demoData.users[randomUserId], text: copyMessage.text!)
//
//            }
//            /**
//             *  Upon receiving a message, you should:
//             *
//             *  1. Play sound (optional)
//             *  2. Add new id<JSQMessageData> object to your data source
//             *  3. Call `finishReceivingMessage`
//             */
//            // [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
//            self.demoData.messages.append(newMessage!)
//            self.finishReceivingMessageAnimated(true)
//            if newMessage!.isMediaMessage {
//                /**
//                 *  Simulate "downloading" media
//                 */
//                dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC))
//            }
//            
//            if (newMediaData! is JSQPhotoMediaItem) {
//                (newMediaData as! JSQPhotoMediaItem).image = newMediaAttachmentCopy! as! UIImage
//                self.collectionView.reloadData()
//            }
//            else if (newMediaData! is JSQLocationMediaItem) {
//                (newMediaData as! JSQLocationMediaItem).setLocation(newMediaAttachmentCopy! as! CLLocation, withCompletionHandler: {() -> Void in
//                    self.collectionView.reloadData()
//                })
//            }
//            else if (newMediaData! is JSQVideoMediaItem) {
//                (newMediaData as! JSQVideoMediaItem).fileURL = newMediaAttachmentCopy! as! NSURL
//                (newMediaData as! JSQVideoMediaItem).isReadyToPlay = true
//                self.collectionView.reloadData()
//            }
//            else if (newMediaData! is JSQAudioMediaItem) {
//                (newMediaData as! JSQAudioMediaItem).audioData = newMediaAttachmentCopy! as! NSData
//                self.collectionView.reloadData()
//            }
//            else {
//                print("error: unrecognized media item")
//            }
//        }
//    }
//    func closePressed(sender: UIBarButtonItem) {
//        self.delegateModal.didDismissJSQDemoViewController(self)
//    }
//    
//    // MARK: - JSQMessagesViewController method overrides
//    
//    
//    override func didPressSendButton(button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: NSDate) {
//        /**
//         *  Sending a message. Your implementation of this method should do *at least* the following:
//         *
//         *  1. Play sound (optional)
//         *  2. Add new id<JSQMessageData> object to your data source
//         *  3. Call `finishSendingMessage`
//         */
//        // [JSQSystemSoundPlayer jsq_playMessageSentSound];
//        var message: JSQMessage = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
//        self.demoData.messages.append(message)
//        self.finishSendingMessageAnimated(true)
//    }
//    override func didPressAccessoryButton(sender: UIButton) {
//        self.inputToolbar.contentView.textView.resignFirstResponder()
//        var sheet: UIActionSheet = UIActionSheet(title: NSLocalizedString("Media messages"), delegate: self, cancelButtonTitle: NSLocalizedString("Cancel"), destructiveButtonTitle: nil, otherButtonTitles: NSLocalizedString("Send photo", String)
//        
//        var sheet: UIActionSheet = UIActionSheet(title: NSLocalizedString("Media messages"), delegate: self, cancelButtonTitle: NSLocalizedString("Cancel"), destructiveButtonTitle: nil, otherButtonTitles: NSLocalizedString("Send photo"), NSLocalizedString("Send location"), NSLocalizedString("Send video"), NSLocalizedString("Send audio"), nil)
//        sheet.showFromToolbar(self.inputToolbar)
//    }
//    
//    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
//        if buttonIndex == actionSheet.cancelButtonIndex {
//            self.inputToolbar.contentView.textView.becomeFirstResponder()
//            return
//        }
//        switch buttonIndex {
//        case 0:
//            self.demoData.addPhotoMediaMessage()
//        case 1:
//            weak var weakView: UICollectionView = self.collectionView
//            self.demoData.addLocationMediaMessageCompletion({() -> Void in
//                weakView.reloadData()
//            })
//            
//        case 2:
//            self.demoData.addVideoMediaMessage()
//        case 3:
//            self.demoData.addAudioMediaMessage()
//        }
//        
//        // [JSQSystemSoundPlayer jsq_playMessageSentSound];
//        self.finishSendingMessageAnimated(true)
//    }
//    // The output below is limited by 1 KB.
//    // Please Sign Up (Free!) to remove this limitation.
//    
//    
//    // MARK: - JSQMessages CollectionView DataSource
//    
//    
//    func senderId() -> String {
//        return kJSQDemoAvatarIdSquires
//    }
//    
//    func senderDisplayName() -> String {
//        return kJSQDemoAvatarDisplayNameSquires
//    }
//    
//    override func collectionView(collectionView: JSQMessagesCollectionView, messageDataForItemAtIndexPath indexPath: NSIndexPath) -> JSQMessageData {
//        return self.demoData.messages[indexPath.item]
//    }
//    
//    override func collectionView(collectionView: JSQMessagesCollectionView, didDeleteMessageAtIndexPath indexPath: NSIndexPath) {
//        self.demoData.messages.removeAtIndex(indexPath.item)
//    }
//    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
//        var message: JSQMessage = self.demoData.messages[indexPath.item]
//        if (message.senderId == self.senderId) {
//            return self.demoData.outgoingBubbleImageData
//        }
//        return self.demoData.incomingBubbleImageData
//    }
//    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
//        /**
//        *  Return `nil` here if you do not want avatars.
//        *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
//        *
//        *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
//        *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
//        *
//        *  It is possible to have only outgoing avatars or only incoming avatars, too.
//        */
//        
//        /**
//         *  Return your previously created avatar image data objects.
//         *
//         *  Note: these the avatars will be sized according to these values:
//         *
//         *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
//         *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
//         *
//         *  Override the defaults in `viewDidLoad`
//         */
//        var message: JSQMessage = self.demoData.messages[indexPath.item]
//        if (message.senderId == self.senderId) {
//            if !NSUserDefaults.outgoingAvatarSetting() {
//                return nil
//            }
//        }
//        else {
//            if !NSUserDefaults.incomingAvatarSetting() {
//                return nil
//            }
//        }
//        return (self.demoData.avatars[message.senderId] as! String)
//    }
//    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
//        /**
//         *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
//         *  The other label text delegate methods should follow a similar pattern.
//         *
//         *  Show a timestamp for every 3rd message
//         */
//        if indexPath.item % 3 == 0 {
//            var message: JSQMessage = self.demoData.messages[indexPath.item]
//            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
//        }
//        return nil
//
//    }
//    override func collectionView(collectionView: JSQMessagesCollectionView, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString {
//        var message: JSQMessage = self.demoData.messages[indexPath.item]
//        /**
//         *  iOS7-style sender name labels
//         */
//        if (message.senderId == self.senderId) {
//            return nil
//        }
//        if indexPath.item - 1 > 0 {
//            var previousMessage: JSQMessage = self.demoData.messages[indexPath.item - 1]
//            if (previousMessage.senderId == message.senderId) {
//                return nil
//            }
//        }
//        /**
//         *  Don't specify attributes to use the defaults.
//         */
//        return String(message.senderDisplayName)
//    }
//    
//    override func collectionView(collectionView: JSQMessagesCollectionView, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString {
//        return nil
//    }
//    
//    // MARK: - UICollectionView DataSource
//    
//    
//    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.demoData.messages.count
//    }
//    func collectionView(collectionView: JSQMessagesCollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        /**
//         *  Override point for customizing cells
//         */
//        var cell: JSQMessagesCollectionViewCell = (super.collectionView(collectionView, cellForItemAtIndexPath: indexPath!) as! JSQMessagesCollectionViewCell)
//        /**
//         *  Configure almost *anything* on the cell
//         *
//         *  Text colors, label text, label colors, etc.
//         *
//         *
//         *  DO NOT set `cell.textView.font` !
//         *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
//         *
//         *
//         *  DO NOT manipulate cell layout information!
//         *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
//         */
//        var msg: JSQMessage = self.demoData.messages[indexPath.item]
//        if !msg.isMediaMessage {
//            if (msg.senderId == self.senderId) {
//                cell.textView.textColor = UIColor.blackColor()
//            }
//            else {
//                cell.textView.textColor = UIColor.whiteColor()
//            }
//            cell.textView.linkTextAttributes = [NSForegroundColorAttributeName: cell.textView.textColor, .AttributeName: .Single | NSUnderlinePatternSolid]
//        }
//        cell.accessoryButton.hidden = !self.shouldShowAccessoryButtonForMessage(msg)
//        return cell
//    }
//    
//    func shouldShowAccessoryButtonForMessage(message: JSQMessageData) -> Bool {
//        return (message.isMediaMessage() && NSUserDefaults.accessoryButtonForMediaMessages())
//    }
//    
//    // MARK: - UICollectionView Delegate
//    
//    
//    // MARK: - Custom menu items
//    
//    
//    func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject) -> Bool {
//        if action == #selector(self.customAction) {
//            return true
//        }
//        return super.collectionView(collectionView, canPerformAction: action, forItemAtIndexPath: indexPath!, withSender: sender)
//    }
//    
//    func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject) {
//        if action == #selector(self.customAction) {
//            self.customAction(sender)
//            return
//        }
//        super.collectionView(collectionView, performAction: action, forItemAtIndexPath: indexPath!, withSender: sender)
//    }
//    
//    func customAction(sender: AnyObject) {
//        print("Custom action received! Sender: \(sender)")
//        UIAlertView(title: NSLocalizedString("Custom Action"), message: nil, delegate: nil, cancelButtonTitle: NSLocalizedString("OK"), otherButtonTitles: "").show()
//    }
//    
//    // MARK: - JSQMessages collection view flow layout delegate
//    
//    
//    // MARK: - Adjusting cell label heights
//    
//    
//    override func collectionView(collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        /**
//         *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
//         */
//        
//        /**
//         *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
//         *  The other label height delegate methods should follow similarly
//         *
//         *  Show a timestamp for every 3rd message
//         */
//
//        if indexPath.item % 3 == 0 {
//            return kJSQMessagesCollectionViewCellLabelHeightDefault
//        }
//        return 0.0
//    }
//    
//    override func collectionView(collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        /**
//         *  iOS7-style sender name labels
//         */
//        var currentMessage: JSQMessage = self.demoData.messages[indexPath.item]
//        if (currentMessage.senderId == self.senderId) {
//            return 0.0
//        }
//        if indexPath.item - 1 > 0 {
//            var previousMessage: JSQMessage = self.demoData.messages[indexPath.item - 1]
//            if (previousMessage.senderId == currentMessage.senderId) {
//                return 0.0
//            }
//        }
//        return kJSQMessagesCollectionViewCellLabelHeightDefault
//    }
//    override func collectionView(collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 0.0
//    }
//    
//    // MARK: - Responding to collection view tap events
//    
//    
//    override func collectionView(collectionView: JSQMessagesCollectionView, header headerView: JSQMessagesLoadEarlierHeaderView, didTapLoadEarlierMessagesButton sender: UIButton) {
//        print("Load earlier messages!")
//    }
//    
//    override func collectionView(collectionView: JSQMessagesCollectionView, didTapAvatarImageView avatarImageView: UIImageView, atIndexPath indexPath: NSIndexPath) {
//        print("Tapped avatar!")
//    }
//    
//    override func collectionView(collectionView: JSQMessagesCollectionView, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath) {
//        print("Tapped message bubble!")
//    }
//    
//    override func collectionView(collectionView: JSQMessagesCollectionView, didTapCellAtIndexPath indexPath: NSIndexPath, touchLocation: CGPoint) {
//        print("Tapped cell at \(NSStringFromCGPoint(touchLocation))!")
//    }
//    
//    // MARK: - JSQMessagesComposerTextViewPasteDelegate methods
//    
//    
//    func composerTextView(textView: JSQMessagesComposerTextView, shouldPasteWithSender sender: AnyObject) -> Bool {
//        if (UIPasteboard.generalPasteboard().image != nil) {
//            // If there's an image in the pasteboard, construct a media item with that image and `send` it.
//            var item: JSQPhotoMediaItem = JSQPhotoMediaItem(image: UIPasteboard.generalPasteboard().image)
//            var message: JSQMessage = JSQMessage(senderId: self.senderId, senderDisplayName: self.senderDisplayName, date: NSDate(), media: item)
//            self.demoData.messages.append(message)
//            self.finishSendingMessage()
//            return false
//        }
//        return true
//    }
//    // MARK: - JSQMessagesViewAccessoryDelegate methods
//    
//    
//    func messageView(view: JSQMessagesCollectionView, didTapAccessoryButtonAtIndexPath path: NSIndexPath) {
//        print("Tapped accessory button!")
//    }
//
//}
