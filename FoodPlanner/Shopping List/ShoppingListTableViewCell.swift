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
    @IBOutlet weak var checkBoxImageView: UIImageView!
    
    func setIngredients(name: String, amount: Int, unit : String) {
        ingredientsLabel.text = "\(name)"
        amountAndUnitLabel.text = "\(amount) \(unit)"
        
        for label in labels {
            label.font = Theme.current.textFontInTableViewInShoppingViewController
            label.textColor = Theme.current.textColorInTableViewInShoppingViewController
        }
    }
    
    func setCheckBox(_ value: Bool) {
        if value == true {
            checkBoxImageView.image = UIImage(named: "checked")
        } else {
            checkBoxImageView.image = UIImage(named: "")
        }
    }
    
    func checkBox() {
        checkBoxImageView.layer.masksToBounds = true
        checkBoxImageView.layer.borderColor = Theme.current.borderColorForCheckBoxInShoppingViewController.cgColor
        checkBoxImageView.layer.borderWidth = 2
        checkBoxImageView.layer.cornerRadius = 8
    }
}
