//
//  CompareDayWithWeeklyMenuViewController.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-20.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit
import Firebase

class CompareDayWithWeeklyMenuViewController: UIViewController {
    var db: Firestore!
    var weeklyMenu = [DishAndDate]()
    override func viewDidLoad() {
        super.viewDidLoad()
            db = Firestore.firestore()
        db.collection("weeklyMenu").addSnapshotListener() {
            (snapshot, error) in

            if let error = error {
                print("Error getting document \(error)")
            } else {
                for document in (snapshot?.documents)! {
//                    let menu = DishAndDate(snapshot: document)

//                    self.weeklyMenu.append(menu)
//
//                    if Date() == menu.date {
//                        print("Idag")
//                    } else {
//                        print("Funkar inte")
//                    }
                }
            }
        }
    }
}
