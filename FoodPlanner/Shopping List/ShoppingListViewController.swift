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
        
        print("!!!!!!!!!!!!!!\(shoppingItems.count)")
        
        setColorOnButtonsAndLabels()
        
        shoppingListTableView.delegate = self
        shoppingListTableView.dataSource = self
    }
    
    func getShoppingItemsFromFirestore() {
        db.collection("shoppingItems").addSnapshotListener() {
            (snapshot, error) in
            
            self.shoppingItems = []
            if let error = error {
                print("Error getting document \(error)")
            } else {
                for document in snapshot!.documents {
                    let item = ShoppingItem(snapshot: document)
                    self.shoppingItems.append(item)
                    print(item.ingredient.ingredientsTitle)
                }
            }
            self.shoppingListTableView.reloadData()
        }
    }
    
    func setColorOnButtonsAndLabels() {
        doneItemButton.tintColor = Theme.current.textColorForLabels
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingItems.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingListCell", for: indexPath) as! ShoppingListTableViewCell
        
        let item = shoppingItems[indexPath.row]
        
        cell.setIngredients(name: item.ingredient.ingredientsTitle, amount: item.ingredient.amount, unit: item.ingredient.unit)
        
        cell.setCheckBox(item.checkBox)
        
        cell.checkBox()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shoppingItems.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
    
        let item = shoppingItems[indexPath.row]
        
        item.checkBox = !item.checkBox
        if let id = item.itemId {
            db.collection("shoppingItems").document(id).setData(item.toAny())
        }
    }
    

    
    
    @IBAction func doneItemButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
