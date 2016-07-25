//
//  AlertController.swift
//  MarsTalk
//
//  Created by Mike Weng on 7/19/16.
//  Copyright © 2016 Weng. All rights reserved.
//

import Foundation
import Presentr
import SVProgressHUD
import MaterialKit



class AlertController: NSObject {
    
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .Alert)
        presenter.transitionType = .CoverVerticalFromTop
        presenter.roundCorners = true
        presenter.dismissOnTap = false
        
        return presenter
    }()
    
    var activityIndicator: MKActivityIndicator = MKActivityIndicator()
    var indicatorBackView: UIView!

    
    static let sharedInstance = AlertController()

    private override init() {
        super.init()
        configureActivityIndicator()
    }
    
    func showOneActionAlert(title: String, body: String, actionTitle: String, viewController: UIViewController) {
        
        let controller = Presentr.alertViewController(title: title, body: body)
        
        let okAction = AlertAction(title: actionTitle, style: .Cancel){
            print(actionTitle)
        }
        
        controller.addAction(okAction)
        
        viewController.customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
        
    }
    
    func configureActivityIndicator() {
        activityIndicator = MKActivityIndicator(frame: CGRectMake(0, 0, 60, 60))
        activityIndicator.color = UIColor.whiteColor()
    }
    
    func startNormalActivityIndicator(target: UIViewController) {
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        activityIndicator.center = target.view.center
        indicatorBackView = UIView(frame: CGRectMake(0, 0, width, height))
        indicatorBackView.backgroundColor = UIColor.blackColor()
        indicatorBackView.alpha = 0.5
        target.view.addSubview(indicatorBackView)
        target.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    func stopNormalActivityIndicator() {
        self.activityIndicator.stopAnimating()
        indicatorBackView.alpha = 0
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    func startActivityIndicator(target: UIViewController) {
        SVProgressHUD.setDefaultMaskType(.Black)
        SVProgressHUD.setDefaultStyle(.Custom)
        SVProgressHUD.setForegroundColor(UIColor.whiteColor())
        SVProgressHUD.setBackgroundColor(UIColor.blackColor().colorWithAlphaComponent(0.7))
        SVProgressHUD.show()
    }
    
    func stopActivityIndicator() {
        SVProgressHUD.dismiss()
    }
    
    

    
}