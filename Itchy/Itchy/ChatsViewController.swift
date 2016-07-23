//
//  ChatsViewController.swift
//  MarsTalk
//
//  Created by Mike Weng on 7/22/16.
//  Copyright © 2016 Weng. All rights reserved.
//

import UIKit

class ChatsViewController: UIViewController {
    
    var keyboardController: KeyboardController!
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardController = KeyboardController(viewController: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        keyboardController.registerTapToHideKeyboard()
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardController.unregisterTapToHideKeyboard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
