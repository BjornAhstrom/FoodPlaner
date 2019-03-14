//
//  Ingredients.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-07.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation
import UIKit

class Ingredient {
    var ingredientsTitle: String = ""
    var amountInt: Int = 0
    var amountString: String = ""
    
    init(ingredientsTitle: String, amount: Int, unit: String) {
        self.ingredientsTitle = ingredientsTitle
        self.amountInt = amount
        self.amountString = unit
    }
}
