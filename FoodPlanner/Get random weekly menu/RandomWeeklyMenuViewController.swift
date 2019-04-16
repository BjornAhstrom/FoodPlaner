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
    var auth: Auth!
    let dishes = Dishes()
    var foodMenu = [DishAndDate]()
    var ingredients: [Ingredient] = []
    var shoppingItems: [ShoppingItem] = []
    var selectedDateFromUser: Date!
    var getNumberOfDishesFromUser: Int!
    var userIdFromFamilyAccount: [String] = []
    var ownerFamilyAccountId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        auth = Auth.auth()
        
        setFontAndColorsOnButton()
        weeklyMenuTableView.dataSource = self
        weeklyMenuTableView.delegate = self
        
        self.weeklyMenuTableView.reloadData()
        
        getFamilyAccountFromFirestore()
        //getRandomDishesFromFirestore(count: getNumberOfDishesFromUser)
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
                        self.getRandomDishesFromFirestore(count: self.getNumberOfDishesFromUser)
                    }
                }
            }
        }
    }
    
    
    func getRandomDishesFromFirestore(count: Int) {
//        let uid = auth.currentUser
//        guard let userId = uid?.uid else { return }
        
        for userID in userIdFromFamilyAccount {
            print("!!!!!!!!!!!!!!!!!!!!!\(ownerFamilyAccountId)")
            let calendar = Calendar.current
            let date = calendar.startOfDay(for: selectedDateFromUser)
            
            db.collection("users").document(userID).collection("dishes").getDocuments() {
                (querySnapshot, error) in
                
                if let error = error {
                    print("Error getting document \(error)")
                } else {
                    guard let snapshot = querySnapshot else {
                        return
                    }
                    
                    let delta = Int(round( 7.0 / Double(count)))
                    var index = 0
                    while self.dishes.count < count {
                        let randomIndex = Int.random(in: 0..<snapshot.documents.count)
                        let randomDishSnapshot = snapshot.documents[randomIndex]
                        
                        let randomDish = Dish(snapshot: randomDishSnapshot)
                        
                        if self.dishes.add(dish: randomDish) {
                            
                            let newDate = calendar.date(byAdding: .day, value: index, to: date)!
                            
                            let foodAndDate = DishAndDate(dishName: randomDish.dishName, date: newDate, idFromDish: randomDish.dishID)
                            
                            self.foodMenu.append(foodAndDate)
                            
                            self.foodMenu = self.foodMenu.sorted(by: {$0.date.compare($1.date) == .orderedAscending}) // Ändra tillbaka till Descending och $1.date.compare($0.date) om det inte funkar
                            
                            index += delta
                            self.db.collection("familyAccounts").document(self.ownerFamilyAccountId).collection("weeklyMenu").addDocument(data: foodAndDate.toAny())
                            
                            self.db.collection("users").document(userID).collection("dishes").document(randomDish.dishID).collection("ingredients").getDocuments() {
                                (querySnapshot, error) in
                                
                                if let error = error {
                                    print("Error getting document \(error)")
                                } else {
                                    guard let snapshot = querySnapshot else {
                                        return
                                    }
                                    for document in snapshot.documents {
                                        let ing = Ingredient(snapshot: document)
                                        
                                        let items = ShoppingItem(ingredient: ing, checkBox: false)
                                        self.shoppingItems.append(items)
                                        
                                        self.db.collection("familyAccounts").document(self.ownerFamilyAccountId).collection("shoppingItems").addDocument(data: items.toAny())
                                    }
                                }
                            }
                            
                        }
                    }
                    self.weeklyMenuTableView.reloadData()
                }
            }
        }
    }
    
    
    @IBAction func saveWeeklyMenu(_ sender: UIButton) {
    }
    
    func setFontAndColorsOnButton() {
        saveMenuButton.layer.borderColor = Theme.current.colorForBorder.cgColor
        saveMenuButton.layer.borderWidth = 2
        saveMenuButton.layer.cornerRadius = 15
        saveMenuButton.titleLabel?.font = UIFont(name: Theme.current.fontForButtons, size: 20)
        saveMenuButton.setTitleColor(Theme.current.textColor, for: .normal)
        view.backgroundColor = Theme.current.backgroundColorRandomWeeklyMenuController
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
