//
//  Ingredients.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-07.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Ingredient : Equatable {
    var ingredientsTitle: String
    var amount: Int = 0
    var unit: String
    var ingredientID: String
    
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.ingredientsTitle == rhs.ingredientsTitle
        
    }
    
    init(ingredientsTitle: String, amount: Int, unit: String) {
        self.ingredientsTitle = ingredientsTitle
        self.amount = amount
        self.unit = unit
        ingredientID = ""
    }
    
    convenience init(snapshot: QueryDocumentSnapshot) {
        let snapshotValue = snapshot.data() as [String : Any]
        self.init(dictinary: snapshotValue)
        ingredientID = snapshot.documentID

    }
    
    init(dictinary: [String: Any]) {
        ingredientsTitle = dictinary["ingredientName"] as! String
        amount = dictinary["amount"] as! Int
        unit = dictinary["unit"] as! String
        ingredientID = ""
    }
    
    
    func toAny() -> [String : Any] {
        return ["ingredientName" : ingredientsTitle, "unit" : unit, "amount" : amount]
    }
    
}
