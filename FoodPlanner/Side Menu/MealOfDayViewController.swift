//
//  ViewNextToTheSidMenuViewController.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-03.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit
import Firebase

class MealOfDayViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var fooodImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var recipeButton: UIButton!
    
    private let goToDish = "goToDish"
    
    var mealOfTheDayName: String = ""
    var mealOfTheDayID: String = ""
    var dateOfTheDay: String = ""
    
    var dishesID: [String] = []
    
    var db: Firestore!
    var dishes = Dishes()
    
    override func viewWillAppear(_ animated: Bool) {
        db = Firestore.firestore()
        getWeeklyMenuFromFireStore()
        getDishesIdFromFirestore()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Hämtar maträtter och sparar deras id i en array (dishesID).
    func getDishesIdFromFirestore() {
        db.collection("dishes").getDocuments() {
            (querySnapshot, error) in
            
            if let error = error {
                print("Error getting document \(error)")
            } else {
                guard let snapshot = querySnapshot else {
                    return
                }
                for document in snapshot.documents {
                    let dish = Dish(snapshot: document)
                    self.dishesID.append(dish.dishID)
                    self.db.collection("dishes").document(document.documentID).collection("ingredients").getDocuments(){
                        (querySnapshot, error) in
                        
                        for document in (querySnapshot?.documents)!{
                            let ing = Ingredient(snapshot: document)
                            
                            dish.add(ingredient: ing)
                        }
                    }
                    if self.dishes.add(dish: dish) == true {
                    }
                }
            }
        }
    }
    
    // Hämtar data från veckomenyn för att sedan jämföra dagens datum med datum i veckomenyn och visa rätt maträtt,
    // om menyn inte har en maträtt då ska selectRandomDishController visas
    func getWeeklyMenuFromFireStore() {
        db.collection("weeklyMenu").getDocuments() {
            (querySnapshot, error) in
            
            if let error = error {
                print("Error getting document \(error)")
            } else {
                guard let snapshot = querySnapshot else {
                    return
                }
                
                for document in snapshot.documents {
                    let weeklyMenu = DishAndDate(snapshot: document)
                    
                    print("Datum från veckomenyn \(weeklyMenu.date), Dagens datum \(Date())")
                    
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .long
                    let dateToString = dateFormatter.string(from: date)
                    
                    let dateFromDish = weeklyMenu.date
                    let dateFormatterDish = DateFormatter()
                    dateFormatterDish.dateStyle = .long
                    let dateFromDishToString = dateFormatterDish.string(from: dateFromDish)
                    
                    print("\(dateToString) == \(dateFromDishToString)")
                    
                    if dateToString == dateFromDishToString {
                        self.mealOfTheDayName = (weeklyMenu.dishName)
                        self.mealOfTheDayID = (weeklyMenu.idFromDish)
                        print("Test dish \(self.mealOfTheDayName) and dishID \(self.mealOfTheDayID)")
                        print("Saved")
                    } else {
                        print("Error getting saved")
                    }
                }
            }
            print("Meal Of The Day \(self.mealOfTheDayName) \(self.mealOfTheDayID)")
            self.foodNameLabel.text = self.mealOfTheDayName
            
            let date1 = Date()
            let dateFormatter1 = DateFormatter()
            dateFormatter1.locale = NSLocale(localeIdentifier: "sv_SE") as Locale
            dateFormatter1.dateFormat = "EEEE dd/MM"
            let outputDate = dateFormatter1.string(from: date1)
            
            self.dateOfTheDay = outputDate
            
            self.dateLabel.text = self.dateOfTheDay
            
            if self.mealOfTheDayName == "" {
                self.goToSelectRandomDish()
            } else {
                print("We have a dish")
            }
        }
    }
    
    func goToSelectRandomDish() {
        if let selectRandomDish = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:     "SelectRandomWeekId") as? SelectRandomDishesViewController {
            
            let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.crossDissolve
            selectRandomDish.modalTransitionStyle = modalStyle
            self.present(selectRandomDish, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == goToDish {
            let destVC = segue.destination as? ShowDishViewController
            
            for dish in dishes.dishes  { // Funkar inte
                //let dish = dishes.dish(index: i)
                if mealOfTheDayID == dish.dishID {
                    
                    destVC!.dish = dish
                    
                    destVC!.dishId = dish.dishID
                    
                    print("Success")
                } else {
                    //alertMessage(titel: "No dish recipe")
                }
            }
        }
    }
    
    func alertMessage(titel: String) {
        let alert = UIAlertController(title: titel, message: "Pleace try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion:  nil)
    }
}
