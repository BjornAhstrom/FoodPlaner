//
//  MainViewController.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-02-27.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit
import Foundation

class MainViewController: UIViewController {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var hamburgerMenuButton: UIBarButtonItem!
    @IBOutlet weak var shoppingListMenuButton: UIBarButtonItem!
    
    private let addAndShowDish = "addAndShowDish"
    private let selectRandomDishMenu = "selectRandomDishMenu"
    private let weeklyMenu = "weeklyMenu"
    private let shoppingList = "shoppingList"
    private let addAndShowDishSegue = "addAndShowDishSegue"
    private let showSelectedRandomDishesSegue = "showSelectedRandomDishesSegue"
    private let weeklyMenuSegue = "weeklyMenuSegue"
    private let shoppingListSegue = "shoppingListSegue"
    private let showSideMenu = "showSideMenu"
    private var settingsSegueId = "settingsSegue"
    private var goToSettingsId = "settingsController"
    private var ownCreatedViewSegueId = "ownCreatedViewSegue"
    private var ownCreatedViewId = "ownCreatedViewId"
    private var myRecipesFromPicturesSegueId = "myRecipesFromPicturessegueId"
    private var myRecipesFromPictureId = "myRecipesFromPictureId"
    private var myWebRecipesSegueId = "myWebRecipesSegueId"
    private var myWebRecipesId = "myWebRecipesId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hamburgerMenuButton.image = UIImage(named: "HamburgerMenuIcon")
        shoppingListMenuButton.image = UIImage(named: "cartMenuIcon")
        
        NotificationCenter.default.addObserver(self, selector: #selector(showDishList), name: NSNotification.Name( addAndShowDish), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToSelectRandomDishView), name: NSNotification.Name( selectRandomDishMenu), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(goToWeeklyMenu), name: NSNotification.Name( weeklyMenu), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(goToShoppingList), name: NSNotification.Name(shoppingList), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToSettings), name: NSNotification.Name(goToSettingsId), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToOwnCreatedView), name: NSNotification.Name(ownCreatedViewId), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToMyRecipesFromPictures), name: NSNotification.Name(myRecipesFromPictureId), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToMyWebRecipes), name: NSNotification.Name(myWebRecipesId), object: nil)
        
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
    
    @objc func goToSettings() {
        performSegue(withIdentifier: settingsSegueId, sender: nil)
    }
    
    @objc func goToOwnCreatedView() {
        performSegue(withIdentifier: ownCreatedViewSegueId, sender: nil)
    }
    
    @objc func goToMyRecipesFromPictures() {
        performSegue(withIdentifier: myRecipesFromPicturesSegueId, sender: nil)
    }
    
    @objc func goToMyWebRecipes() {
        performSegue(withIdentifier: myWebRecipesSegueId, sender: nil)
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
