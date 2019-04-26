//
//  Dishes.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-05.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation
import UIKit


// Dishes.dishes -> Dishes.instance.dishes
class Dishes {
   
    private init() {}
    static let instance = Dishes()
    
    var dishes = [Dish]()
    
    var count: Int {
        return dishes.count
    }
    
    func add(dish: Dish) -> Bool{
        if dishes.contains(dish) {
            return false
        }
        
        dishes.append(dish)
        return true
    }
    
    func clear() {
       dishes = []
    }
    
    func dish(index: Int) -> Dish? {
        if index >= 0 && index <= dishes.count && !dishes.isEmpty {
            return dishes[index]
        }
        return nil
    }
    
    // Tror inte denna funktion behövs. Ta bort?
    func randomDish() -> Dish {
        for _ in 0...6 {
            let randomIndex = Int(arc4random_uniform(UInt32(dishes.count)))
            return dishes[randomIndex]
        }
        return dishes[0]
    }
    
    func randomDishes(count: Int) -> [Dish] {
        // Kollar så att det finns tillräckligt med maträtter. Om det inte finns det då får användaren ut dem maträtterna som finns
        var randomMeals: [Dish] = []
        if count > dishes.count {
            randomMeals = dishes
            return randomMeals
        } else {
            
            // slumpar ut maträtter
            while(randomMeals.count < count ) {
                let randomIndex = Int(arc4random_uniform(UInt32(dishes.count)))
                let random = dishes[randomIndex]
                
                // Jämför så att det inte blir samma maträtt mer än en gång, om det finns minst dubbelt så många maträtter än vad anvädaren vill ha ut i sin veckomeny
                if (!randomMeals.contains(random)) {
                    randomMeals.append(random)
                }
            }
        }
        return randomMeals
    }
}
