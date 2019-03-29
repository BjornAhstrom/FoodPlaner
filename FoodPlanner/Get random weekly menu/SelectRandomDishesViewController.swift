//
//  SelectRandomDishesViewController.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-14.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit
import Firebase

class SelectRandomDishesViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var phoneShakerImageView: UIImageView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var selectDaysPickerView: UIPickerView!
    @IBOutlet weak var randomDishesButton: UIButton!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var choosNumberOfDishesLabel: UILabel!
    
    private let userDefaultRowKey = "defaultPickerView"
    private let goToRandomWeeklyMenuSegue = "goToRandomWeeklyMenuSegue"
    private var numberOfDishes = (1...7).map{$0}
    
    var db: Firestore!
    var selectedDate = Date()
    var foodMenu: DishAndDate?
    var getNumberOfDishesFromUser = Int()
    
    override func viewWillAppear(_ animated: Bool) {
        //deleteWeeklyMenu()    // Fungerar inte
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        setFontAndColorOnButtonsAndViews()
        selectDaysPickerView.delegate = self
        selectDaysPickerView.dataSource = self
        
        datePickerView.minimumDate = Date()
        datePickerView.addTarget(self, action: #selector(storeSelectedDate), for: UIControl.Event.valueChanged)
        
        phoneShakerImageView.image = UIImage(named: "Phone.png")
        
        let defaultPickerRow  =  initialPickerRow()
        selectDaysPickerView.selectRow(defaultPickerRow, inComponent: 0, animated: false)
        pickerView(selectDaysPickerView, didSelectRow: defaultPickerRow, inComponent: 0)
    }
    
    func setFontAndColorOnButtonsAndViews() {
        randomDishesButton.layer.borderColor = Theme.current.colorForBorder.cgColor
        randomDishesButton.layer.borderWidth = 2
        randomDishesButton.layer.cornerRadius = 15
        randomDishesButton.titleLabel?.font = UIFont(name: Theme.current.fontForButtons, size: 20)
        randomDishesButton.setTitleColor(Theme.current.textColor, for: .normal)
        datePickerView.setValue(Theme.current.textColor, forKey: "textColor")
        startDateLabel.textColor = Theme.current.textColor
        startDateLabel.font = UIFont(name: Theme.current.fontForLabels, size: 24)
        choosNumberOfDishesLabel.textColor = Theme.current.textColor
        choosNumberOfDishesLabel.font = UIFont(name: Theme.current.fontForLabels, size: 20)
    }
    
    func deleteWeeklyMenu() {
        if let menuId = foodMenu?.weeklyMenuID {
            while menuId.count >= 0 {
                db.collection("weeklyMenu").document(menuId).delete() { error in
                    if let error = error {
                        print("Error removing document: \(error)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
            }
        }
    }
    
    @objc func storeSelectedDate() {
        self.selectedDate = self.datePickerView.date
    }
    
    func initialPickerRow() -> Int{
        let savedRow = UserDefaults.standard.object(forKey: userDefaultRowKey) as? Int
        
        if let row = savedRow {
            return row
        } else {
            return selectDaysPickerView.numberOfRows(inComponent: 0)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberOfDishes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let selectedDishes = numberOfDishes[row]
        
        return "\(selectedDishes)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        savedSelectedRow(row: row)
        getNumberOfDishesFromUser = (row + 1)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: Theme.current.fontForLabels, size: 24)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = "\(numberOfDishes[row])"
        pickerLabel?.textColor = Theme.current.textColor
        return pickerLabel!
    }
    
    func savedSelectedRow(row: Int) {
        
        let defaults = UserDefaults.standard
        defaults.set(row, forKey: userDefaultRowKey)
        defaults.synchronize()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == goToRandomWeeklyMenuSegue {
            let destination = segue.destination as? RandomWeeklyMenuViewController
            destination?.selectedDateFromUser = selectedDate
            destination?.getNumberOfDishesFromUser = getNumberOfDishesFromUser
        }
    }
}
