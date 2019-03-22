//
//  ShoppingListViewController.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-21.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var shoppingListTableView: UITableView!
    @IBOutlet weak var doneItemButton: UIBarButtonItem!
    
    var ingredients = [Ingredient]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColorOnButtonsAndLabels()
        
        shoppingListTableView.delegate = self
        shoppingListTableView.dataSource = self
    }
    
    func setColorOnButtonsAndLabels() {
        doneItemButton.tintColor = Theme.current.textColorForLabels
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9 //ingredients.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingListCell", for: indexPath) as! ShoppingListTableViewCell
        cell.checkBox()
        cell.setIngredientsNameOnLabel(ingredientsName: "Ingredient")
        
        return cell
    }
    
    @IBAction func doneItemButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
