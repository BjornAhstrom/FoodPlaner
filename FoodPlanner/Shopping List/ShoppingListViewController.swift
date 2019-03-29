//
//  ShoppingListViewController.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-21.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit
import Firebase

class ShoppingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var shoppingListTableView: UITableView!
    @IBOutlet weak var doneItemButton: UIBarButtonItem!
    
    var db: Firestore!
    var ingredients = [Ingredient]()
    var dishes: Dishes?
    var dishesID: [String] = []
    var weeklyMenuDishesID: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        setColorOnButtonsAndLabels()
        
        getDishesFromFirestore()
        
        shoppingListTableView.delegate = self
        shoppingListTableView.dataSource = self
        shoppingListTableView.reloadData()
    }
    
    func setColorOnButtonsAndLabels() {
        doneItemButton.tintColor = Theme.current.textColorForLabels
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dishes = dishes {
            return dishes.count
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingListCell", for: indexPath) as! ShoppingListTableViewCell
        
        let dish = dishes!.dish(index: indexPath.row)
        
        if let ingredient = dish?.ingredientsAndAmount {
            let name = ingredient[indexPath.row].ingredientsTitle
            let amount = ingredient[indexPath.row].amount
            let unit = ingredient[indexPath.row].unit
            cell.setIngredients(name: name, amount: amount, unit: unit)
        }
        
        return cell
    }
    
    @IBAction func doneItemButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func getDishesFromFirestore() {
        db.collection("dishes").addSnapshotListener() {
            (querySnapshot, error) in
            
            if let error = error {
                print("Error getting document \(error)")
            } else {
                //self.dishes.clear()
                
                for document in (querySnapshot?.documents)! {
                    let dish = Dish(snapshot: document)
                    self.db.collection("dishes").document(document.documentID).collection("ingredients").getDocuments(){
                        (querySnapshot, error) in
                        
                        for document in (querySnapshot?.documents)!{
                            let ing = Ingredient(snapshot: document)
                            
                            dish.add(ingredient: ing)
                        }
                    }
                    if self.dishes!.add(dish: dish) == true {
                        print("Saved")
                    } else {
                        print("Not saved")
                    }
                }
                self.shoppingListTableView.reloadData()
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
                    
                   self.weeklyMenuDishesID.append(weeklyMenu.idFromDish)
                }
            }
        }
    }
}
