//
//  Dish.swift
//  FoodPlaner
//
//  Created by Björn Åhström on 2019-03-03.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation
import UIKit

class Dish {
    var dishTitle: String
    var dishImage: UIImage
    var ingredients: [String] = []
    var cooking: String
    
    
    init(dishTitle: String, dishImage: UIImage, ingredients: [String], cooking: String) {
        self.dishTitle = dishTitle
        self.dishImage = dishImage
        self.ingredients = ingredients
        self.cooking = cooking
        
    }
}
