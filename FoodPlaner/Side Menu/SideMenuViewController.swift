//
//  SideMenuViewController.swift
//  FoodPlaner
//
//  Created by Björn Åhström on 2019-02-26.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButtonTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var shoppingListButton: UIButton!
    
    var names = [String]()
    var identities = [String]()
    var buttons: [Button] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColorFontAndSizeOnButtonsAndLebels()
        buttons = creteArray()
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        names = ["My recipes", "My picturerecipes", "My webrecipes", "Weekly menu"]
        identities = ["A", "B", "C", "D"]
    }
    
    
    @IBAction func testButton(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("showView"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("showSideMenu"), object: nil)
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
    
    @IBAction func addButtons(_ sender: UIButton) {
        insertNewButtonTitle()
    }
    
    func insertNewButtonTitle() {
        if addButtonTextField.text! == "" {
            alertMessage(titel: "Your button most have a name")
        } else {
            buttons.append(Button(buttonTitle: addButtonTextField.text!))
            
            let indexPath = IndexPath(row: buttons.count-1, section: 0)
            tableView.beginUpdates()
            tableView.insertRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            addButtonTextField.text! = ""
            view.endEditing(true)  // Dissmis the keyboard
        }
    }
    
    func creteArray() -> [Button] {
        var tempButtons: [Button] = []
        
        let button1 = Button(buttonTitle: "Veckans meny")
        let button2 = Button(buttonTitle: "Mina recept")
        let button3 = Button(buttonTitle: "Mina recept från bilder")
        let button4 = Button(buttonTitle: "Mina webb recept")
        
        tempButtons.append(button1)
        tempButtons.append(button2)
        tempButtons.append(button3)
        tempButtons.append(button4)
        
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
        
        let vcName = identities[indexPath.row]
        let viewController = storyboard?.instantiateViewController(withIdentifier: vcName)
        self.navigationController?.pushViewController(viewController!, animated: true)
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
