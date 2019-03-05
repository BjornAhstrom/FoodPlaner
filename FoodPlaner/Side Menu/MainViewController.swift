//
//  MainViewController.swift
//  FoodPlaner
//
//  Created by Björn Åhström on 2019-02-27.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var mainView: UIView!
    
    var test: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func moreTappedButton() {
        NotificationCenter.default.post(name: NSNotification.Name("showSideMenu"), object: nil)
    }
}
