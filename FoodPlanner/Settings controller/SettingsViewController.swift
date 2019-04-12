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
    
    
    private var signInPageId = "signInPage"
    
    var db: Firestore!
    var auth: Auth!
    
    var users: [User] = []
    var emails: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        auth = Auth.auth()
        self.hideKeyboard()
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
                
                for document in snapshot!.documents {
                    let user = User(snapshot: document)
                    self.users.append(user)
                }
            }
        }
        guard let accountName = accountNameTextField.text else { return }
        guard let name = auth.currentUser?.displayName else { return }
        for user in users {
            if user.email == inviteEmailTextField.text {
                let invite = Invite(toUserId: user.userId, fromUserName: name, invite: true)
                let owner = Owner(accountName: accountName, owner: name)
                db.collection("familyAccounts").addDocument(data: owner.toAny()).collection("invites").addDocument(data: invite.toAny())
                
            }
        }
    }
    
    
    @IBAction func sendInviteButton(_ sender: UIButton) {
        sendInvite()
//        accountNameTextField.text = ""
//        inviteEmailTextField.text = ""
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
