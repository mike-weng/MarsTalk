//
//  DetailViewController.swift
//  MarsTalk
//
//  Created by Mike Weng on 7/21/16.
//  Copyright © 2016 Weng. All rights reserved.
//

import UIKit
import FoldingTabBar
import RMPZoomTransitionAnimator
import KYAnimatedPageControl

class DetailViewController: UIViewController, RMPZoomTransitionAnimating, RMPZoomTransitionDelegate, YALTabBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    var pageControl: KYAnimatedPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBarHidden = true
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .None)

        let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 0
        
        self.pageControl = KYAnimatedPageControl(frame: CGRectMake(self.collectionView.frame.maxX/2.0 - (4 * 25.0 / 2), self.collectionView.frame.maxY-20, 4 * 25, 20))
        
        self.pageControl.pageCount = 4
        self.pageControl.unSelectedColor = UIColor(white: 0.9, alpha: 0.6)
        self.pageControl.selectedColor = UIColor.blackColor().colorWithAlphaComponent(0.9)
        self.pageControl.bindScrollView = self.collectionView
        self.pageControl.shouldShowProgressLine = false
        self.pageControl.indicatorStyle = IndicatorStyleGooeyCircle
        self.pageControl.indicatorSize = 13
        self.pageControl.swipeEnable = true
        self.scrollView.addSubview(self.pageControl)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.contentSize = CGSizeMake(
            self.view.frame.size.width,
            self.view.frame.size.height + 500
        )
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.appDelegate.tabBarController.tabBarView.setExtraLeftTabBarButtonImage(UIImage(named: "BackIcon"), index: 0)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
        self.navigationController?.navigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func transitionSourceImageView() -> UIImageView! {
        let imageView: UIImageView = UIImageView(image: self.mainImageView.image)
        imageView.contentMode = self.mainImageView.contentMode
        imageView.clipsToBounds = true
        imageView.userInteractionEnabled = false
        imageView.frame = self.mainImageView.frame
        return imageView
        
    }
    
    func transitionSourceBackgroundColor() -> UIColor! {
        return self.view.backgroundColor;
    }
    
    func transitionDestinationImageViewFrame() -> CGRect {
        let width: CGFloat = CGRectGetWidth(self.mainImageView.frame)
        var frame: CGRect = self.mainImageView.frame
        frame.size.width = width
        return frame
    }
    
    func zoomTransitionAnimator(animator: RMPZoomTransitionAnimator!, didCompleteTransition didComplete: Bool, animatingSourceImageView imageView: UIImageView!) {
        self.mainImageView.image = imageView.image;
    }
    func tabBarDidSelectExtraLeftItem(tabBar: YALFoldingTabBar!) {
        self.navigationController?.popViewControllerAnimated(true)
        tabBar.setExtraLeftTabBarButtonImage(UIImage(named: "RotateIcon"), index: 1)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath)
        return cell
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pageControl.pageCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let profileImageCollectionViewCell: ProfileImageCollectionViewCell = (collectionView.dequeueReusableCellWithReuseIdentifier("ProfileImageCollectionViewCell", forIndexPath: indexPath) as! ProfileImageCollectionViewCell)
        profileImageCollectionViewCell.imageView.image = UIImage(named: "AvatarPlaceholder")
        return profileImageCollectionViewCell
    }

    
    // MARK:-- UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (scrollView != self.scrollView) {
            self.pageControl.indicator.animateIndicatorWithScrollView(scrollView, andIndicator: self.pageControl)
            if scrollView.dragging || scrollView.decelerating || scrollView.tracking {
                
                self.pageControl.pageControlLine.animateSelectedLineWithScrollView(scrollView)
            }
        }
//        let y: CGFloat = -scrollView.contentOffset.y
//        if let indexPath = self.collectionView.indexPathForItemAtPoint(CGPointMake(self.collectionView.center.x, self.collectionView.center.y)) {
//            if let profileImageCollectionViewCell: ProfileImageCollectionViewCell! = self.collectionView.cellForItemAtIndexPath(indexPath) as! ProfileImageCollectionViewCell {
//                if y > 0 {
//                    self.collectionView.frame = CGRectMake(0, scrollView.contentOffset.y, self.collectionView.frame.size.width + y, self.collectionView.frame.size.height + y)
//                    self.collectionView.center = CGPointMake(self.view.center.x, self.collectionView.center.y)
//                    print("change collectionView")
//                    
//                    profileImageCollectionViewCell.frame = CGRectMake(0, scrollView.contentOffset.y, profileImageCollectionViewCell.frame.size.width + y, profileImageCollectionViewCell.frame.size.height + y)
//                    profileImageCollectionViewCell.center = CGPointMake(self.view.center.x, profileImageCollectionViewCell.center.y)
//                    print("change cellView")
//                } else {
//                    self.collectionView.frame = CGRectMake(0, scrollView.contentOffset.y, self.collectionView.frame.size.width + y, self.collectionView.frame.size.height + y)
//                    self.collectionView.center = CGPointMake(self.view.center.x, self.collectionView.center.y)
//                    print("change collectionView")
//    
//                    profileImageCollectionViewCell.frame = CGRectMake(0, scrollView.contentOffset.y, profileImageCollectionViewCell.frame.size.width + y, profileImageCollectionViewCell.frame.size.height + y)
//                    profileImageCollectionViewCell.center = CGPointMake(self.view.center.x, profileImageCollectionViewCell.center.y)
//                    print("change cellView")
//    
//                    profileImageCollectionViewCell.imageView.frame = CGRectMake(0, scrollView.contentOffset.y, profileImageCollectionViewCell.imageView.frame.size.width + y, profileImageCollectionViewCell.imageView.frame.size.height + y)
//                    profileImageCollectionViewCell.imageView.center = CGPointMake(self.view.center.x, profileImageCollectionViewCell.imageView.center.y)
//                    print("change imageView")
//                }
//            }
//        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if (scrollView != self.scrollView) {
            self.pageControl.indicator.lastContentOffset = scrollView.contentOffset.x
        }

    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        if (scrollView != self.scrollView) {
            let count = 1/Double(self.pageControl.pageCount)
            self.pageControl.indicator.restoreAnimation(count)
        }
        
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if (scrollView != self.scrollView) {
            self.pageControl.indicator.lastContentOffset = scrollView.contentOffset.x
        }
    }
    
    

}
