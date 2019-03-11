//
//  GetDate.swift
//  FoodPlaner
//
//  Created by Björn Åhström on 2019-03-11.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation

class GetDate: CustomStringConvertible {
    // Computed property
    var description: String {
        return dateFormatter.string(from: date)
    }
    
    var date: Date
    var content: String
    var dateFormatter = DateFormatter()
    
    init(date: Date, content: String) {
        self.date = date
        self.content = content
        dateFormatter.dateFormat = "EEE d/MM"
    }
    
}
