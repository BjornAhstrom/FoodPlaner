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
    @IBOutlet weak var closeButton: UIButton!
    
    private let finishedWeeklyFoodMenyCell = "finishedWeeklyFoodMenyCell"
    var test: Bool = true
    
    var foodMenu : [DishAndDate]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton.isHidden = test
        foodMenuTableView.delegate = self
        foodMenuTableView.dataSource = self
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
            cell?.setFoodnameOnLabel(foodName: foodAndDate.dish.dishName)
        }
        return cell!
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        
    }
}
