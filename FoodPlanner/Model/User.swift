//
//  User.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-04-09.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation
import Firebase

class User {
    var name: String
    var userId: String
    
    init(name: String) {
        self.name = name
        userId = ""
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        let snapshotValue = snapshot.data() as [String : Any]
        name = snapshotValue["name"] as! String
        userId = snapshot.documentID
    }
    
    func toAny() -> [String : Any] {
        return ["name": name]
    }
}
