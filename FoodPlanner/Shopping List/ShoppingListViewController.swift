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
        
        getWeeklyMenuFromFireStore()
        
        shoppingListTableView.delegate = self
        shoppingListTableView.dataSource = self
        shoppingListTableView.reloadData()
    }
    
    func setColorOnButtonsAndLabels() {
        doneItemButton.tintColor = Theme.current.textColorForLabels
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingListCell", for: indexPath) as! ShoppingListTableViewCell
        
        let ingredient = ingredients[indexPath.row]
        
        cell.setIngredients(name: ingredient.ingredientsTitle, amount: ingredient.amount, unit: ingredient.unit)
        cell.checkBox()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredients.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    @IBAction func doneItemButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func getIngredientsFromFirestore() {
        
        for id in weeklyMenuDishesID {
            
            db.collection("dishes").document(id).collection("ingredients").getDocuments() {
               (snapshot, error) in
                for document in snapshot!.documents {
                    let ingredient = Ingredient(snapshot: document)
                    
                    if let index = self.ingredients.firstIndex(of: ingredient) {
                       self.ingredients[index].amount += ingredient.amount
                        //self.ingredients[index].unit = ingredient.unit
                    } else {
                        self.ingredients.append(ingredient)
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
                self.getIngredientsFromFirestore()
            }
        }
    }
}
