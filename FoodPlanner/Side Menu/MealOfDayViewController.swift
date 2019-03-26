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
    
    var mealOfTheDayName: String = ""
    var mealOfTheDayID: String = ""
    var dateOfTheDay: String = ""
    
    var dishesID: [String] = []
    
    var db: Firestore!
    //var dishes = Dishes()
    //var foodMenu = [DishAndDate]()
    
    override func viewWillAppear(_ animated: Bool) {
        db = Firestore.firestore()
        getWeeklyMenuFromFireStore()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func recipeButton(_ sender: UIButton) {
        for dishID in dishesID {
            if dishID == mealOfTheDayID {
                db.collection("dishes").document(mealOfTheDayID)
            }
        }
    }
    
    func getDishesFromFirestore() {
        db.collection("dishes").getDocuments() {
            (querySnapshot, error) in
            
            if let error = error {
                print("Error getting document \(error)")
            } else {
                guard let snapshot = querySnapshot else {
                    return
                }
                for doucument in snapshot.documents {
                    let dish = Dish(snapshot: doucument)
                    self.dishesID.append(dish.dishID)
//                    if self.dishes.add(dish: dish) == true {
//                        print("Saved")
//                    }
                }
            }
        }
    }
    
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
                    //self.foodMenu.append(weeklyMenu)
                    
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
                print("Error")
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
    
}
