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

    var selectedIndexPath: NSIndexPath!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rotationButton: RotationButton!
    private var isTransitionAvailable = true
    private lazy var listLayout = BaseLayout(staticCellHeight: listLayoutStaticCellHeight, nextLayoutStaticCellHeight: gridLayoutStaticCellHeight, layoutState: .ListLayoutState)
    private lazy var gridLayout = BaseLayout(staticCellHeight: gridLayoutStaticCellHeight, nextLayoutStaticCellHeight: listLayoutStaticCellHeight, layoutState: .GridLayoutState)
    private var layoutState: CollectionViewLayoutState = .ListLayoutState
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var gooeyMenu: KYGooeyMenu!
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
        self.initializeAddFriendGooeyMenu()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        gooeyMenu.mainView.hidden = false
        gooeyMenu.showRightGooeyMenu()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        gooeyMenu.hideRightGooeyMenu()
        gooeyMenu.mainView.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 4
//    }
//    
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("FriendsCell", forIndexPath: indexPath) as! FriendsTableViewCell
//        cell.nameLabel.text = "Mike"
////        let friend = friendList[indexPath.row] as! PFUser
////        cell.nameLabel.text = friend["username"] as? String
////        cell.userImageView!.image = UIImage(named: "placeHolder")
//        
//        return cell
//    }
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        selectedIndexPath = indexPath
//        let detailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
//        self.navigationController?.pushViewController(detailViewController, animated: true)
////        self.customPresentViewController(presenter, viewController: detailViewController, animated: true, completion: nil)
//        self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow!, animated: true)
//    }
    
    
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
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath
        let detailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        self.navigationController?.pushViewController(detailViewController, animated: true)
//                self.customPresentViewController(presenter, viewController: detailViewController, animated: true, completion: nil)
        self.collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FriendsCollectionViewCell", forIndexPath: indexPath) as! FriendsCollectionViewCell
        if layoutState == .GridLayoutState {
            cell.setupGridLayoutConstraints(1, cellWidth: cell.frame.width)
        } else {
            cell.setupListLayoutConstraints(1, cellWidth: cell.frame.width)
        }
//        cell.bind(searchUsers[indexPath.row])
        
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
    
    func tabBarDidSelectExtraRightItem(tabBar: YALFoldingTabBar!) {
        //Add new friend
    }
    func tabBarDidSelectExtraLeftItem(tabBar: YALFoldingTabBar!) {
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
        gooeyMenu.hideRightGooeyMenu()
    }
    
    func tabBarWillCollapse(tabBar: YALFoldingTabBar!) {
        print("will collapse")
        gooeyMenu.showRightGooeyMenu()
    }

    func initializeAddFriendGooeyMenu() {
        let tabBarController: YALFoldingTabBarController = appDelegate.tabBarController as YALFoldingTabBarController
        gooeyMenu = KYGooeyMenu(origin: CGPointMake(CGRectGetMaxX(self.view.frame) - 72, CGRectGetMaxY(self.view.frame) - 63.5), andDiameter: 48.0, andDelegate: tabBarController, themeColor: UIColor.blackColor(), mainMenuImage: UIImage(named: "AddFriendIcon"))
        gooeyMenu.offsetForGooeyMenu = 24
        gooeyMenu.menuDelegate = self
        gooeyMenu.radius = 20
        gooeyMenu.extraDistance = 5
        gooeyMenu.MenuCount = 3
        gooeyMenu.menuImagesArray = [UIImage(named: "ShakeIcon")!, UIImage(named: "QRCodeIcon")!, UIImage(named: "SearchIcon")!]
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
//            self.presentViewController(searchIDViewController, animated: true, completion: nil)
//            self.customPresentViewController(presenter, viewController: searchIDViewController, animated: true, completion: nil)
        default:
            print("nono")
        }
    }
    
}
