//
//  Convenience.swift
//  Itchy
//
//  Created by Mike Weng on 7/4/16.
//  Copyright © 2016 Weng. All rights reserved.
//

import UIKit

class KeyboardController: NSObject {
    var tapRecognizer: UITapGestureRecognizer? = nil
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    var viewController: UIViewController!
    
    init(viewController: UIViewController) {
        super.init()
        self.viewController = viewController
        self.configureTapRecognizer()
    }
    
    func registerTapToHideKeyboard() {
        self.addKeyboardDismissRecognizer()
    }
    
    func unregisterTapToHideKeyboard() {
        self.removeKeyboardDismissRecognizer()
        self.unsubscribeToKeyboardNotifications()
    }
    
    func configureTapRecognizer() {
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(KeyboardController.handleSingleTap(_:)))
        tapRecognizer?.numberOfTapsRequired = 1
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        viewController.view.endEditing(true)
    }
    
    func addKeyboardDismissRecognizer() {
        viewController.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        viewController.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
}