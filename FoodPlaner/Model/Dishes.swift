//
//  Dishes.swift
//  FoodPlaner
//
//  Created by Björn Åhström on 2019-03-05.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation
import UIKit

class Dishes {
    private var dish = [Dish]()
    private var date = [GetDate]()
    
    var countDate: Int {
        return date.count
    }
    
    var count: Int {
        return dish.count
    }
    
    func addDate(dates: GetDate) {
        date.append(dates)
    }
    
    func dates(index: Int) -> GetDate? {
        if index >= 0 && index <= date.count {
            return date[index]
        }
        return nil
    }
    
    func add(dishes: Dish) {
        dish.append(dishes)
    }
    
    func disch(index: Int) -> Dish? {
        if index >= 0 && index <= dish.count {
        return dish[index]
        }
        return nil
    }
}
