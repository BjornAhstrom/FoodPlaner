//
//  RandomWeeklyMenuViewController.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-11.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit
import Firebase

class RandomWeeklyMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var weeklyMenuTableView: UITableView!
    @IBOutlet weak var saveMenuButton: UIButton!
    
    private let randomMenuCell: String = "randomMenyCell"
    private let showWeeklyFoodMenuSegue = "showWeeklyFoodMenuSegue"
    
    var db: Firestore!
    let dishes = Dishes()
    var foodMenu = [DishAndDate]()
    var selectedDateFromUser = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        //getDishesFromFirestore()
        
        setFontAndColorsOnButton()
        weeklyMenuTableView.dataSource = self
        weeklyMenuTableView.delegate = self
        
       // getNextSevenDays()
        self.weeklyMenuTableView.reloadData()
        
        getRandomDishesFromFirestore(count: 3)
        
    }
    
    //    func getRandomDish() {
    //        let dishesRef  = db.collection("dishes")
    //
    //        let randomId = dishesRef.document().documentID
    //
    //            dishesRef.whereField(FieldPath.documentID(), isGreaterThan: randomId).limit(to: 1).getDocuments {
    //            (querySnapshot, error) in
    //
    //            if let snap = querySnapshot {
    //
    //                var dish: Dish?
    //                for document in snap.documents {
    //                    dish = Dish(snapshot: document)
    //                    print(dish?.dishName)
    //                }
    //            } else {
    //
    //                dishesRef.whereField(FieldPath.documentID(), isLessThan: randomId).limit(to: 1).getDocuments {
    //                    (querySnapshot, error) in
    //                        var dish: Dish?
    //                        for document in (querySnapshot?.documents)! {
    //                            dish = Dish(snapshot: document)
    //                            print(dish?.dishName)
    //                        }
    //
    //                    }
    //
    //                }
    //            }
    //    }
    
    func getRandomDishesFromFirestore(count: Int) {
        let calendar = Calendar.current
        let date = calendar.startOfDay(for: selectedDateFromUser)
        
        db.collection("dishes").getDocuments() {
            (querySnapshot, error) in
            
            if let error = error {
                print("Error getting document \(error)")
            } else {
                guard let snapshot = querySnapshot else {
                    return
                }
                
                print(self.dishes.count)
                
                var index = 0
                while self.dishes.count <= count {
                    let randomIndex = Int.random(in: 0..<snapshot.documents.count)
                    let randomDishSnapshot = snapshot.documents[randomIndex]
                    
                    let randomDish = Dish(snapshot: randomDishSnapshot)
                    
                    if self.dishes.add(dish: randomDish) {
                        
                        let newDate = calendar.date(byAdding: .day, value: index, to: date)!
                        let foodAndDate = DishAndDate(dishName: randomDish.dishName, date: newDate, idFromDish: randomDish.dishID)
                        self.foodMenu.append(foodAndDate)
                        print(randomDish.dishName)
                        index += 1
                        self.db.collection("weeklyMenu").addDocument(data: foodAndDate.toAny())
                    }
                   
                }
               self.weeklyMenuTableView.reloadData()
                //
                //                for document in (querySnapshot?.documents)! {
                //                    let dish = Dish(snapshot: document)
                //
                //                    self.db.collection("dishes").document(document.documentID).collection("ingredients").getDocuments(){
                //                        (querySnapshot, error) in
                //
                //                        for document in (querySnapshot?.documents)!{
                //                            let ing = Ingredient(snapshot: document)
                //
                //                            dish.add(ingredient: ing)
                //                        }
                //                    }
                //                    self.dishes.add(dish: dish)
                //                }
                //               // self.weeklyMenuTableView.reloadData()
            }
        }
    }
    
    @IBAction func saveWeeklyMenu(_ sender: UIButton) {
        
    }
    
//    func getNextSevenDays() {
//        let calendar = Calendar.current
//        let date = calendar.startOfDay(for: selectedDateFromUser)
//
//        for i in 0...6 {
//            let newDate = calendar.date(byAdding: .day, value: i, to: date)!
//            let dish = dishes.randomDish()
//            let foodAndDates = DishAndDate(dishName: dish.dishName, date: newDate, idFromDish: dish.dishID)
//            foodMenu.append(foodAndDates)
//            db.collection("weeklyMenu").addDocument(data: foodAndDates.toAny())
//        }
//    }
    
    func setFontAndColorsOnButton() {
        saveMenuButton.layer.borderColor = Theme.current.colorForBorder.cgColor
        saveMenuButton.layer.borderWidth = 2
        saveMenuButton.layer.cornerRadius = 15
        saveMenuButton.titleLabel?.font = UIFont(name: Theme.current.fontForButtons, size: 20)
        saveMenuButton.setTitleColor(Theme.current.textColor, for: .normal)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: randomMenuCell, for: indexPath) as? RandomWeeklyManuTableViewCell
        
        let foodAndDate = foodMenu[indexPath.row]

        
        cell?.setDateOnLabel(date: foodAndDate.date)
        cell?.setFoodnameOnLabel(foodName: foodAndDate.dishName)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            foodMenu.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}
