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

class Dish: Equatable {
    
    
    var dishName: String
    var dishImageId: UIImage?
    var ingredientsAndAmount: [Ingredient] = []
    var cooking: String?
    var dishID: String
    var portions: Int = 0
    var meat: Bool = false
    var fish: Bool = false
    var bird: Bool = false
    var vego: Bool = false
    
    
    static func == (lhs: Dish, rhs: Dish) -> Bool {
        return lhs.dishID == rhs.dishID
    }
    
    
    init(dishTitle: String, dishImageId: UIImage, ingredientsAndAmount: [Ingredient], cooking: String, portions: Int, meat: Bool, fish: Bool, bird: Bool, vego: Bool) {
        self.dishName = dishTitle
        self.dishImageId = dishImageId
        self.ingredientsAndAmount = ingredientsAndAmount
        self.cooking = cooking
        self.portions = portions
        self.meat = meat
        self.fish = fish
        self.vego = vego
        dishID = ""
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        let snapshotValue = snapshot.data() as [String : Any]
        dishName = snapshotValue["dishName"] as! String
        cooking = snapshotValue["cooking"] as? String ?? ""
        portions = snapshotValue["portions"] as? Int ?? 0
        meat = snapshotValue["meat"] as? Bool ?? false
        fish = snapshotValue["fish"] as? Bool ?? false
        bird = snapshotValue["bird"] as? Bool ?? false
        vego = snapshotValue["vego"] as? Bool ?? false
        dishID = snapshot.documentID
    }
    
    func add(ingredient: Ingredient) {
        ingredientsAndAmount.append(ingredient)
    }
    
    func toAny() -> [String : Any] {
        return ["dishName": dishName, "cooking": cooking!, "portions": portions, "meat": meat, "fish": fish, "bird": bird, "vego": vego]
    }
}
