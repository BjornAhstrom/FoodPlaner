//
//  SavedWeeklyMenu.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-14.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation
import UIKit

class SavedWeeklyMenu {
    var dishes: [String] = []
    var date: [Date] = []
    
    init(dishes: [String], date: [Date]) {
        self.dishes = dishes
        self.date = date
        
    }
}
