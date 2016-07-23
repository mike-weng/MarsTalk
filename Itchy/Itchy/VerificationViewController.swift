//
//  PasswordViewController.swift
//  Itchy
//
//  Created by Mike Weng on 7/5/16.
//  Copyright © 2016 Weng. All rights reserved.
//

import UIKit

class VerificationViewController: UIViewController {

    var keyboardController: KeyboardController!
    var userEmail: String!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var toolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyboardController = KeyboardController(viewController: self)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.keyboardController.registerTapToHideKeyboard()
        self.emailLabel.text = userEmail
        self.view.sendSubviewToBack(toolBar)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardController.unregisterTapToHideKeyboard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func exitButtonTouchUp(sender: UIBarButtonItem) {
        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
//        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func submitButtonTouchUp(sender: AnyObject) {
        AlertController.sharedInstance.startActivityIndicator(self)
        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        AlertController.sharedInstance.stopActivityIndicator()
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
