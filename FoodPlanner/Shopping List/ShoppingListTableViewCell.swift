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
    @IBOutlet weak var checkBoxButton: UIButton!
    
    func setIngredientsNameOnLabel(ingredientsName: String) {
        ingredientsLabel.text = "\(ingredientsName)"
        ingredientsLabel.font = UIFont(name: Theme.current.fontForLabels, size: 17)
        ingredientsLabel.textColor = Theme.current.textColorForLabels
    }
    
    func checkBox() {
        checkBoxButton.layer.borderColor = Theme.current.colorForBorder.cgColor
        checkBoxButton.layer.borderWidth = 2
    }
    @IBAction func checkBoxButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
}
