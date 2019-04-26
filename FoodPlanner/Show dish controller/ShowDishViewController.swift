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
    @IBOutlet weak var portionsLabel: UILabel!
    
    
    private var savedDishCell: String = "savedDishCell"
    private var DishesViewController: String = "DishesViewController"
    
    let db = Firestore.firestore()
    var auth: Auth!
    var dish: Dish?
    var dishId: String?
    var ingredientsId: [String] = []
    var userID: String = ""
    var userIdFromFamilyAccount: [String] = []
    var ownerFamilyAccountId: String = ""
    
    var imageReference: StorageReference!
//    var imageReference: StorageReference {
//        return Storage.storage().reference().child("usersImages").child(userID)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth = Auth.auth()
        imageReference = Storage.storage().reference()
        
        tableView.delegate = self
        tableView.dataSource = self
        setRadiusBorderColorAndFontOnLabelsViewsAndButtons()
        dishName.text = dish?.dishName ?? ""
        portionsLabel.text = "\(NSLocalizedString("portionsAmount", comment: "")) \(dish?.portions ?? 0)"
        
        cookingDescriptionTextView.text = dish?.cooking
        getFamilyAccountFromFirestore()
        //getDishIdFromFirestore()
        
        //downloadImageFromStorage()
    }
    
    func setRadiusBorderColorAndFontOnLabelsViewsAndButtons() {
        for label in labels {
            label.textColor = Theme.current.labelTextColorInShowDishController
            label.font = Theme.current.labelFontInShowDishController
        }
        
        portionsLabel.textColor = Theme.current.labelTextColorInShowDishController
        portionsLabel.font = Theme.current.portionsLabelFontInShowDishController
        dishName.font = Theme.current.dishNameLabelFontInShowDishController
        dishName.textColor = Theme.current.labelTextColorInShowDishController
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = Theme.current.borderColorInTableViewAndTextViewAndImageViewInShowDishController.cgColor
        imageView.layer.borderWidth = 1
        cookingDescriptionTextView.layer.masksToBounds = true
        cookingDescriptionTextView.layer.borderColor = Theme.current.borderColorInTableViewAndTextViewAndImageViewInShowDishController.cgColor
        cookingDescriptionTextView.layer.borderWidth = 1
        cookingDescriptionTextView.layer.cornerRadius = 12
        cookingDescriptionTextView.font = Theme.current.textFontInTextViewInShowDishController
        cookingDescriptionTextView.textColor = Theme.current.textColorInTableViewAndTextViewInShowDishController
        cookingDescriptionTextView.backgroundColor = Theme.current.backgroundColorInTableViewAndTextViewInShowDishController
        tableView.backgroundColor = Theme.current.backgroundColorInTableViewAndTextViewInShowDishController
        tableView.layer.masksToBounds = true
        tableView.layer.borderColor = Theme.current.borderColorInTableViewAndTextViewAndImageViewInShowDishController.cgColor
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
    
    func getFamilyAccountFromFirestore() {
        guard let userId = auth.currentUser?.uid else { return }
        
        db.collection("users").document(userId).addSnapshotListener() {
            (document, error) in
            
            if let error = error {
                print("Error getting document \(error)")
            } else {
                guard let doc = document else { return }
                
                guard let famAccountId = doc.data()?["familyAccount"] as? String else { return }
                self.ownerFamilyAccountId = famAccountId
                
                self.userIdFromFamilyAccount = []
                self.db.collection("familyAccounts").document(famAccountId).collection("members").addSnapshotListener() {
                    (snapshot, error) in
                    
                    if let error = error {
                        print("Error getting document \(error)")
                    } else {
                        guard let snapDoc = snapshot?.documents else { return }
                        
                        for document in snapDoc {
                            
                            self.userIdFromFamilyAccount.append(document.documentID)
                        }
                        self.getDishIdFromFirestore()
                    }
                }
            }
        }
    }
    
    func getDishIdFromFirestore() {
        let uid = auth.currentUser
        guard let userId = uid?.uid else { return }
        guard let dId = dishId else { return }
        userID = userId
        
        db.collection("users").document(userId).collection("dishes").document(dId).collection("ingredients").getDocuments() {
            (snapshot, error) in
            if let error = error {
                self.alertMessage(titel: "Error", message: error.localizedDescription)
            } else {
                guard let snapDoc = snapshot?.documents else { return }
                
                for ingId in snapDoc {
                    let ingredientID = Ingredient(snapshot: ingId)
                    self.ingredientsId.append(ingredientID.ingredientID)
                }
            }
            for usersId in self.userIdFromFamilyAccount {
                self.imageReference = Storage.storage().reference().child("usersImages").child(usersId)
                self.downloadImageFromStorage()
            }
        }
    }
    
    func downloadImageFromStorage() {
        let downloadImageRef = imageReference.child(dishId ?? "No dishId")
        
        if downloadImageRef.name == dishId {
            let downloadTask = downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
                if let error = error {
                    print("No image \(error)")
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
    
    func deleteRecipeAndDishImage() {
        let uid = auth.currentUser
        guard let userId = uid?.uid else { return }
        guard let dId = dishId else { return }
        
        // Deleting ingredients
        for id in ingredientsId { db.collection("users").document(userId).collection("dishes").document(dId).collection("ingredients").document(id).delete()
        }
        
        // Deleting dish
        db.collection("users").document(userId).collection("dishes").document(dId).delete()
        
        // Deleting image
        imageReference.child("usersImages").child(userId).child(dId).delete { (error) in
            if let error = error {
                self.alertMessage(titel: "Error", message: error.localizedDescription)
            } else {
                print("File deleted successfully")
            }
        }
        tableView.reloadData()
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
        return cell ?? cell!
    }
}

