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
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet var itemButtons: [UIBarButtonItem]!
    
    
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
        getDishIdFromFirestore()
    }
    
    func getDishIdFromFirestore() {
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
            label.textColor = Theme.current.labelTextColorInShowDishController
            label.font = Theme.current.labelFontInShowDishController
        }
        
        dishName.font = Theme.current.dishNameLabelFontInShowDishController
        dishName.textColor = Theme.current.labelTextColorInShowDishController
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = Theme.current.colorForBorder.cgColor
        imageView.layer.borderWidth = 2
        cookingDescriptionTextView.layer.masksToBounds = true
        cookingDescriptionTextView.layer.borderColor = Theme.current.borderColorInTableViewAndTextViewInShowDishController.cgColor
        cookingDescriptionTextView.layer.borderWidth = 1
        cookingDescriptionTextView.layer.cornerRadius = 12
        cookingDescriptionTextView.font = Theme.current.textFontInTextViewInShowDishController
        cookingDescriptionTextView.textColor = Theme.current.textColorInTableViewAndTextViewInShowDishController
        cookingDescriptionTextView.backgroundColor = Theme.current.backgroundColorInTableViewAndTextViewInShowDishController
        tableView.backgroundColor = Theme.current.backgroundColorInTableViewAndTextViewInShowDishController
        tableView.layer.masksToBounds = true
        tableView.layer.borderColor = Theme.current.borderColorInTableViewAndTextViewInShowDishController.cgColor
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 12
        
        navigationBar.barTintColor = Theme.current.backgroundColorShowDishController
        view.backgroundColor = Theme.current.backgroundColorShowDishController
        
        for itemBtn in itemButtons {
            itemBtn.tintColor = Theme.current.navigationbarTextColor
        }
    }
    
    @IBAction func doneItemButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteRecipeItemButton(_ sender: UIBarButtonItem) {
        deleteRecipeAndDishImage()
        dismiss(animated: true, completion: nil)
    }
    
    func deleteRecipeAndDishImage() {
        // Deleting ingredients
        for id in ingredientsId { db.collection("dishes").document(dishId!).collection("ingredients").document(id).delete()
        }
        
        // Deleting dish
        db.collection("dishes").document(dishId!).delete()
        
        // Deleting image
        imageReference.child(dishId ?? "No dishId").delete { (error) in
            if let error = error {
                print("Error deleting image \(error)")
            } else {
                print("File deleted successfully")
            }
        }
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
            
            cell?.backgroundColor = Theme.current.backgroundColorInTableViewAndTextViewInShowDishController
            cell?.ingredientsNameLabel.font = Theme.current.textFontInTableViewInShowDishController
            cell?.ingredientsNameLabel.textColor = Theme.current.textColorInTableViewAndTextViewInShowDishController
            cell?.ingredientsNameLabel.text = title
            cell?.ingredientsAmountLabel.text = "\(amount) \(unit)"
            cell?.ingredientsAmountLabel.font = Theme.current.textFontInTableViewInShowDishController
            cell?.ingredientsAmountLabel.textColor = Theme.current.textColorInTableViewAndTextViewInShowDishController
        }
        return cell!
    }
}

