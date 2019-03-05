//
//  HeaderWeeklyMenu.swift
//  FoodPlaner
//
//  Created by Björn Åhström on 2019-03-03.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class HeaderWeeklyMenu: UIView {
    @IBOutlet var weeklyMenuView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        UINib(nibName: "WeeklyMenu", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(weeklyMenuView)
        weeklyMenuView.frame = self.bounds
    }
}
