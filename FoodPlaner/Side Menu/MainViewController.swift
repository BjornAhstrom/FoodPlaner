//
//  MainViewController.swift
//  FoodPlaner
//
//  Created by Björn Åhström on 2019-02-27.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func moreTappedButton() {
        print("Show side menu")
        NotificationCenter.default.post(name: NSNotification.Name("showSideMenu"), object: nil)
    }
}
