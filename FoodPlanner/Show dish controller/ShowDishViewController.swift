//
//  SavedDishViewController.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-08.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit
import Firebase

class ShowDishViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private weak var dishName: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var cookingDescriptionTextView: UITextView!
    
    private var savedDishCell: String = "savedDishCell"
    private var DishesViewController: String = "DishesViewController"
    
    let db = Firestore.firestore()
    var dish: Dish?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        dishName.text = dish?.dishName
        imageView.image = dish?.dishImage
        
        cookingDescriptionTextView.text = dish?.cooking
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dish = dish {
            return (dish.ingredientsAndAmount.count)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: savedDishCell, for: indexPath) as? ShowDishTableViewCell
        
        if let ingredients = dish?.ingredientsAndAmount
        {
            let title = ingredients[indexPath.row].ingredientsTitle
            let amountI = ingredients[indexPath.row].amount
            let amountS = ingredients[indexPath.row].unit
            
            cell?.ingredientsNameLabel.text = title
            cell?.ingredientsAmountLabel.text = "\(amountI) \(amountS)"
        }
        return cell!
    }
    
    @IBAction func doneItemButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteRecipeItemButton(_ sender: UIBarButtonItem) {
        deleteRecipe()
        dismiss(animated: true, completion: nil)
    }
    
    func deleteRecipe() {
        db.collection("dishes").document((dish?.dishID)!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}

