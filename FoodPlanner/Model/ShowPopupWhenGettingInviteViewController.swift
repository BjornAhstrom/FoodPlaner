//
//  ShowPopupWhenGettingInviteViewController.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-04-15.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit
import Firebase

class ShowPopupWhenGettingInviteViewController: UIViewController {
    
    var invites: [Invite] = []
    var users: [User] = []
    var db: Firestore!
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        auth = Auth.auth()
        
        db.collection("users").document().collection("invites").addSnapshotListener() {
            (snapshot, error) in
            
            if let error = error {
                print("No users \(error)")
            } else {
                
                guard let snapDoc = snapshot?.documents else { return }
                
                for document in snapDoc {
                    let invite = Invite(snapshot: document)
                    self.invites.append(invite)
                    
                    let user = User(snapshot: document)
                    self.users.append(user)
                }
            }
        }
    }
    
    func ifUserGetAnInviteThenShowPopup() {
        guard let userId = auth.currentUser?.uid else { return }
        
        db.collection("users").document(userId).collection("invites").addSnapshotListener() {
            (snapshot, error) in
            
            if let error = error {
                print("No users \(error)")
            } else {
                
                guard let snapDoc = snapshot?.documents else { return }
                
                for document in snapDoc {
                    let invite = Invite(snapshot: document)
                    if invite.invite == true {
                        guard let nameFromUser = invite.fromUserName else { return }
                        self.accpetOrDeclineInvite(title: "You got an invite", message: "Do you accept the invite from \(nameFromUser)")
                    }
                }
            }
        }
    }
    
    func acceptInvite(invite: Invite) {
        guard let userId = self.auth.currentUser?.uid else { return }
        guard let name = self.auth.currentUser?.displayName else { return }
        guard let email = self.auth.currentUser?.email else { return }
        
        // 1. lägg till dig själv som medlem i familyaccountet som du är invitad till
        db.collection("familyAccounts").document(invite.fromUserId).collection("members").document(userId).setData(["name" : name])
        
        // 2. lägg till familyaccountet som du accpterar som ditt eget familyaccount
        db.collection("users").document(userId).setData(["name" : name, "email" : email, "familyAccount" : invite.fromUserId])
        
        // 3. radera inviten
        db.collection("users").document(userId).collection("invites").document(invite.fromUserId).delete()
        
    }
    
    func declineInvite(invite: Invite) {
        guard let userId = self.auth.currentUser?.uid else { return }
        
        // radera inviten
        db.collection("users").document(userId).collection("invites").document(invite.fromUserId).delete()
    }
    
    func accpetOrDeclineInvite(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Accept", style: .default) { (UIAlertAction) in
            guard let userId = self.auth.currentUser?.uid else { return }
            
            self.db.collection("users").document(userId).collection("invites").getDocuments() {
                (snapshot, error) in
                
                if let error = error {
                    print("No users \(error)")
                } else {
                    guard let snapDoc = snapshot?.documents else { return }
                    
                    for document in snapDoc {
                        let invite = Invite(snapshot: document)
                        self.invites.append(invite)
                    }
                    for invite in self.invites {
                        self.acceptInvite(invite: invite)
                    }
                }
            }
        })
        alert.addAction(UIAlertAction(title: "Decline", style: .default) { (UIAlertAction) in
            self.db.collection("users").getDocuments() {
                (snapshot, error) in
                
                if let error = error {
                    print("No users \(error)")
                } else {
                    
                    guard let snapDoc = snapshot?.documents else { return }
                    
                    for document in snapDoc {
                        let user = User(snapshot: document)
                        self.users.append(user)
                    }
                }
                
                for user in self.users {
                    let invite = Invite(fromUserId: user.userId, fromUserName: user.name )
                    self.declineInvite(invite: invite)
                }
            }
        })
        self.present(alert, animated: true, completion:  nil)
    }
}
