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
    var toUserId: String
    var fromUserName: String
    var invite: Bool
    
    init(toUserId: String, fromUserName: String, invite: Bool) {
        
        self.toUserId = toUserId
        self.fromUserName = fromUserName
        self.invite = invite
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        let snapshotValue = snapshot.data() as [String : Any]
        
        toUserId = snapshotValue["toUserId"] as! String
        fromUserName = snapshotValue["fromUserName"] as! String
        invite = snapshotValue["invite"] as! Bool
    }
    
    func toAny() -> [String : Any] {
        return ["toUserId": toUserId, "fromUserName": fromUserName, "invite": invite]
    }
}
