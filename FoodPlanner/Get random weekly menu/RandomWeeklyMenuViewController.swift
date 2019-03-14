//
//  RandomWeeklyMenuViewController.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-11.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class RandomWeeklyMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var weeklyMenuTableView: UITableView!
    
    private let randomMenuCell: String = "randomMenyCell"
    
    let dishes = Dishes()
    var days = [Date]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weeklyMenuTableView.dataSource = self
        weeklyMenuTableView.delegate = self
        
        getNextSevenDays()
        
    }
    
    func getNextSevenDays() {
        var cal = Calendar.current
        cal.firstWeekday = 1
        let date = cal.startOfDay(for: Date())
        
        for i in 0...6 {
            let newDate = cal.date(byAdding: .day, value: i, to: date)!
            days.append(newDate)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: randomMenuCell, for: indexPath) as? RandomWeeklyManuTableViewCell
        let date = days[indexPath.row]
        let dish = dishes.randomDish()
        
        cell?.setDateOnLabel(date: date)
        cell?.setFoodnameOnLabel(foodName: dish.dishName)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            days.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}
