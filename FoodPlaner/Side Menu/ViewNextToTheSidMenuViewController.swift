//
//  ViewNextToTheSidMenuViewController.swift
//  FoodPlaner
//
//  Created by Björn Åhström on 2019-03-03.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class ViewNextToTheSidMenuViewController: UIViewController {
    var test: Bool = true
    
    @IBOutlet var HeadView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       HeadView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(showHeaderView), name: NSNotification.Name( "showView"), object: nil)
    }
    
    @objc func showHeaderView() {
        HeadView.isHidden = false
    }
}
