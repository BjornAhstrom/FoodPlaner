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
    private let showSideMenuId = "showSideMenu"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeLeftAndRight()
        NotificationCenter.default.addObserver(self, selector: #selector(showSideMenu), name: NSNotification.Name( showSideMenuId), object: nil)
        //self.hideKeyboard() // kolla om det går att ordna
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
}

extension UIViewController {
    func alertMessage(titel: String, message: String) {
        let alert = UIAlertController(title: titel, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion:  nil)
    }
}
