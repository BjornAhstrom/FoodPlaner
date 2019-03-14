//
//  savedDishTableViewCell.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-08.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class ShowDishTableViewCell: UITableViewCell {
    @IBOutlet weak var ingredientsNameLabel: UILabel!
    @IBOutlet weak var ingredientsAmountLabel: UILabel!
    
    func setIngredientsNameAndAmount(ingredientsName: Ingredient, ingredientsAmount: Ingredient, ingredientsUnit: Ingredient) {
        ingredientsNameLabel.text = "\(ingredientsName)"
        ingredientsAmountLabel.text = "\(ingredientsAmount) \(ingredientsUnit)"
    }

}
