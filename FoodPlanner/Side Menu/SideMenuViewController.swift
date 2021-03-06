//
//  SideMenuViewController.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-02-26.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit
import Firebase

class SideMenuViewController: UIViewController {
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCategoriesTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var shoppingListButton: UIButton!
    @IBOutlet var sidebarButtons: [UIButton]!
    @IBOutlet weak var settingsButton: UIButton!
    
    private let addAndShowDish = "addAndShowDish"
    private let weeklyMenu = "weeklyMenu"
    private let selectRandomDishMenu = "selectRandomDishMenu"
    private let showSideMenu = "showSideMenu"
    private let shoppingList = "shoppingList"
    private var goToSettingsId = "settingsController"
    private let buttonCellId = "buttonCell"
    private var ownCreatedViewId = "ownCreatedViewId"
    private var myRecipesFromPictureId = "myRecipesFromPictureId"
    private var myWebRecipesId = "myWebRecipesId"
    
    var db: Firestore!
    var auth: Auth!
    var buttons: [Button] = []
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        auth = Auth.auth()
        
        setColorFontAndSizeOnButtonsAndLebels()
        buttons = createFourPredefinedButtons()
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let userId = auth.currentUser?.uid else { return }
        
        db.collection("users").getDocuments() {
            (snapshot, error) in
            
            if let error = error {
                print("Error getting document \(error)")
            } else {
                guard let snapDoc = snapshot?.documents else { return }
                
                for document in snapDoc {
                    let name = User(snapshot: document)
                    self.users.append(name)
                }
            }
            for name in self.users {
                if name.userId == userId {
                    self.accountNameLabel.text = name.name
                }
            }
        }
    }
    
    func setColorFontAndSizeOnButtonsAndLebels() {
        accountNameLabel.textColor = Theme.current.accountNameTextColorLabelSideMenu
        accountNameLabel.font = Theme.current.accountNameFontLabelSideMenu
        
        for btn in sidebarButtons {
            btn.layer.cornerRadius = 20
            btn.layer.borderColor = Theme.current.sideBarButtonBorderColor.cgColor
            btn.layer.borderWidth = 1
            btn.backgroundColor = Theme.current.colorForButtons
            btn.setTitleColor(Theme.current.sideBarButtonTextColor, for: .normal)
            btn.titleLabel?.font = Theme.current.sideBarButtonFont
        }
        
        addButton.titleLabel?.font = Theme.current.sideBarAddButtonFont
        addButton.layer.cornerRadius = 20
        addButton.layer.borderColor = Theme.current.sideBarButtonBorderColor.cgColor
        addButton.layer.borderWidth = 1
        addButton.backgroundColor = Theme.current.colorForButtons
        addButton.setTitleColor(Theme.current.sideBarButtonTextColor, for: .normal)
        
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 2
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 4
        view.layer.backgroundColor = Theme.current.backgroundColorSideMenu.cgColor
        tableView.backgroundColor = Theme.current.backgroundColorSideMenu
        
        addCategoriesTextField.layer.masksToBounds = true
        addCategoriesTextField.layer.cornerRadius = 12
        addCategoriesTextField.layer.borderWidth = 1
        addCategoriesTextField.layer.borderColor = Theme.current.sideBarButtonBorderColor.cgColor
        
        settingsButton.setTitleColor(Theme.current.sideBarButtonTextColor, for: .normal)
    }
    
    @IBAction func addANewButton(_ sender: UIButton) {
        addANewButtonAndSetLabelText()
        view.endEditing(true)
    }
    
    @IBAction func settingsButton(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(goToSettingsId), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(showSideMenu), object: nil)
    }
    
    func addANewButtonAndSetLabelText() {
        guard let addCategoriesText = addCategoriesTextField.text else { return }
        
        if addCategoriesText == "" {
            self.alertMessage(titel: "\(NSLocalizedString("alertTitle1", comment: ""))", message: "\(NSLocalizedString("alertMessage_TryAgain", comment: ""))")
        } else {
            buttons.append(Button(buttonTitle: addCategoriesText))
            
            let indexPath = IndexPath(row: buttons.count-1, section: 0)
            tableView.beginUpdates()
            tableView.insertRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            addCategoriesTextField.text = ""
            //self.hideKeyboard()
        }
    }
    
    func createFourPredefinedButtons() -> [Button] {
        var tempButtons: [Button] = []
        
        let button1 = Button(buttonTitle: "\(NSLocalizedString("button1", comment: ""))")
        let button2 = Button(buttonTitle: "\(NSLocalizedString("button2", comment: ""))")
        let button3 = Button(buttonTitle: "\(NSLocalizedString("button3", comment: ""))")
        let button4 = Button(buttonTitle: "\(NSLocalizedString("button4", comment: ""))")
        let button5 = Button(buttonTitle: "\(NSLocalizedString("button5", comment: ""))")
        
        tempButtons.append(button1)
        tempButtons.append(button2)
        tempButtons.append(button3)
        tempButtons.append(button4)
        tempButtons.append(button5)
        
        return tempButtons
    }
    
    @IBAction func shoppingListButton(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(shoppingList), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(showSideMenu), object: nil)
    }
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let button = buttons[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: buttonCellId) as? ButtonCell
        
        cell?.setButtonTile(title: button)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        cell?.selectedBackgroundView = backgroundView
        cell?.backgroundColor = Theme.current.backgroundColorSideMenu
        
        return cell ?? cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        switch indexPath.row {
        case 0: NotificationCenter.default.post(name: NSNotification.Name(addAndShowDish), object: nil)
        case 1: NotificationCenter.default.post(name: NSNotification.Name(myRecipesFromPictureId), object: nil)
        case 2: NotificationCenter.default.post(name: NSNotification.Name(myWebRecipesId), object: nil)
        case 3: NotificationCenter.default.post(name: NSNotification.Name(weeklyMenu), object: nil)
        case 4: NotificationCenter.default.post(name: NSNotification.Name(weeklyMenu), object: nil)
        
            if Dishes.instance.dishes.count == 0 {
                self.alertMessage(titel: "\(NSLocalizedString("noRecipesTitle", comment: ""))", message: "\(NSLocalizedString("noRecipesMessage", comment: ""))")
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(selectRandomDishMenu), object: nil)
            }
        
        default:
            if indexPath.row >= 5 {
                NotificationCenter.default.post(name: NSNotification.Name(ownCreatedViewId), object: nil)
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(showSideMenu), object: nil)
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
