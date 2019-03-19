//
//  Dish.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-03.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Dish {
    var dishName: String
    var dishImage: UIImage = UIImage(named: "Lasagne")!
    var ingredientsAndAmount: [Ingredient] = []
    var cooking: String
    
    
    init(dishTitle: String, dishImage: UIImage, ingredientsAndAmount: [Ingredient], cooking: String) {
        self.dishName = dishTitle
        self.dishImage = dishImage
        self.ingredientsAndAmount = ingredientsAndAmount
        self.cooking = cooking
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        let snapshotValue = snapshot.data() as [String : Any]
            dishName = snapshotValue["dishName"] as! String
            cooking = snapshotValue["cooking"] as! String
        //dishImage = snapshotValue["dishImage"] as! UIImage
    }
    
    func toAny() -> [String : Any] {
        return ["dishName" : dishName, "cooking" : cooking]
    }
}
