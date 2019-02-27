//
//  ContainerViewController.swift
//  FoodPlaner
//
//  Created by Björn Åhström on 2019-02-27.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    
    var sideMenuOpen: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(showSideMenu), name: NSNotification.Name( "showSideMenu"), object: nil)
        
    }
    
    @objc func showSideMenu() {
        if sideMenuOpen {
            sideMenuConstraint.constant = -240
            sideMenuOpen = false
            sideMenuAnimationFromRightToLeft()
        } else {
            sideMenuConstraint.constant = 0
            sideMenuOpen = true
            sideMenuAnimationFromLeftToRight()
        }
    }
    
    func sideMenuAnimationFromRightToLeft() {
        let transition = CATransition()
        
        let withDuration = 0.5
        
        transition.duration = withDuration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        
        self.view.layer.add(transition, forKey: kCATransition)
    }
    
    func sideMenuAnimationFromLeftToRight() {
        let transition = CATransition()
        
        let withDuration = 0.5
        
        transition.duration = withDuration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        
        self.view.layer.add(transition, forKey: kCATransition)
    }
}
