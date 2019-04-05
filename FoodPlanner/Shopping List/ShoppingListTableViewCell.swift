//
//  ShoppingListTableViewCell.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-21.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class ShoppingListTableViewCell: UITableViewCell {
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var amountAndUnitLabel: UILabel!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var checkBoxButton: UIButton!
    
    func setIngredients(name: String, amount: Int, unit : String) {
        ingredientsLabel.text = "\(name)"
        amountAndUnitLabel.text = "\(amount) \(unit)"
        
        for label in labels {
            label.font = UIFont(name: Theme.current.fontForLabels, size: 17)
            label.textColor = Theme.current.textColorForLabels
        }
    }
    
    func setCheckBox(_ value: Bool) {
        checkBoxButton.isSelected = value
    }
    
    func checkBox() {
        checkBoxButton.layer.borderColor = Theme.current.colorForBorder.cgColor
        checkBoxButton.layer.borderWidth = 2
    }
    @IBAction func checkBoxButton(_ sender: UIButton) {
      //  sender.isSelected = !sender.isSelected
    }
    
}
