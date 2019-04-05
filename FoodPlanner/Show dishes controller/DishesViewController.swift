//
//  DishesViewController.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-06.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit
import Firebase

class DishesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        self.showDishTableView.reloadData()
    }
    
    @IBOutlet weak var showDishTableView: UITableView!
    
    private let segueId = "addDishSegue"
    private let showDishSegue = "showDishSegue"
    private var cellId: String = "dishesCellId"
    
    var db: Firestore!
    var dishes = Dishes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColorFontOnTextAndBackgroundColor()
        searchBarSetup()
        showDishTableView.tableFooterView = UIView(frame: .zero)
        showDishTableView.delegate = self
        showDishTableView.dataSource = self
        self.showDishTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        db = Firestore.firestore()
        getDishesFromFirestore()
        self.showDishTableView.reloadData()
    }
    
    func setColorFontOnTextAndBackgroundColor() {
        showDishTableView.backgroundColor = Theme.current.backgroundColorInDishesView
        view.backgroundColor = Theme.current.backgroundColorInDishesView
    }
    
    func searchBarSetup() {
        // Skapar sökbaren, sätter bredden till skärmbredden och en höjd på 70
        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width), height: 70))
        searchBar.barTintColor = Theme.current.colorForBorder
        let inputText = searchBar.value(forKey: "searchField") as? UITextField
        inputText?.font = UIFont(name: Theme.current.fontForLabels, size: 17)
        inputText?.textColor = Theme.current.textColorForLabels
        searchBar.showsScopeBar = true
        searchBar.delegate = self
        
        
        self.showDishTableView.tableHeaderView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            getDishesFromFirestore()
            dishes = Dishes()
        } else {
            filterSearcTableView(inputText: searchText)
        }
    }
    func filterSearcTableView(inputText: String) {
        dishes.dishes = dishes.dishes.filter({ (dish) -> Bool in
            return dish.dishName.lowercased().contains(inputText.lowercased())
        })
        self.showDishTableView.reloadData()
        
    }
    
    func getDishesFromFirestore() {
        db.collection("dishes").order(by: "dishName", descending: false).addSnapshotListener() {
            (querySnapshot, error) in
            
            if let error = error {
                print("Error getting document \(error)")
            } else {
                self.dishes.clear()
                
                for document in (querySnapshot?.documents)! {
                    let dish = Dish(snapshot: document)
                    self.db.collection("dishes").document(document.documentID).collection("ingredients").getDocuments(){
                        (querySnapshot, error) in
                        
                        for document in (querySnapshot?.documents)!{
                            let ing = Ingredient(snapshot: document)
                            
                            dish.add(ingredient: ing)
                        }
                    }
                    if self.dishes.add(dish: dish) == true {
                        
                    }
                }
                self.showDishTableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if let dish = dishes.dish(index: indexPath.row) {
            cell.textLabel?.text = dish.dishName
            
            let backgroundView = UIView()
            
            cell.textLabel?.textColor = Theme.current.textColorInTableViewInDishesView
            cell.textLabel?.font = Theme.current.textFontInTableViewInDishesView
            cell.backgroundColor = Theme.current.backgroundColorInDishesView
            cell.textLabel?.textAlignment = .center
            backgroundView.backgroundColor = UIColor.white
            cell.selectedBackgroundView = backgroundView
        }
        return cell
    }
    
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
            destVC.dishId = dish.dishID
        }
    }
}
