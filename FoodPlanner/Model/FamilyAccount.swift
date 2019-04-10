//
//  FamilyAccount.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-04-09.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation
import Firebase

class FamilyAccount {
    var familyName: String
    var familyAccountId: String
    
    init(familyName: String) {
        self.familyName = familyName
        familyAccountId = ""
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        let snapshotValue = snapshot.data() as [String : Any]
        familyName = snapshotValue["familyName"] as! String
        familyAccountId = snapshot.documentID
    }
    
    func toAny() -> [String : Any] {
        return ["familyName": familyName]
    }
}
