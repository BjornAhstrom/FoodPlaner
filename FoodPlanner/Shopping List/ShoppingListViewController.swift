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
    var auth: Auth!
    var shoppingItems: [ShoppingItem] = []
    var userIdFromFamilyAccount: [String] = []
    var ownerFamilyAccountId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        auth = Auth.auth()
        setColorOnButtonsAndLabels()
        
        getFamilyAccountFromFirestore()
        //getShoppingItemsFromFirestore()
        
        shoppingListTableView.delegate = self
        shoppingListTableView.dataSource = self
    }
    
    func getFamilyAccountFromFirestore() {
        guard let userId = auth.currentUser?.uid else { return }
        
        db.collection("users").document(userId).getDocument() {
            (document, error) in
            
            if let error = error {
                print("Error getting document \(error)")
            } else {
                guard let doc = document else { return }
                
                let famAccountId = doc.data()!["familyAccount"] as! String
                self.ownerFamilyAccountId = famAccountId
                
                self.userIdFromFamilyAccount = []
                self.db.collection("familyAccounts").document(famAccountId).collection("members").getDocuments() {
                    (snapshot, error) in
                    
                    
                    if let error = error {
                        print("Error getting document \(error)")
                    } else {
                        guard let snapDoc = snapshot?.documents else { return }
                        
                        for document in snapDoc {
                            //let user = User(snapshot: document)
                            
                            self.userIdFromFamilyAccount.append(document.documentID)
                        }
                        self.getShoppingItemsFromFirestore()
                    }
                }
            }
        }
    }
    
    func getShoppingItemsFromFirestore() {
        //        let uid = auth.currentUser
        //        guard let userId = uid?.uid else { return }
        
        //for userID in userIdFromFamilyAccount {
            
            db.collection("familyAccounts").document(self.ownerFamilyAccountId).collection("shoppingItems").addSnapshotListener() {
                (snapshot, error) in
                
                self.shoppingItems = []
                if let error = error {
                    self.alertMessage(titel: "Error", message: error.localizedDescription)
                    print("Error getting document \(error)")
                } else {
                    for document in snapshot!.documents {
                        let item = ShoppingItem(snapshot: document)
                        self.shoppingItems.append(item)
                    }
                }
                self.shoppingListTableView.reloadData()
            }
      //  }
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
        
        cell.setIngredients(name: item.ingredient.ingredientsTitle, amount: Int(item.ingredient.amount), unit: item.ingredient.unit)
        cell.setCheckBox(item.checkBox)
        cell.checkBox()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        let uid = auth.currentUser
//        guard let userId = uid?.uid else { return }
        
        if editingStyle == .delete {
            let itemId = shoppingItems[indexPath.row]
            shoppingItems.remove(at: indexPath.row)
            
            if let id = itemId.itemId {
                db.collection("familyAccounts").document(self.ownerFamilyAccountId).collection("shoppingItems").document(id).delete()
            }
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let uid = auth.currentUser
//        guard let userId = uid?.uid else { return }
        
        let item = shoppingItems[indexPath.row]
        
        item.checkBox = !item.checkBox
        if let id = item.itemId {
            db.collection("familyAccounts").document(self.ownerFamilyAccountId).collection("shoppingItems").document(id).setData(item.toAny())
        }
    }
    
    @IBAction func doneItemButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
