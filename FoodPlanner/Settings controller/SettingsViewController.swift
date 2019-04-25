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
    @IBOutlet weak var changeThemeLabel: UILabel!
    @IBOutlet weak var sendInviteLabel: UILabel!
    @IBOutlet weak var endFamilyAccountLabel: UILabel!
    @IBOutlet weak var inviteEmailTextField: UITextField!
    @IBOutlet weak var themeChangerSwitch: UISwitch!
    @IBOutlet weak var sendInviteButton: UIButton!
    @IBOutlet weak var endFamilyAccountButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var labels: [UILabel]!

    
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
        setColorFontAndSizeOnLabelsAndButtons()
//        ifUserGetAnInviteThenShowPopup()
        applayTheme()
        themeChangerSwitch.isOn = UserDefaults.standard.bool(forKey: switchButtonId)
        
    }
    
    func setColorFontAndSizeOnLabelsAndButtons() {
        settingLabel.font = Theme.current.fontOnSettingLabelInSettingsViewController
        settingLabel.textColor = Theme.current.colorTextOnLabelsInSettingsViewController
        
        changeThemeLabel.font = Theme.current.fonOntLabelsInSettingsViewController
        changeThemeLabel.textColor = Theme.current.colorTextOnLabelsInSettingsViewController
        
        for label in labels {
            label.font = Theme.current.fonOntLabelsInSettingsViewController
            label.textColor = Theme.current.colorTextOnLabelsInSettingsViewController
        }
        
        for button in buttons {
            button.titleLabel?.font = Theme.current.fontOnButtonsInSettingsViewController
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 12
            button.layer.borderColor = Theme.current.borderCollorOnButtonsInSettingViewController.cgColor
            button.setTitleColor(Theme.current.collorOntextOnButtonsInSettingViewController, for: .normal)
        }
        
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
        navigationController?.navigationBar.barTintColor = Theme.current.backgroundColorForSettingsViewController
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
        self.sendInvite()
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
        }
        //self.inviteEmailTextField.text = ""
    }
    
//    func acceptInvite(invite: Invite) {
//        guard let userId = self.auth.currentUser?.uid else { return }
//        guard let name = self.auth.currentUser?.displayName else { return }
//        //guard let userNameFromInvite = invite.fromUserName else { return }
//        guard let email = self.auth.currentUser?.email else { return }
//
//        // 1. lägg till dig själv som medlem i familyaccountet som du är invitad till, och lägg til
//        db.collection("familyAccounts").document(invite.fromUserId).collection("members").document(userId).setData(["name" : name])
//
////        db.collection("familyAccount").document(userId).collection("members").document(invite.fromUserId).setData(["name" : userNameFromInvite])
//
//        // 2. lägg till familyaccountet om du accpterar som ditt eget familyaccount
//        db.collection("users").document(userId).setData(["name" : name, "email" : email, "familyAccount" : invite.fromUserId])
//
//        // Delete the invite from firestore
//        db.collection("users").document(userId).collection("invites").document(invite.fromUserId).delete()
//    }
    
//    @IBAction func declineInviteButton(_ sender: UIButton) {
//        db.collection("users").getDocuments() {
//            (snapshot, error) in
//
//            if let error = error {
//                print("No users \(error)")
//            } else {
//
//                guard let snapDoc = snapshot?.documents else { return }
//
//                for document in snapDoc {
//                    let user = User(snapshot: document)
//                    self.users.append(user)
//                }
//            }
//
//            for user in self.users {
//                let invite = Invite(fromUserId: user.userId, fromUserName: user.name )
//                self.declineInvite(invite: invite)
//            }
//        }
//    }
    
