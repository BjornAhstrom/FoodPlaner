//
//  DishCellTableViewCell.swift
//  FoodPlaner
//
//  Created by Björn Åhström on 2019-03-07.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountAndUnitLabel: UILabel!
    
    func setIngredientsTitle(title: Ingredient, amount: Ingredient, unit: Ingredient) {
        titleLabel.text = "\(title.ingredientsTitle)"
        amountAndUnitLabel.text = "\(amount.amountInt) \(unit.amountString)"
    }

}
