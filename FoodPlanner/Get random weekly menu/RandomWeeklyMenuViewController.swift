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
    @IBOutlet weak var weeklyMenuTableView: UITableView?
    @IBOutlet weak var saveMenuButton: UIButton?
    
    private let randomMenuCell: String = "randomMenyCell"
    private let showWeeklyFoodMenuSegue = "showWeeklyFoodMenuSegue"
    
    var db: Firestore?
    var auth: Auth?
    
    var weeklyMenu = [DishAndDate?]()
    var ingredients: [Ingredient] = []
    var shoppingItems: [ShoppingItem] = []
    var selectedDateFromUser: Date!
    var getNumberOfDishesFromUser: Int = 0
    var userIdFromFamilyAccount: [String] = []
    var ownerFamilyAccountId: String = ""
    var currentDishesId: [String] = []
    
    var dishId: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        auth = Auth.auth()
        
        setFontAndColorsOnButton()
        weeklyMenuTableView?.dataSource = self
        weeklyMenuTableView?.delegate = self
        
        self.weeklyMenuTableView?.reloadData()
        
        getFamilyAccountFromFirestore()
    }
    
    func getFamilyAccountFromFirestore() {
        guard let userId = auth?.currentUser?.uid else { return }
        
        db?.collection("users").document(userId).getDocument() {
            (document, error) in
            
            if let error = error {
                print("Error getting document \(error)")
            } else {
                guard let doc = document else { return }
                
                guard let famAccountId = doc.data()?["familyAccount"] as? String else { return }
                self.ownerFamilyAccountId = famAccountId
                
                self.userIdFromFamilyAccount = []
                self.db?.collection("familyAccounts").document(famAccountId).collection("members").getDocuments() {
                    (snapshot, error) in
                    
                    if let error = error {
                        print("Error getting document \(error)")
                    } else {
                        guard let snapDoc = snapshot?.documents else { return }
                        
                        for document in snapDoc {
                            //let user = User(snapshot: document)
                            
                            self.userIdFromFamilyAccount.append(document.documentID)
                        }
                        self.createWeeklyMenu(count: self.getNumberOfDishesFromUser)
                    }
                }
            }
        }
    }
    
    // Ska göras: Om användaren väljer 2 maträtter då ska det kollas om det finns 2 gånger 3 maträtter, för det ska inte kunna bli samma maträtter som föregående vecka
    func createWeeklyMenu(count: Int) {
        if Dishes.instance.dishes.count == 1 {
            self.alertMessage(titel: "\(NSLocalizedString("oneDishTitle", comment: ""))", message: "\(NSLocalizedString("oneDishMessage1", comment: "")) \(Dishes.instance.dishes.count) \(NSLocalizedString("oneDishMessage2", comment: "")) \(Dishes.instance.dishes.count) \(NSLocalizedString("oneDishMessage3", comment: ""))")
        }
        else if count > Dishes.instance.dishes.count {
            self.alertMessage(titel: "\(NSLocalizedString("tooFewDishesTitle", comment: ""))", message: "\(NSLocalizedString("tooFewDishesMessage1", comment: "")) \(Dishes.instance.dishes.count) \(NSLocalizedString("tooFewDishesMessage2", comment: "")) \(Dishes.instance.dishes.count) \(NSLocalizedString("tooFewDishesMessage3", comment: ""))")
        }
        
        let calendar = Calendar.current
        let date = calendar.startOfDay(for: selectedDateFromUser)
        
        let weekleyDishes = Dishes.instance.randomDishes(count: count)
        
        let delta = Int(round( 7.0 / Double(count)))
        var index = 0
        
        for dish in weekleyDishes {
            guard let newDate = calendar.date(byAdding: .day, value: index, to: date) else { return }
            
            let foodAndDate = DishAndDate(dishName: dish.dishName, date: newDate, idFromDish: dish.dishID)
            dishId.append(dish.dishID)
            self.db?.collection("familyAccounts").document(self.ownerFamilyAccountId).collection("weeklyMenu").addDocument(data: foodAndDate.toAny())
            
            self.weeklyMenu.append(foodAndDate)
            index += delta
        }
        
        self.weeklyMenu = self.weeklyMenu.sorted(by: {$0?.date.compare($1?.date ?? Date()) == .orderedAscending})
        
        for userID in userIdFromFamilyAccount {
            for id in dishId {
                self.db?.collection("users").document(userID).collection("dishes").document(id).collection("ingredients").addSnapshotListener() {
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
                            
                            self.db?.collection("familyAccounts").document(self.ownerFamilyAccountId).collection("shoppingItems").addDocument(data: items.toAny())
                        }
                    }
                }
            }
        }
        self.weeklyMenuTableView?.reloadData()
    }
    
    @IBAction func saveWeeklyMenu(_ sender: UIButton) {
    }
    
    func setFontAndColorsOnButton() {
        saveMenuButton?.layer.borderColor = Theme.current.colorForBorder.cgColor
        saveMenuButton?.layer.borderWidth = 2
        saveMenuButton?.layer.cornerRadius = 15
        saveMenuButton?.titleLabel?.font = UIFont(name: Theme.current.fontForButtons, size: 20)
        saveMenuButton?.setTitleColor(Theme.current.textColor, for: .normal)
        view.backgroundColor = Theme.current.backgroundColorRandomWeeklyMenuController
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: randomMenuCell, for: indexPath) as? RandomWeeklyManuTableViewCell else {
            fatalError("The dequeued cell is not an instance of RandomWeeklyManuTableViewCell.")
        }
        
        let foodAndDate = weeklyMenu[indexPath.row]
        
        cell.setDateOnLabel(date: foodAndDate?.date ?? Date())
        cell.setFoodnameOnLabel(foodName: foodAndDate?.dishName ?? "No Dish")
        
        //        cell.setDateOnLabel(date: Date())
        //        cell.setFoodnameOnLabel(foodName: "TestRätt")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            weeklyMenu.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}
