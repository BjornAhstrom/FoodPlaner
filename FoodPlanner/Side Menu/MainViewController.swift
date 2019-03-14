//
//  MainViewController.swift
//  FoodPlanner
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
        NotificationCenter.default.addObserver(self, selector: #selector(showScreen), name: NSNotification.Name( "addAndShowDish"), object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(showSideMenu), name: NSNotification.Name( "showSideMenu"), object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(showSideMenu), name: NSNotification.Name( "showSideMenu"), object: nil)
        
    }
    
    @objc func showScreen() {
        performSegue(withIdentifier: "addAndShowDishSegue", sender: nil)
    }
    
    @IBAction func moreTappedButton() {
        NotificationCenter.default.post(name: NSNotification.Name("showSideMenu"), object: nil)
    }
}
