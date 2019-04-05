//
//  MainViewController.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-02-27.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var mainView: UIView!
    
    private let addAndShowDish = "addAndShowDish"
    private let selectRandomDishMenu = "selectRandomDishMenu"
    private let weeklyMenu = "weeklyMenu"
    private let shoppingList = "shoppingList"
    private let addAndShowDishSegue = "addAndShowDishSegue"
    private let showSelectedRandomDishesSegue = "showSelectedRandomDishesSegue"
    private let weeklyMenuSegue = "weeklyMenuSegue"
    private let shoppingListSegue = "shoppingListSegue"
    private let showSideMenu = "showSideMenu"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(showDishList), name: NSNotification.Name( addAndShowDish), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToSelectRandomDishView), name: NSNotification.Name( selectRandomDishMenu), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(goToWeeklyMenu), name: NSNotification.Name( weeklyMenu), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(goToShoppingList), name: NSNotification.Name(shoppingList), object: nil)
        
    }
    
    @objc func showDishList() {
        performSegue(withIdentifier: addAndShowDishSegue, sender: nil)
    }
    
    @objc func goToSelectRandomDishView() {
        performSegue(withIdentifier: showSelectedRandomDishesSegue, sender: nil)
    }
    
    @objc func goToWeeklyMenu() {
        performSegue(withIdentifier: weeklyMenuSegue, sender: nil)
    }
    
    @objc func goToShoppingList() {
        performSegue(withIdentifier: shoppingListSegue, sender: nil)
    }
    
    @IBAction func moreTappedButton() {
        NotificationCenter.default.post(name: NSNotification.Name(showSideMenu), object: nil)
    }
    
}

extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
