//
//  SettingsViewController.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-04-08.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var changeColorThemeLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var inviteEmailTextField: UITextField!
    @IBOutlet weak var sendInviteButton: UIButton!
    @IBOutlet weak var acceptInviteButton: UIButton!
    @IBOutlet weak var themeChangerSwitch: UISwitch!
    
    private var signInPageId: String = "signInPage"
    private var switchButtonId: String = "switchButton"
    private var ThemeId: String = "Theme"
    
    var db: Firestore!
    var auth: Auth!
    
    var users: [User] = []
    var invites: [Invite] = []
    var emails: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        auth = Auth.auth()
        self.hideKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ifUserGetAnInviteThenShowPopup()
        applayTheme()
        themeChangerSwitch.isOn = UserDefaults.standard.bool(forKey: switchButtonId)
    }
    
    @IBAction func themeChangerSwitch(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: switchButtonId)
        
        Theme.current = sender.isOn ? PinkTheme() : DarkTheme()
        UserDefaults.standard.set(sender.isOn, forKey: ThemeId)
        UserDefaults.standard.synchronize()
        applayTheme()
    }
    
    func applayTheme() {
        view.backgroundColor = Theme.current.backgroundColorForSettingsViewController
    }
    
    func signOut() {
        if let user = auth.currentUser {
            print(user.email!)
            do {
                try auth.signOut()
                print("Signing out succeeded")
            } catch {
                print("Error signing out")
            }
            sendUserToSignInView()
        }
    }
    
    @IBAction func sendInviteButton(_ sender: UIButton) {
        let sendInviteQueue = DispatchQueue(label: "sendInviteQueue", qos: .userInitiated)
        
        self.sendInvite()
        
        sendInviteQueue.asyncAfter(deadline: .now() + 1) {
            // self.inviteEmailTextField.text = ""
        }
    }
    
    func sendInvite() {
        db.collection("users").getDocuments() {
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
            
            guard let userId = self.auth.currentUser?.uid else { return }
            guard let name = self.auth.currentUser?.displayName else { return }
            
            for user in self.users {
                guard let inviteWithEmail = self.inviteEmailTextField.text else { return }
                if user.email == inviteWithEmail.lowercased() {
                    
                    let invite = Invite(fromUserId: userId, fromUserName: name)
                    
                    self.db.collection("users").document(user.userId).collection("invites").document(userId).setData(invite.toAny())
                    self.users = []
                }
            }
        }        //        self.inviteEmailTextField.text = ""
    }
    
    func acceptInvite(invite: Invite) {
        guard let userId = self.auth.currentUser?.uid else { return }
        guard let name = self.auth.currentUser?.displayName else { return }
//        guard let userNameFromInvite = invite.fromUserName else { return }
        guard let email = self.auth.currentUser?.email else { return }
        
        // 1. lägg till dig själv som medlem i familyaccountet som du är invitad till, och lägg til
        db.collection("familyAccounts").document(invite.fromUserId).collection("members").document(userId).setData(["name" : name])
        
//        db.collection("familyAccount").document(userId).collection("members").document(invite.fromUserId).setData(["name" : userNameFromInvite])
        
        // 2. lägg till familyaccountet om du accpterar som ditt eget familyaccount
        db.collection("users").document(userId).setData(["name" : name, "email" : email, "familyAccount" : invite.fromUserId])
        
        // 3. radera inviten
        db.collection("users").document(userId).collection("invites").document(invite.fromUserId).delete()
        
    }
    
    @IBAction func declineInviteButton(_ sender: UIButton) {
        db.collection("users").getDocuments() {
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
    }
    
    func declineInvite(invite: Invite) {
        guard let userId = self.auth.currentUser?.uid else { return }
        
        // radera inviten
        db.collection("users").document(userId).collection("invites").document(invite.fromUserId).delete()
    }
    
    @IBAction func endFamilyAccountButton(_ sender: UIButton) {
        db.collection("users").getDocuments() {
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
                let invite = Invite(fromUserId: user.familyAccount, fromUserName: user.name )
                self.endFamilyAccount(invite: invite)
            }
        }
    }
    
    func endFamilyAccount(invite: Invite) {
        guard let userId = self.auth.currentUser?.uid else { return }
        guard let name = self.auth.currentUser?.displayName else { return }
        guard let email = self.auth.currentUser?.email else { return }
        
        // Tar bort användaren från members i inbjudarens familyAccount
        db.collection("familyAccounts").document(invite.fromUserId).collection("members").document(userId).delete()
        
        // Sätter tillbaka familyAccoundId till användarens egna id igen
        db.collection("users").document(userId).setData(["name" : name, "email" : email, "familyAccount" : userId])
    }
    
    @IBAction func acceptInviteButton(_ sender: UIButton) {
        guard let userId = auth.currentUser?.uid else { return }
        
        db.collection("users").document(userId).collection("invites").getDocuments() {
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
    }
    
    func sendUserToSignInView() {
        if let containerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: signInPageId) as? signInViewController {
            
            let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.crossDissolve
            containerViewController.modalTransitionStyle = modalStyle
            self.present(containerViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func signOutButton(_ sender: UIButton) {
        signOut()
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
