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
    var dishName: String
    var date: Date
    var idFromDish: String
    var weeklyMenuID: String
    
    init(dishName: String, date: Date, idFromDish: String) {
        self.dishName = dishName
        self.date = date
        self.idFromDish = idFromDish
        weeklyMenuID = ""
    }
    
    init(snapshot: QueryDocumentSnapshot ) {
        let snapshotValue = snapshot.data() as [String : Any]
        dishName = snapshotValue["dishName"] as! String
        date = (snapshotValue["date"] as! Timestamp).dateValue()
        idFromDish = snapshotValue["idFromDish"] as! String
        weeklyMenuID = snapshot.documentID
    }
    
    func toAny() -> [String : Any] {
        return ["dishName": dishName, "date": date, "idFromDish": idFromDish]
    }
}
