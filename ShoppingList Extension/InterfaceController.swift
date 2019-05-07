//
//  InterfaceController.swift
//  ShoppingList Extension
//
//  Created by Björn Åhström on 2019-04-25.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    @IBOutlet weak var shoppingList: WKInterfaceTable!
    
    let tableData = ["One", "Two", "Three", "Four", "Five", "Six"]
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        loadTableViewData()
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func loadTableViewData() {
        shoppingList.setNumberOfRows(tableData.count, withRowType: "RowController")
        
        for (index, rowModel) in tableData.enumerated() {
            
            if let rowController = shoppingList.rowController(at: index) as? ShoppingListeItems {
                rowController.shoppingItemsLabel.setText(rowModel)
            }
        }
    }

}
