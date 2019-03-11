//
//  RandomWeeklyMenuViewController.swift
//  FoodPlaner
//
//  Created by Björn Åhström on 2019-03-11.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class RandomWeeklyMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var weeklyMenuTableView: UITableView!
    private let randomMenuCell: String = "randomMenyCell"
    let dishes = Dishes()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weeklyMenuTableView.dataSource = self
        weeklyMenuTableView.delegate = self
        
        for index in 0..<7 {
            let date = GetDate(date: Date(), content: "Test \(index)")
            dishes.addDate(dates: date)
            
            print("Test \(date)")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: randomMenuCell, for: indexPath) as? RandomWeeklyManuTableViewCell
        
       if let date = dishes.dates(index: indexPath.row) {
           cell?.setDateOnLabel(date: "\(date)")
        }
//
//        if let food = dishes.disch(index: indexPath.row) {
//            cell?.setFoodnameOnLabel(foodName: "\(food)")
//        }
        
        return cell!
    }
}
