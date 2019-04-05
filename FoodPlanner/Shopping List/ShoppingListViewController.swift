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
    var shoppingItems: [ShoppingItem] = []
    var ingredients = [Ingredient]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        getShoppingItemsFromFirestore()
        
        setColorOnButtonsAndLabels()
        
        shoppingListTableView.delegate = self
        shoppingListTableView.dataSource = self
        
        shoppingListTableView.reloadData()
        
        
    }
    
    func getShoppingItemsFromFirestore() {
        db.collection("shoppingItems").addSnapshotListener() {
                (snapshot, error) in
            
            if let error = error {
                print("Error getting document \(error)")
            } else {
                for document in snapshot!.documents {  //////
                    let item = ShoppingItem(snapshot: document)
                    
                    self.db.collection("shoppingItems").document(item.itemId!).collection("ingredient").getDocuments() {  ///////
                        (snapshot, error) in
                        
                        if let error = error {
                            print("Error getting document \(error)")
                        } else if let snapshot = snapshot {
                            
                            for document in snapshot.documents {
                                let ing = Ingredient(snapshot: document)
                                //let item = ShoppingItem(snapshot: document)
                                let ingredient = Ingredient(ingredientsTitle: ing.ingredientsTitle, amount: ing.amount, unit: ing.unit)
                                self.ingredients.append(ingredient)
                                print(ingredient.ingredientsTitle)
                            }
                            print("\(self.ingredients.count) !!!!!!!!")
                        }
                    }  ////////
                    
                }  //////
            }
        }
    }
    
    func setColorOnButtonsAndLabels() {
        doneItemButton.tintColor = Theme.current.textColorForLabels
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10//ingredients.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingListCell", for: indexPath) as! ShoppingListTableViewCell
        
        //let ingredient = ingredients[indexPath.row]
        
        //cell.setIngredients(name: ingredient.ingredientsTitle, amount: ingredient.amount, unit: ingredient.unit)
        cell.setIngredients(name: "Tomat", amount: 3, unit: "St")
        cell.checkBox()
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            ingredients.remove(at: indexPath.row)
//
//            tableView.beginUpdates()
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            tableView.endUpdates()
//        }
//    }
    
    @IBAction func doneItemButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
