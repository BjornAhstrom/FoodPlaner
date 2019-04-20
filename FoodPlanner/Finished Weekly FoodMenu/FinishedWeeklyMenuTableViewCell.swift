//
//  FinishedWeeklyMenuTableViewCell.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-15.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class FinishedWeeklyMenuTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var foodNameLabel: UILabel!
    
    func setDateOnLabel(date: Date) {
        dateLabel.textColor = UIColor.gray
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE dd/MM"
        
        let dateFormated = dateFormatter.string(from: date)
        
        dateLabel.text? = dateFormated
    }
    
    func setFoodnameOnLabel(foodName: String) {
        foodNameLabel.textColor = Theme.current.textColor
        foodNameLabel.font = UIFont(name: Theme.current.fontForLabels, size: 20)
        foodNameLabel.text? = foodName
    }
}
