//
//  Dish.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-03.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation
import UIKit

class Dish {
    var dishName: String
    var dishImage: UIImage
    var ingredientsAndAmount: [Ingredient] = []
    var cooking: String
    
    
    init(dishTitle: String, dishImage: UIImage, ingredientsAndAmount: [Ingredient], cooking: String) {
        self.dishName = dishTitle
        self.dishImage = dishImage
        self.ingredientsAndAmount = ingredientsAndAmount
        self.cooking = cooking
    }
}
