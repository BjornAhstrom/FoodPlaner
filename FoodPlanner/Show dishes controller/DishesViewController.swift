//
//  TestViewController.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-06.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit
import Firebase

class DishesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var showDishTableView: UITableView!
    
    private let segueId = "addDishSegue"
    private let showDishSegue = "showDishSegue"
    private var cellId: String = "dishesCellId"
    
    var db: Firestore!
    var dishes = Dishes()
    var dish = [Dish]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showDishTableView.tableFooterView = UIView(frame: .zero)
        showDishTableView.delegate = self
        showDishTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        db = Firestore.firestore()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if let dish = dishes.dish(index: indexPath.row) {
            cell.textLabel?.text = dish.dishName
        }
        
        let backgroundView = UIView()
        
        backgroundView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    //            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //                tableView.deselectRow(at: indexPath, animated: false)
    //
    //            }
    //
    //            func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    //                return true
    //            }
    //
    //            func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //                if editingStyle == .delete {
    //
    //
    //
    //
    //                    tableView.beginUpdates()
    //                    tableView.deleteRows(at: [indexPath], with: .automatic)
    //                    tableView.endUpdates()
    //                }
    //            }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId {
            if let destVC = segue.destination as? CreateADishViewController {
                destVC.dishes = dishes
            }
        }
        
        if segue.identifier == showDishSegue {
            guard let destVC = segue.destination as? ShowDishViewController else {
                print("destVC")
                return
            }
            guard  let cell = sender as? UITableViewCell else {
                print("cell")
                return
            }
            guard let indexPath = showDishTableView.indexPath(for: cell) else {
                print("indexPath")
                return
            }
            guard let dish = dishes.dish(index: indexPath.row) else {
                print("dish")
                return
            }
            destVC.dish = dish
        }
    }
}
