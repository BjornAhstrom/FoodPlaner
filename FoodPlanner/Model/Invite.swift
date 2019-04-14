//
//  Invite.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-04-11.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation
import Firebase

class Invite {
    // var toUserId: String
    var fromUserId: String
    //var invite: Bool
    //var familyAccount: String
    
    init(fromUserId: String) {//, familyAcount: String) {
        self.fromUserId = fromUserId
      //  self.familyAccount = familyAcount
    }
    
    //    init(toUserId: String, fromUserName: String) {
    //
    //        self.toUserId = toUserId
    //        self.fromUserName = fromUserName
    //        self.invite = false
    //    }
    
    init(snapshot: QueryDocumentSnapshot) {
        let snapshotValue = snapshot.data() as [String : Any]
        
        //   toUserId = snapshotValue["toUserId"] as! String
        fromUserId = snapshotValue["fromUserName"] as! String
      //  familyAccount = snapshotValue["familyAccount"] as! String
        // invite = snapshotValue["invite"] as! Bool
    }
    
    func toAny() -> [String : Any] {
        return ["fromUserId": fromUserId] // "familyAccount": familyAccount]
    }
}
