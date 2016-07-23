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

class DetailViewController: UIViewController, RMPZoomTransitionAnimating, RMPZoomTransitionDelegate, YALTabBarDelegate {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var mainImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.appDelegate.tabBarController.tabBarView.setExtraLeftTabBarButtonImage(UIImage(named: "BackIcon"), index: 1)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
        self.appDelegate.tabBarController.tabBarView.setExtraLeftTabBarButtonImage(UIImage(named: "RotateIcon"), index: 1)
    }
}
