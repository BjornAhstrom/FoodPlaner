//
//  SideMenuViewController.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-02-26.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButtonTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var shoppingListButton: UIButton!
    
    var buttons: [Button] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColorFontAndSizeOnButtonsAndLebels()
        buttons = createFourPredefinedButtons()
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setColorFontAndSizeOnButtonsAndLebels() {
        addButton.layer.cornerRadius = 10
        addButton.layer.backgroundColor = Theme.current.colorForButtons.cgColor
        addButton.setTitleColor(Theme.current.textColorForButtons, for: .normal)
        addButton.titleLabel?.font = UIFont(name: Theme.current.fontForButtons, size: 17)
        
        shoppingListButton.layer.cornerRadius = 20
        shoppingListButton.layer.backgroundColor = Theme.current.colorForButtons.cgColor
        shoppingListButton.setTitleColor(Theme.current.textColorForButtons, for: .normal)
        shoppingListButton.titleLabel?.font = UIFont(name: Theme.current.fontForButtons, size: 20)
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 2
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 4
    }
    
    @IBAction func addANewButton(_ sender: UIButton) {
        addANewButtonAndSetLabelText()
    }
    
    func addANewButtonAndSetLabelText() {
        if addButtonTextField.text! == "" {
            alertMessage(titel: "Your button most have a name")
        } else {
            buttons.append(Button(buttonTitle: addButtonTextField.text!))
            
            let indexPath = IndexPath(row: buttons.count-1, section: 0)
            tableView.beginUpdates()
            tableView.insertRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            addButtonTextField.text! = ""
            view.endEditing(true)  // Dismiss the keyboard
        }
    }
    
    func createFourPredefinedButtons() -> [Button] {
        var tempButtons: [Button] = []
        
        let button1 = Button(buttonTitle: "Mina recept")
        let button2 = Button(buttonTitle: "Mina recept från bilder")
        let button3 = Button(buttonTitle: "Mina webb recept")
        let button4 = Button(buttonTitle: "Veckans meny")
        let button5 = Button(buttonTitle: "Skapa en ny matsedel")
        
        tempButtons.append(button1)
        tempButtons.append(button2)
        tempButtons.append(button3)
        tempButtons.append(button4)
        tempButtons.append(button5)
        
        return tempButtons
    }
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let button = buttons[indexPath.row]
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell") as! ButtonCell
        
        cell.setButtonTile(title: button)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let destination = UIViewController() as? DishesViewController
        navigationController?.pushViewController(destination!, animated: true)
        
        switch indexPath.row {
        case 0: NotificationCenter.default.post(name: NSNotification.Name("addAndShowDish"), object: nil)
        case 1: print("1")
        case 2: print("2")
        case 3: NotificationCenter.default.post(name: NSNotification.Name("weeklyMenu"), object: nil)
        case 4: NotificationCenter.default.post(name: NSNotification.Name("selectRandomDishMenu"), object: nil)
        default: break
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("showSideMenu"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            buttons.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func alertMessage(titel: String) {
        let alert = UIAlertController(title: titel, message: "Pleace try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion:  nil)
    }
}
