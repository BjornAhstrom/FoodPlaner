//
//  ShoppingItem.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-04-02.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit
import Firebase

class ShoppingItem {
    //var ingredient: Ingredient
    var checkBox: Bool = false
    var itemId: String?
    
    init(checkBox: Bool) {  //ingredient: Ingredient, 
        //self.ingredient = ingredient
        self.checkBox = checkBox
        itemId = ""
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        let snapshotValue = snapshot.data() as [String : Any]
        //ingredient = Ingredient(ingredientsTitle: "", amount: 1, unit: "")
        checkBox = snapshotValue["checkBox"] as! Bool
        itemId = snapshot.documentID
    }
    
    func toAny() -> [String : Any] {
        return ["checkBox" : checkBox] // "ingredient" : ingredient.toAny(),
    }
    
}
