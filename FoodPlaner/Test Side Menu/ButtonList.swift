//
//  ButtonList.swift
//  FoodPlaner
//
//  Created by Björn Åhström on 2019-03-01.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class ButtonList: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButtonTexField: UITextField!
    
    var buttons: [Button] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttons = creteArray()
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    @IBAction func addButtons(_ sender: UIButton) {
        insertNewButtonTitle()
    }
    
    func insertNewButtonTitle() {
        buttons.append(Button(buttonTitle: addButtonTexField.text!))
        
        let indexPath = IndexPath(row: buttons.count-1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
        addButtonTexField.text! = ""
        view.endEditing(true)  // Dissmis the keyboard
    }
    
    func creteArray() -> [Button] {
        var tempButtons: [Button] = []
        
        let button1 = Button(buttonTitle: "Veckans meny")
        let button2 = Button(buttonTitle: "Mina recept")
        let button3 = Button(buttonTitle: "Mina recept från bilder")
        let button4 = Button(buttonTitle: "Mina recept från webben")
        
        
        tempButtons.append(button1)
        tempButtons.append(button2)
        tempButtons.append(button3)
        tempButtons.append(button4)
        
        return tempButtons
    }
}

extension ButtonList: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let button = buttons[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell") as! ButtonCell
        
        cell.setButtonTile(title: button)
        
        return cell
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
}
