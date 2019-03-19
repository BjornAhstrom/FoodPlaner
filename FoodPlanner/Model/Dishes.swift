//
//  Dishes.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-05.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Dishes {
    private var dishes = [Dish]()
    
    init() {
        addMockDishes()
    }
    
    var count: Int {
        return dishes.count
    }
    
    func add(dish: Dish) {
        dishes.append(dish)
    }
    
    func dish(index: Int) -> Dish? {
        if index >= 0 && index <= dishes.count {
        return dishes[index]
        }
        return nil
    }
    
    func randomDish() -> Dish {
        for _ in 0...6 {
            let randomIndex = Int(arc4random_uniform(UInt32(dishes.count)))
        return dishes[randomIndex]
        }
        return dishes[0]
    }
    
    func addMockDishes() {
        let ingredients: [Ingredient] = [Ingredient(ingredientsTitle: "Tomat", amount: 2, unit: "ST")]
        let imageName = "Lasagne"
        let image = UIImage(named: imageName)
        
        let dish1 = Dish(dishTitle: "Pannkaka", dishImage: image!, ingredientsAndAmount: ingredients, cooking: "rör om")
        dishes.append(dish1)
//        
//        let dish2 = Dish(dishTitle: "Potatis och köttbullar", dishImage: image!, ingredientsAndAmount: ingredients, cooking: "rör om")
//        dishes.append(dish2)
//
//        let dish3 = Dish(dishTitle: "Lasagne", dishImage: image!, ingredientsAndAmount: ingredients, cooking: "rör om")
//        dishes.append(dish3)
//
//        let dish4 = Dish(dishTitle: "spaghetti carbonara", dishImage: image!, ingredientsAndAmount: ingredients, cooking: "rör om")
//        dishes.append(dish4)
//
//        let dish5 = Dish(dishTitle: "spaghetti med köttfärssås", dishImage: image!, ingredientsAndAmount: ingredients, cooking: "rör om")
//        dishes.append(dish5)
//
//        let dish6 = Dish(dishTitle: "Pizza", dishImage: image!, ingredientsAndAmount: ingredients, cooking: "rör om")
//        dishes.append(dish6)
//
//        let dish7 = Dish(dishTitle: "Korvstroganoff och ris", dishImage: image!, ingredientsAndAmount: ingredients, cooking: "rör om")
//        dishes.append(dish7)
//
//        let dish8 = Dish(dishTitle: "Kokt potatis med fläskfilé och sås", dishImage: image!, ingredientsAndAmount: ingredients, cooking: "rör om")
//        dishes.append(dish8)
//
//        let dish9 = Dish(dishTitle: "Potatis och köttbullar med sås", dishImage: image!, ingredientsAndAmount: ingredients, cooking: "rör om")
//        dishes.append(dish9)
//
//        let dish10 = Dish(dishTitle: "Potatismos och köttbullar med lingonslyt", dishImage: image!, ingredientsAndAmount: ingredients, cooking: "rör om")
//        dishes.append(dish10)
//
//        let dish11 = Dish(dishTitle: "Hamburgare", dishImage: image!, ingredientsAndAmount: ingredients, cooking: "rör om")
//        dishes.append(dish11)
//
//        let dish12 = Dish(dishTitle: "Pommes och grillkorv", dishImage: image!, ingredientsAndAmount: ingredients, cooking: "rör om")
//        dishes.append(dish12)
//
//        let dish13 = Dish(dishTitle: "Rotfruktssoppa", dishImage: image!, ingredientsAndAmount: ingredients, cooking: "rör om")
//        dishes.append(dish13)
//
//        let dish14 = Dish(dishTitle: "Minestronesoppa", dishImage: image!, ingredientsAndAmount: ingredients, cooking: "rör om")
//        dishes.append(dish14)
        
//        let sortedDishes = dishes.sorted {$0.dishName < $1.dishName}
    }
}
