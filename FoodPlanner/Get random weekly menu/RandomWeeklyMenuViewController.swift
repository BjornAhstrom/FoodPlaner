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
    let dishes = Dishes()
    var foodMenu = [DishAndDate]()
    var selectedDateFromUser = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        setFontAndColorsOnButton()
        weeklyMenuTableView.dataSource = self
        weeklyMenuTableView.delegate = self
        
        getNextSevenDays()
        self.weeklyMenuTableView.reloadData()
    }
    
    func getNextSevenDays() {
        let calendar = Calendar.current
        let date = calendar.startOfDay(for: selectedDateFromUser)
        
        for i in 0...6 {
            let newDate = calendar.date(byAdding: .day, value: i, to: date)!
            let dish = dishes.randomDish()
            let foodAndDates = DishAndDate(dish: dish, date: newDate, idFromDish: dish.dishID)
            foodMenu.append(foodAndDates)
            db.collection("weeklyMenu").addDocument(data: foodAndDates.toAny())
        }
    }
    
    func setFontAndColorsOnButton() {
        saveMenuButton.layer.borderColor = Theme.current.colorForBorder.cgColor
        saveMenuButton.layer.borderWidth = 2
        saveMenuButton.layer.cornerRadius = 15
        saveMenuButton.titleLabel?.font = UIFont(name: Theme.current.fontForButtons, size: 20)
        saveMenuButton.setTitleColor(Theme.current.textColor, for: .normal)
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
        cell?.setFoodnameOnLabel(foodName: foodAndDate.dish.dishName)
        
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
