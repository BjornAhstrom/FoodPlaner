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
    var ingredient: Ingredient
    var checkBox: Bool = false
    var itemId: String?
    
    init(ingredient: Ingredient,checkBox: Bool) {  //
        self.ingredient = ingredient
        self.checkBox = checkBox
        itemId = ""
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        let snapshotValue = snapshot.data() as [String : Any]
        
        ingredient = Ingredient(dictinary: snapshotValue["ingredient"] as! [String : Any])
        checkBox = snapshotValue["checkBox"] as! Bool
        itemId = snapshot.documentID
    }
    
    func toAny() -> [String : Any] {
        return ["ingredient" : ingredient.toAny(), "checkBox" : checkBox]
    }
    
}