//    func declineInvite(invite: Invite) {
//        guard let userId = self.auth.currentUser?.uid else { return }
//
//        // radera inviten
//        db.collection("users").document(userId).collection("invites").document(invite.fromUserId).delete()
//    }
    
    @IBAction func endFamilyAccountButton(_ sender: UIButton) {
        guard let userId = self.auth.currentUser?.uid else { return }
        
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
                if invite.fromUserId != userId {
                    self.endFamilyAccount(invite: invite)
                }
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
        
        // Hämtar weeklyMenu och shoppingItems för att sedan ta bort veckomenyn och shoppingItems som användarna har gemensamt
//        db.collection("familyAccounts").document(invite.fromUserId).collection("shoppingItems").addSnapshotListener() {
//            (snapshot, error) in
//
//            if let error = error {
//                print("Error getting document \(error)")
//            } else {
//                guard let snapDoc = snapshot?.documents else { return }
//
//                for document in snapDoc {
//                    let items = ShoppingItem(snapshot: document)
//                    guard let id = items.itemId else { return }
//
//                    self.db.collection("familyAccounts").document(invite.fromUserId).collection("shoppingItems").document(id).delete()
//                    self.db.collection("familyAccounts").document(userId).collection("shoppingItems").document(id).delete()
//                }
//            }
//        }
        
//        db.collection("familyAccounts").document(invite.fromUserId).collection("weeklyMenu").addSnapshotListener() {
//            (snapshot, error) in
//            
//            if let error = error {
//                print("Error getting document \(error)")
//            } else {
//                guard let snapDoc = snapshot?.documents else { return }
//                
//                for document in snapDoc {
//                    let weeklyMenu = DishAndDate(snapshot: document)
//                    self.db.collection("familyAccounts").document(invite.fromUserId).collection("weeklyMenu").document(weeklyMenu.weeklyMenuID).delete()
//                    self.db.collection("familyAccounts").document(userId).collection("weeklyMenu").document(weeklyMenu.weeklyMenuID).delete()
//                }
//            }
//        }
    }
    
//    @IBAction func acceptInviteButton(_ sender: UIButton) {
//        guard let userId = auth.currentUser?.uid else { return }
//
//        db.collection("users").document(userId).collection("invites").getDocuments() {
//            (snapshot, error) in
//
//            if let error = error {
//                print("No users \(error)")
//            } else {
//                guard let snapDoc = snapshot?.documents else { return }
//
//                for document in snapDoc {
//                    let invite = Invite(snapshot: document)
//                    self.invites.append(invite)
//                }
//                for invite in self.invites {
//                    self.acceptInvite(invite: invite)
//                }
//            }
//        }
//    }
    
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
    
//    func ifUserGetAnInviteThenShowPopup() {
//        guard let userId = auth.currentUser?.uid else { return }
//
//        db.collection("users").document(userId).collection("invites").addSnapshotListener() {
//            (snapshot, error) in
//
//            if let error = error {
//                print("No users \(error)")
//            } else {
//
//                guard let snapDoc = snapshot?.documents else { return }
//
//                for document in snapDoc {
//                    let invite = Invite(snapshot: document)
//                    if invite.invite == true {
//                        guard let nameFromUser = invite.fromUserName else { return }
//                        self.accpetOrDeclineInvite(title: "You got an invite", message: "Do you accept the invite from \(nameFromUser)")
//                    }
//                }
//            }
//        }
//    }
    
//    func accpetOrDeclineInvite(title: String, message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Accept", style: .default) { (UIAlertAction) in
//            guard let userId = self.auth.currentUser?.uid else { return }
//
//            self.db.collection("users").document(userId).collection("invites").addSnapshotListener() {
//                (snapshot, error) in
//
//                if let error = error {
//                    print("No users \(error)")
//                } else {
//                    guard let snapDoc = snapshot?.documents else { return }
//
//                    for document in snapDoc {
//                        let invite = Invite(snapshot: document)
//                        self.invites.append(invite)
//                    }
//                    for invite in self.invites {
//                        self.acceptInvite(invite: invite)
//                    }
//                }
//            }
//        })
//        alert.addAction(UIAlertAction(title: "Decline", style: .default) { (UIAlertAction) in
//            self.db.collection("users").getDocuments() {
//                (snapshot, error) in
//
//                if let error = error {
//                    print("No users \(error)")
//                } else {
//
//                    guard let snapDoc = snapshot?.documents else { return }
//
//                    for document in snapDoc {
//                        let user = User(snapshot: document)
//                        self.users.append(user)
//                    }
//                }
//
//                for user in self.users {
//                    let invite = Invite(fromUserId: user.userId, fromUserName: user.name )
//                    self.declineInvite(invite: invite)
//                }
//            }
//        })
//        self.present(alert, animated: true, completion:  nil)
//
//    }
}
