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
    
    private var signInPageId = "signInPage"
    
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth = Auth.auth()
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
    
    func sendAnInvite() {
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
