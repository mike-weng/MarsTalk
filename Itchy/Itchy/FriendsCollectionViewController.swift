//
//  FriendsViewController.swift
//  MarsTalk
//
//  Created by Mike Weng on 7/20/16.
//  Copyright © 2016 Weng. All rights reserved.
//

import UIKit
import Presentr
import RMPZoomTransitionAnimator
import DisplaySwitcher
import FoldingTabBar
import KYGooeyMenu

private let animationDuration: NSTimeInterval = 0.3
private let listLayoutStaticCellHeight: CGFloat = 80
private let gridLayoutStaticCellHeight: CGFloat = 165

class FriendsCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate, RMPZoomTransitionAnimating, RMPZoomTransitionDelegate, YALTabBarDelegate, menuDidSelectedDelegate {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    var selectedIndexPath: NSIndexPath!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rotationButton: RotationButton!
    private var isTransitionAvailable = true
    private lazy var listLayout = BaseLayout(staticCellHeight: listLayoutStaticCellHeight, nextLayoutStaticCellHeight: gridLayoutStaticCellHeight, layoutState: .ListLayoutState)
    private lazy var gridLayout = BaseLayout(staticCellHeight: gridLayoutStaticCellHeight, nextLayoutStaticCellHeight: listLayoutStaticCellHeight, layoutState: .GridLayoutState)
    private var layoutState: CollectionViewLayoutState = .ListLayoutState
    var refreshControl: UIRefreshControl!

    var addFriendMenu: KYGooeyMenu!
    let presenter: Presentr = {
        let customType = PresentationType.Custom(width: .Custom(size: 350), height: .Custom(size: 500), center: .Center)
        let presenter = Presentr(presentationType: customType)
        presenter.transitionType = TransitionType.CrossDissolve
        presenter.roundCorners = true
        presenter.dismissOnTap = true
        return presenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.initializeAddFriendMenu()
        self.configureRefreshControl();
        self.loadFriendsList()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addFriendMenu.mainView.hidden = false
        addFriendMenu.hideRightGooeyMenu()
        addFriendMenu.showRightGooeyMenu()
        self.appDelegate.tabBarController.tabBarView.setExtraLeftTabBarButtonImage(UIImage(named: "RotateIcon"), index: 0)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        addFriendMenu.mainView.hidden = true
        addFriendMenu.hideRightGooeyMenu()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.reloadData()
    }
    
    func transitionSourceImageView() -> UIImageView! {
        let cell: FriendsCollectionViewCell = self.collectionView.cellForItemAtIndexPath(selectedIndexPath) as! FriendsCollectionViewCell
        let imageView: UIImageView = UIImageView(image: cell.avatarImageView.image)
        imageView.contentMode = cell.avatarImageView.contentMode
        imageView.clipsToBounds = true
        imageView.userInteractionEnabled = false
        imageView.frame = cell.avatarImageView!.convertRect(cell.avatarImageView.frame, toView: self.collectionView.superview)
        return imageView
    }

    func transitionSourceBackgroundColor() -> UIColor! {
        return self.collectionView.backgroundColor;
    }

    func transitionDestinationImageViewFrame() -> CGRect {
        let cell: FriendsCollectionViewCell = self.collectionView.cellForItemAtIndexPath(selectedIndexPath) as! FriendsCollectionViewCell
        let cellFrameInSuperview: CGRect = cell.avatarImageView!.convertRect(cell.avatarImageView.frame, toView: self.collectionView.superview)
        return cellFrameInSuperview
    }
    
    private func setupCollectionView() {
        rotationButton.selected = true
        collectionView.collectionViewLayout = listLayout
        collectionView.registerNib(FriendsCollectionViewCell.cellNib, forCellWithReuseIdentifier:"FriendsCollectionViewCell")
    }
    
