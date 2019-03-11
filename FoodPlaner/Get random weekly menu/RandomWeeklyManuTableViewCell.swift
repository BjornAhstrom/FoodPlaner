//
//  RandomWeeklyManuTableViewCell.swift
//  FoodPlaner
//
//  Created by Björn Åhström on 2019-03-11.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class RandomWeeklyManuTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var foodNameLabel: UILabel!
    
    func setDateOnLabel(date: String) {
        dateLabel.text! = date
    }
    
    func setFoodnameOnLabel(foodName: String) {
        foodNameLabel.text! = foodName
    }

}
