//
//  SavedMealsAndDatesFromUser.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-15.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation

class DishAndDate {
    var dish: Dish
    var date: Date
    
    init(dish: Dish, date: Date) {
        self.dish = dish
        self.date = date
    }
}
