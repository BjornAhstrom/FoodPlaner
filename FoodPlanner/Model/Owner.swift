//
//  Owner.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-04-12.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation
import Firebase

class Owner {
    
    var accountName: String
    var owner: String
    
    init(accountName: String, owner: String) {
        self.accountName = accountName
        self.owner = owner
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        let snapshotValue = snapshot.data() as [String : Any]
        accountName = snapshotValue["accountName"] as! String
        owner = snapshotValue["owner"] as! String
    }
    
    func toAny() -> [String : Any] {
        return ["accountName": accountName, "owner": owner]
    }
    
}
