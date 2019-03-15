//
//  SelectRandomDishesViewController.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-14.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class SelectRandomDishesViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var phoneShakerImageView: UIImageView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var selectDaysPickerView: UIPickerView!
    
    private let userDefaultRowKey = "defaultPickerView"
    private let goToRandomWeeklyMenuSegue = "goToRandomWeeklyMenuSegue"
    private var numberOfDishes = (1...7).map{$0}
    
    var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectDaysPickerView.delegate = self
        selectDaysPickerView.dataSource = self
        
        datePickerView.minimumDate = Date()
        datePickerView.addTarget(self, action: #selector(storeSelectedDate), for: UIControl.Event.valueChanged)
        
        phoneShakerImageView.image = UIImage(named: "Phone.png")

        let defaultPickerRow  =  initialPickerRow()
        selectDaysPickerView.selectRow(defaultPickerRow, inComponent: 0, animated: false)
        pickerView(selectDaysPickerView, didSelectRow: defaultPickerRow, inComponent: 0)
        
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
            
        }
    }
}
