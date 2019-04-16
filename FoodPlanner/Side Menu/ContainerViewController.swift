//
//  ContainerViewController.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-02-27.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit
import Firebase

class ContainerViewController: UIViewController {
    @IBOutlet weak var sideMenuTrailingConstraint: NSLayoutConstraint!
    
    var sideMenuOpen: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeLeftAndRight()
        NotificationCenter.default.addObserver(self, selector: #selector(showSideMenu), name: NSNotification.Name( "showSideMenu"), object: nil)
    }
    
    @objc func showSideMenu() {
        if sideMenuOpen {
            sideMenuTrailingConstraint.constant = -270
            sideMenuOpen = false
            animations()
        } else {
            sideMenuTrailingConstraint.constant = 0
            sideMenuOpen = true
            animations()
        }
    }
    
    func animations() {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut, animations: {self.view.layoutIfNeeded()})
    }
    
    func swipeLeftAndRight() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.showSideMenu))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.showSideMenu))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
//    override func becomeFirstResponder() -> Bool {
//        return true
//    }
//
//    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
//
//        if motion == .motionShake {
//            print("!!!!!!!!!!!!!!Shake")
//        }
//    }
}

extension UIViewController {
    func alertMessage(titel: String, message: String) {
        let alert = UIAlertController(title: titel, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion:  nil)
    }
}
