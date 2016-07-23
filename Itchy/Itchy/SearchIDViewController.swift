//
//  SearchIDViewController.swift
//  MarsTalk
//
//  Created by Mike Weng on 7/22/16.
//  Copyright © 2016 Weng. All rights reserved.
//

import UIKit
import FoldingTabBar
import MaterialKit

class SearchIDViewController: UIViewController, YALTabBarDelegate {
    var keyboardController: KeyboardController!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addButton: MKButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        keyboardController = KeyboardController(viewController: self)
        self.appDelegate.tabBarController.tabBarView.setExtraLeftTabBarButtonImage(UIImage(named: "BackIcon"), index: 1)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        keyboardController.registerTapToHideKeyboard()
        self.profileImageView.hidden = true
        self.nameLabel.hidden = true
        self.addButton.hidden = true
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardController.unregisterTapToHideKeyboard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarDidSelectExtraLeftItem(tabBar: YALFoldingTabBar!) {
        self.navigationController?.popViewControllerAnimated(true)
        self.appDelegate.tabBarController.tabBarView.setExtraLeftTabBarButtonImage(UIImage(named: "RotateIcon"), index: 1)
    }
}
