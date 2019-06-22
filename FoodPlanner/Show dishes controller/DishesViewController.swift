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
    @IBOutlet weak var showDishTableView: UITableView!
    
    private let segueId = "addDishSegue"
    private let showDishSegue = "showDishSegue"
    private var cellId: String = "dishesCellId"
    
    var db: Firestore!
    var auth: Auth!
    var userIdFromFamilyAccount: [String] = []
    var imageReference: StorageReference!
    let cache = NSCache<NSString, UIImage>()

    
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
        imageReference = Storage.storage().reference()
        auth = Auth.auth()
        getFamilyAccountFromFirestore()
        self.showDishTableView.reloadData()
        
        
        
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.barTintColor = UIColor.black.withAlphaComponent(0.0)
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
        
        
    }
    
    func setColorFontOnTextAndBackgroundColor() {
        showDishTableView.backgroundColor = Theme.current.backgroundColorInDishesView
        view.backgroundColor = Theme.current.backgroundColorInDishesView
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.showDishTableView.reloadData()
    }
    
    func searchBarSetup() {
        // Skapar sökbaren, sätter bredden till skärmbredden och en höjd på 70
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width), height: 70))
        searchBar.barTintColor = Theme.current.backgroundColorInDishesView
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
        Dishes.instance.clear()
        guard let userId = auth.currentUser?.uid else { return }
        
        db.collection("users").document(userId).getDocument() {
            (document, error) in
            
            if let error = error {
                print("Error getting document \(error)")
            } else {
                guard let doc = document else { return }
                
                guard let famAccountId = doc.data()?["familyAccount"] as? String else { return }
                
                self.userIdFromFamilyAccount = []
                self.db.collection("familyAccounts").document(famAccountId).collection("members").addSnapshotListener() {
                    (snapshot, error) in
                    
                    if let error = error {
                        print("Error getting document \(error)")
                    } else {
                        
                        guard let snapDoc = snapshot?.documents else { return }
                        for document in snapDoc {
                            self.userIdFromFamilyAccount.append(document.documentID)
                            print("!!!!!!!!!!! UserId \(self.userIdFromFamilyAccount)")
                        }
                        self.getDishesFromFirestore()
                    }
                }
            }
        }
    }
    
    func getDishesFromFirestore() {
        Dishes.instance.clear()
        for userID in userIdFromFamilyAccount {
            
            self.db.collection("users").document(userID).collection("dishes").order(by: "dishName", descending: false).addSnapshotListener() {
                (querySnapshot, error) in
                
                if let error = error {
                    print("Error getting document \(error)")
                } else {
                    guard let snapDoc = querySnapshot?.documentChanges else { return }
                    
                    for change in snapDoc {
                        switch change.type {
                        case .added:
                            
                            let dish = Dish(snapshot: change.document)
                            self.db.collection("users").document(userID).collection("dishes").document(change.document.documentID).collection("ingredients").addSnapshotListener() {
                                (querySnapshot, error) in
                                
                                guard let snapDoc = querySnapshot?.documents else { return }
                                
                                for document in snapDoc {
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
                                self.showDishTableView.reloadData()
                            }
                        default:
                            print("changed")
                        }
                    }
                }
            }
        }
    }
    
    func cellDishImageView(dishImage: UIImageView) {
        
        dishImage.layer.borderColor = UIColor.lightGray.cgColor
        dishImage.layer.borderWidth = 1
        dishImage.layer.masksToBounds = true
        dishImage.layer.cornerRadius = (dishImage.frame.width) / 2
        dishImage.clipsToBounds = true
        dishImage.layer.shadowColor = UIColor.black.cgColor
        dishImage.layer.shadowOpacity = 0.5
        dishImage.layer.shadowRadius = -2
        dishImage.layer.shadowOffset = CGSize(width: 1, height: 0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Dishes.instance.dishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? DishesTableViewCell else {
            fatalError("The deque cell is not an instace of DishesTableViewCell.")
        }
        
        if let dish = Dishes.instance.dish(index: indexPath.row) {
            
            for userId in userIdFromFamilyAccount {

                self.imageReference = Storage.storage().reference().child("usersImages").child(userId)

                cell.dishImage.downloadImageFromStorage(dishId: dish.dishID, imageReference: imageReference)
            }
            
            let backgroundView = UIView()
            cell.backgroundColor = Theme.current.backgroundColorInDishesView
            
            backgroundView.backgroundColor = UIColor.white
            cell.selectedBackgroundView = backgroundView
            
            cell.ingredientLabel?.textColor = Theme.current.textColorInTableViewInDishesView
            cell.ingredientLabel?.font = Theme.current.textFontInTableViewInDishesView
            cell.ingredientLabel.text = dish.dishName
            
            
            let rectShape = CAShapeLayer()

            rectShape.bounds = (cell.viewInTableView.frame)
            rectShape.position = (cell.viewInTableView.center)
            rectShape.path = UIBezierPath(roundedRect: (cell.viewInTableView.bounds), byRoundingCorners: [.bottomLeft, .topLeft], cornerRadii: CGSize(width: 50, height: 50)).cgPath
            cell.viewInTableView.layer.mask = rectShape
            cell.viewInTableView.layer.cornerRadius = 12
            
            cellDishImageView(dishImage: cell.dishImage)
            
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId {
            //            if let destVC = segue.destination as? CreateADishViewController {
            //                //destVC.dishes = Dishes.dish
            //            }
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