    @IBAction func transformButtonTouchUp(sender: AnyObject) {
        if User.currentUser.friendList.isEmpty {
            return
        }
        if !isTransitionAvailable {
            return
        }
        let transitionManager: TransitionManager
        if layoutState == .ListLayoutState {
            layoutState = .GridLayoutState
            transitionManager = TransitionManager(duration: animationDuration, collectionView: collectionView!, destinationLayout: gridLayout, layoutState: layoutState)
        } else {
            layoutState = .ListLayoutState
            transitionManager = TransitionManager(duration: animationDuration, collectionView: collectionView!, destinationLayout: listLayout, layoutState: layoutState)
        }
        transitionManager.startInteractiveTransition()
        rotationButton.selected = layoutState == .ListLayoutState
        rotationButton.animationDuration = animationDuration
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return User.currentUser.friendList.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath
        let detailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        self.appDelegate.tabBarController.tabBarView.swapExtraLeftTabBarItem()
        self.navigationController?.pushViewController(detailViewController, animated: true)
        self.collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FriendsCollectionViewCell", forIndexPath: indexPath) as! FriendsCollectionViewCell
        let friend = User.currentUser.friendList[indexPath.item]
        let firstName = friend.firstName
        let lastName = friend.lastName
        cell.nameListLabel.text = firstName + " " + lastName
        cell.nameGridLabel.text = firstName + " " + lastName
        cell.statisticLabel.text = friend.userID
        cell.avatarImageView.image = friend.profileImage
        
        if layoutState == .GridLayoutState {
            cell.setupGridLayoutConstraints(1, cellWidth: cell.frame.width)
        } else {
            cell.setupListLayoutConstraints(1, cellWidth: cell.frame.width)
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        let customTransitionLayout = TransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
        return customTransitionLayout
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        isTransitionAvailable = false
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isTransitionAvailable = true
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func tabBarDidSelectExtraLeftItem(tabBar: YALFoldingTabBar!) {
        if User.currentUser.friendList.isEmpty {
            return
        }
        //Rotate
        if !isTransitionAvailable {
            return
        }
        let transitionManager: TransitionManager
        if layoutState == .ListLayoutState {
            layoutState = .GridLayoutState
            transitionManager = TransitionManager(duration: animationDuration, collectionView: collectionView!, destinationLayout: gridLayout, layoutState: layoutState)
        } else {
            layoutState = .ListLayoutState
            transitionManager = TransitionManager(duration: animationDuration, collectionView: collectionView!, destinationLayout: listLayout, layoutState: layoutState)
        }
        transitionManager.startInteractiveTransition()
        rotationButton.selected = layoutState == .ListLayoutState
        rotationButton.animationDuration = animationDuration
    }
    
    func tabBarWillExpand(tabBar: YALFoldingTabBar!) {
        print("will expand")
        addFriendMenu.hideRightGooeyMenu()
    }
    
    func tabBarWillCollapse(tabBar: YALFoldingTabBar!) {
        print("will collapse")
        addFriendMenu.showRightGooeyMenu()
    }

    func initializeAddFriendMenu() {
        let tabBarController: YALFoldingTabBarController = appDelegate.tabBarController as YALFoldingTabBarController
        addFriendMenu = KYGooeyMenu(origin: CGPointMake(CGRectGetMaxX(self.view.frame) - 72, CGRectGetMaxY(self.view.frame) - 63.5), andDiameter: 48.0, andDelegate: tabBarController, themeColor: UIColor.blackColor(), mainMenuImage: UIImage(named: "AddFriendIcon"))
        addFriendMenu.offsetForGooeyMenu = 24
        addFriendMenu.menuDelegate = self
        addFriendMenu.radius = 20
        addFriendMenu.extraDistance = 5
        addFriendMenu.MenuCount = 3
        addFriendMenu.menuImagesArray = [UIImage(named: "ShakeIcon")!, UIImage(named: "QRCodeIcon")!, UIImage(named: "SearchIcon")!]
    }
    
    func menuDidSelected(index: Int32) {
        switch index {
        case 1:
            //Shake
            AlertController.sharedInstance.showOneActionAlert("Opps!!", body: "Service not yet allowed", actionTitle: "Fine! Be that way!", viewController: self)
        case 2:
            //QRCode
            AlertController.sharedInstance.showOneActionAlert("Opps!!", body: "Service not yet allowed", actionTitle: "Fine! Be that way!", viewController: self)
        case 3:
            //Search
            let searchIDViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SearchIDViewController") as! SearchIDViewController
            self.navigationController?.pushViewController(searchIDViewController, animated: true)
        default:
            print("nono")
        }
        self.appDelegate.tabBarController.tabBarView.swapExtraLeftTabBarItem()
    }
    
    func loadFriendsList() {
        AlertController.sharedInstance.startNormalActivityIndicator(self)
        let relation = PFUser.currentUser()!.relationForKey("friends")
        let query = relation.query()
        query.findObjectsInBackgroundWithBlock({ (result, error) -> Void in
            if let result = result {
                if (result.isEmpty) {
                    self.collectionView.reloadData()
                    AlertController.sharedInstance.stopNormalActivityIndicator()
                }
                for user in result {
                    let user = user as! PFUser
                    let friend = User(user: user)
                    User.currentUser.friendList.append(friend)
                    
                    // get image data
                    if let profileImage = user["profileImage"] {
                        let imageFile = profileImage as! PFFile
                        imageFile.getDataInBackgroundWithBlock { (result, error) -> Void in
                            if let imageData = result {
                                friend.profileImage = UIImage(data: imageData)!
                            }
                            self.collectionView.reloadData()
                        }
                    }
                }
                self.collectionView.reloadData()
                AlertController.sharedInstance.stopNormalActivityIndicator()
            } else {
                AlertController.sharedInstance.showOneActionAlert("Error", body: error!.userInfo["error"] as! String, actionTitle: "Retry", viewController: self)
            }
        })
    }
    
    func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(FriendsCollectionViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    func refresh() {
        loadFriendsList()
        self.refreshControl?.endRefreshing()
    }
    
    
    
    


}
