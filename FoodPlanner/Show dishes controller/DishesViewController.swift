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
    var auth: Auth!
    //var dishes = Dishes.dishes
    var userIdFromFamilyAccount: [String] = []
    
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
        auth = Auth.auth()
        getFamilyAccountFromFirestore()
        // getDishesFromFirestore()
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
            //Dishes.dishes
        } else {
            filterSearcTableView(inputText: searchText)
        }
    }
    func filterSearcTableView(inputText: String) {
        Dishes.instance.dishes = Dishes.instance.dishes.filter({ (dish) -> Bool in
            return dish.dishName.lowercased().contains(inputText.lowercased())
        })
        self.showDishTableView.reloadData()
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
                        self.getDishesFromFirestore()
                    }
                }
            }
        }
    }
    
    func getDishesFromFirestore() {
        for userID in userIdFromFamilyAccount {
            
            self.db.collection("users").document(userID).collection("dishes").order(by: "dishName", descending: false).addSnapshotListener() {
                (querySnapshot, error) in
                
                if let error = error {
                    print("Error getting document \(error)")
                } else {
                    
                    for change in querySnapshot!.documentChanges {
                        switch change.type {
                        case .added:
                            
                            let dish = Dish(snapshot: change.document)
                            print("added \(dish.dishName)")
                            self.db.collection("users").document(userID).collection("dishes").document(change.document.documentID).collection("ingredients").getDocuments(){
                                (querySnapshot, error) in
                                
                                for document in (querySnapshot?.documents)!{
                                    let ing = Ingredient(snapshot: document)
                                    
                                    dish.add(ingredient: ing)
                                }
                                 _ = Dishes.instance.add(dish: dish)
                                 self.showDishTableView.reloadData()
                            }
                        case .removed:
                            
                            let dish = Dish(snapshot: change.document)
                        
                            // find dish in dishes and remove it
                            if let index =  Dishes.instance.dishes.index(of: dish) {
                                Dishes.instance.dishes.remove(at: index)
                                print("removed \(dish.dishName)")
                            }
                            
                                
                        default:
                            print("changed")
                        }
                    }
                }
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Dishes.instance.dishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if let dish = Dishes.instance.dish(index: indexPath.row) {
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
                //destVC.dishes = Dishes.dish
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
            guard let dish = Dishes.instance.dish(index: indexPath.row) else {
                print("dish")
                return
            }
            destVC.dish = dish
            destVC.dishId = dish.dishID
        }
    }
}
