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
    var email: String
    var userId: String
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
        userId = ""
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        let snapshotValue = snapshot.data() as [String : Any]
        name = snapshotValue["name"] as! String
        email = snapshotValue["email"] as! String
        userId = snapshot.documentID
    }
    
    func toAny() -> [String : Any] {
        return ["name": name, "email": email]
    }
}
