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
    
    var foodMenu : [DishAndDate]?
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        getWeeklyMenuFromFireStore()
        
        foodMenuTableView.delegate = self
        foodMenuTableView.dataSource = self
    }
    
    
    func getWeeklyMenuFromFireStore() {
        db.collection("weeklyMenu").getDocuments() {
            (querySnapshot, error) in
            
            if let error = error {
                print("Error getting document \(error)")
            } else {
                guard let snapshot = querySnapshot else {
                    return
                }
                for document in snapshot.documents {
                    let weekMenu = DishAndDate(snapshot: document)
                    
                    self.foodMenu?.append(weekMenu)
                }
                self.foodMenuTableView.reloadData()
            }
        }
    }
        
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let menu = foodMenu {
            return menu.count
        }
        return 0
    }
        
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: finishedWeeklyFoodMenyCell, for: indexPath) as? FinishedWeeklyMenuTableViewCell
        
        if let menu = foodMenu {
            let foodAndDate = menu[indexPath.row]
            cell?.setDateOnLabel(date: foodAndDate.date)
            cell?.setFoodnameOnLabel(foodName: foodAndDate.dishName)
        }
        return cell!
    }
}
