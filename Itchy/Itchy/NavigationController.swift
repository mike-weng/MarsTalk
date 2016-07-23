//
//  NavigationController.swift
//  MarsTalk
//
//  Created by Mike Weng on 7/21/16.
//  Copyright © 2016 Weng. All rights reserved.
//

import UIKit
import RMPZoomTransitionAnimator

class NavigationController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let sourceTransition = fromVC
        let destinationTransition = toVC
        if sourceTransition.conformsToProtocol(RMPZoomTransitionAnimating) && destinationTransition.conformsToProtocol(RMPZoomTransitionAnimating) {
            let animator: RMPZoomTransitionAnimator = RMPZoomTransitionAnimator()
            animator.goingForward = (operation == .Push)
            animator.sourceTransition = (sourceTransition as! protocol<RMPZoomTransitionAnimating, RMPZoomTransitionDelegate>)
            animator.destinationTransition = (destinationTransition as! protocol<RMPZoomTransitionAnimating, RMPZoomTransitionDelegate>)
            return animator
        }
        return nil
    }
}
