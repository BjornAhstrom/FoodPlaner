//
//  WeeklyFoodMenuViewController.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-15.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit
import Firebase

class WeeklyFoodMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var foodMenuTableView: UITableView!
    
    private let finishedWeeklyFoodMenyCell = "finishedWeeklyFoodMenyCell"
    
    var foodMenu = [DishAndDate]()
    var dishes = Dishes()
    var db: Firestore!
    var auth: Auth!
    var userIdFromFamilyAccount: [String] = []
    var ownerFamilyAccountId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        auth = Auth.auth()
        setColorAndFontonBackgroundAndText()
        
        foodMenuTableView.delegate = self
        foodMenuTableView.dataSource = self
        
        getFamilyAccountFromFirestore()
        //getWeeklyMenuFromFireStore()
    }
    
    func setColorAndFontonBackgroundAndText() {
        view.backgroundColor = Theme.current.backgrondColorFinishedWeeklyMenuController
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
                            print("!!!!!!!!!!!!!!!!!!!!!\(document.documentID)")
                        }
                        self.getWeeklyMenuFromFireStore()
                    }
                }
            }
        }
    }
    
    func getWeeklyMenuFromFireStore() {
//        let uid = auth.currentUser
//        guard let userId = uid?.uid else { return }
        
        db.collection("familyAccounts").document(self.ownerFamilyAccountId).collection("weeklyMenu").getDocuments() {
            (querySnapshot, error) in
            
            if let error = error {
                print("Error getting document \(error)")
            } else {
                guard let snapshot = querySnapshot else {
                    return
                }
                for document in snapshot.documents {
                    let weeklyMenu = DishAndDate(snapshot: document)
                    
                    self.foodMenu.append(weeklyMenu)
                }
                self.foodMenuTableView.reloadData()
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodMenu.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: finishedWeeklyFoodMenyCell, for: indexPath) as? FinishedWeeklyMenuTableViewCell
        self.foodMenu = self.foodMenu.sorted(by: {$1.date.compare($0.date) == .orderedDescending})
        let dish = foodMenu[indexPath.row]
        
        cell?.setDateOnLabel(date: dish.date)
        cell?.setFoodnameOnLabel(foodName: dish.dishName)
        
        return cell!
    }
}
