//
//  SavedMealsAndDatesFromUser.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-15.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation
import Firebase

class DishAndDate {
    var dish: Dish
    var date: Date
    var idFromDish: String
    var weeklyMenuID: String
    
    init(dish: Dish, date: Date, idFromDish: String) {
        self.dish = dish
        self.date = date
        self.idFromDish = idFromDish
        weeklyMenuID = ""
    }
    
    init(snapshot: QueryDocumentSnapshot ) {
        let snapshotValue = snapshot.data() as [String : Any]
        dish = snapshotValue["dishName"] as! Dish
        date = snapshotValue["date"] as! Date
        idFromDish = snapshotValue["id"] as! String
        weeklyMenuID = snapshot.documentID
    }
    
    func toAny() -> [String : Any] {
        return ["dishName": dish.dishName, "date": date, "idFromDish": idFromDish]
    }
}
