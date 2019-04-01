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
    @IBOutlet private var labels: [UILabel]!
    
    private var savedDishCell: String = "savedDishCell"
    private var DishesViewController: String = "DishesViewController"
    
    let db = Firestore.firestore()
    var dish: Dish?
    var dishId: String?
    var ingredientsId: [String] = []
    
    var imageReference: StorageReference {
        return Storage.storage().reference().child("dishImages")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setRadiusBorderColorAndFontOnLabelsViewsAndButtons()
        dishName.text = dish?.dishName
        
        cookingDescriptionTextView.text = dish?.cooking
        
        downloadImageFromStorage()
        
        db.collection("dishes").document(dishId!).collection("ingredients").getDocuments() {
            (snapshot, error) in
            if let error = error {
                print("Error getting document \(error)")
            } else {
                for ingId in snapshot!.documents {
                    let ingredientID = Ingredient(snapshot: ingId)
                    self.ingredientsId.append(ingredientID.ingredientID)
                }
            }
        }
    }
    
    func setRadiusBorderColorAndFontOnLabelsViewsAndButtons() {
        for label in labels {
            label.textColor = Theme.current.textColor
            label.font = UIFont(name: Theme.current.fontForLabels, size: 22)
        }
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = Theme.current.colorForBorder.cgColor
        imageView.layer.borderWidth = 2
        cookingDescriptionTextView.layer.masksToBounds = true
        cookingDescriptionTextView.layer.borderColor = Theme.current.colorForBorder.cgColor
        cookingDescriptionTextView.layer.borderWidth = 2
        cookingDescriptionTextView.layer.cornerRadius = 12
        cookingDescriptionTextView.textColor = Theme.current.textColorForLabels
        cookingDescriptionTextView.font = UIFont(name: Theme.current.fontForLabels, size: 18)
    }
    
    @IBAction func doneItemButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteRecipeItemButton(_ sender: UIBarButtonItem) {
        deleteRecipe()
        dismiss(animated: true, completion: nil)
    }
    
    func deleteRecipe() {
        for id in ingredientsId { db.collection("dishes").document(dishId!).collection("ingredients").document(id).delete()
            print("!!!!!!! \(id)")
        }
        
        db.collection("dishes").document(dishId!).delete()
    }
    
    func downloadImageFromStorage() {
        let downloadImageRef = imageReference.child(dishId ?? "No dishId")
        
        if downloadImageRef.name == dishId {
            let downloadTask = downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
                if let error = error {
                    print("Error downloading \(error)")
                } else {
                    if let data = data {
                        let image = UIImage(data: data)
                        self.imageView.image = image
                    }
                    print(error ?? "No error")
                }
            }
            downloadTask.observe(.progress) { (snapshot) in
                //print(snapshot.progress ?? "No more progress")
            }
            //            downloadTask.resume()
        }
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
            let amount = ingredients[indexPath.row].amount
            let unit = ingredients[indexPath.row].unit
            
            cell?.ingredientsNameLabel.text = title
            cell?.ingredientsAmountLabel.text = "\(amount) \(unit)"
        }
        
        return cell!
    }
}

