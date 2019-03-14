//
//  SelectRandomDishesViewController.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-14.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class SelectRandomDishesViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var shakePhoneImageView: UIImageView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var chooseDaysPickerView: UIPickerView!
    
    private let userDefaultRowKey = "defaultPickerView"
    private var numberOfDishes = (1...7).map{$0}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseDaysPickerView.delegate = self
        chooseDaysPickerView.dataSource = self

        let defaultPickerRow  =  initialPickerRow()
        chooseDaysPickerView.selectRow(defaultPickerRow, inComponent: 0, animated: false)
        pickerView(chooseDaysPickerView, didSelectRow: defaultPickerRow, inComponent: 0)
        
    }
    
    func initialPickerRow() -> Int{
        let savedRow = UserDefaults.standard.object(forKey: userDefaultRowKey) as? Int
        
        if let row = savedRow {
            return row
        } else {
            return chooseDaysPickerView.numberOfRows(inComponent: 0)
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
        saveSelectedRow(row: row)
    }
    
    func saveSelectedRow(row: Int) {
        
        let defaults = UserDefaults.standard
        defaults.set(row, forKey: userDefaultRowKey)
        defaults.synchronize()
    }
}
