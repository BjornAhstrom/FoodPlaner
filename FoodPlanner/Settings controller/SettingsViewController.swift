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
    @IBOutlet weak var accountNameTextField: UITextField!
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
    var emails: [String] = []
    var invites: [Invite] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        auth = Auth.auth()
        self.hideKeyboard()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
            guard let accountName = self.accountNameTextField.text else { return }
            guard let name = self.auth.currentUser?.displayName else { return }
            
            for user in self.users {
                if user.email == self.inviteEmailTextField.text {
                    
                    
                    let invite = Invite(fromUserId: self.auth.currentUser!.uid )
                    
                    self.db.collection("users").document(user.userId).collection("invites").document(self.auth.currentUser!.uid).setData(invite.toAny())
                    self.users = []
                }
            }
        }
    }
    
    func acceptInvite(invite: Invite) {
        // 1. lägg till dig själv som medlem i familyaccountet som du är invitad till
        db.collection("familyAccounts").document(invite.fromUserId).collection("members").document(auth.currentUser!.uid)
        
        // 2. lägg till familyaccountet som du accpterar som ditt eget familyaccount
        db.collection("users").document(auth.currentUser!.uid).setData(["familyAccount" : invite.fromUserId])
        
        // 3. radera inviten
        db.collection("users").document(auth.currentUser!.uid).collection("invites").document(invite.fromUserId).delete()
        
    }
    
    func declineInvite(invite: Invite) {
        // radera inviten
    }
    
    
    @IBAction func sendInviteButton(_ sender: UIButton) {
        sendInvite()
    }
    
    @IBAction func acceptInviteButton(_ sender: UIButton) {
        guard let userId = auth.currentUser?.uid else { return }
        
        db.collection("users").document(userId).getDocument() {
            (snapshot, error) in
            
            if let error = error {
                print("No users \(error)")
            } else {
                
                for invite in self.invites {
                    self.db.collection("users").document(userId).setValuesForKeys(["familyAccount" : invite.fromUserId])
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
    
    @IBAction func switchButton(_ sender: UISwitch) {
    }
    
    
    @IBAction func signOutButton(_ sender: UIButton) {
        signOut()
    }
    
}
