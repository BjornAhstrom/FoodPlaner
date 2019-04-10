//
//  SignInViewController.swift
//  FoodPlanner new
//
//  Created by Björn Åhström on 2019-02-25.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit
import Firebase

class signInViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createNewAccountButton: UIButton!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var loginWithFaceBookButton: UIButton!
    
    @IBOutlet var labelForTextField: [UILabel]!
    
    private var createAccountId: String = "createAccountId"
    private var containerViewId: String = "containerView"
    
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth = Auth.auth()
        setColorFontAndSizeOnLabelsAndButtons()
        self.hideKeyboard()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil {
            goToContainerViewController()
        }
        
    }
    
    func setColorFontAndSizeOnLabelsAndButtons() {
        createNewAccountButton.layer.cornerRadius = 15
        createNewAccountButton.titleLabel?.font = UIFont(name: Theme.current.fontForButtons, size: 15)
        createNewAccountButton.layer.backgroundColor = Theme.current.colorForButtons.cgColor
        createNewAccountButton.setTitleColor(Theme.current.textColorForButtons, for: .normal)
        
        signInButton.layer.cornerRadius = 25
        signInButton.layer.backgroundColor = Theme.current.colorForButtons.cgColor
        signInButton.titleLabel?.font = UIFont(name: Theme.current.fontForButtons, size: 20)
        signInButton.setTitleColor(Theme.current.textColorForButtons, for: .normal)
        
        loginWithFaceBookButton.layer.borderWidth = 2
        loginWithFaceBookButton.layer.cornerRadius = 25
        loginWithFaceBookButton.layer.borderColor = Theme.current.colorForBorder.cgColor
        loginWithFaceBookButton.titleLabel?.font = UIFont(name: Theme.current.fontForButtons, size: 20)
        loginWithFaceBookButton.setTitleColor(Theme.current.colorForBorder, for: .normal)
        
        for textfieldLabel in labelForTextField {
            textfieldLabel.layer.borderWidth = 2
            textfieldLabel.layer.borderColor = Theme.current.colorForBorder.cgColor
            textfieldLabel.layer.cornerRadius = 25
        }
    }
    
    func signIn() {
        if let email = emailTextField.text,
            let password = passwordTextField.text {
            
            auth.signIn(withEmail: email, password: password) { user, error in
                if let user = self.auth.currentUser {
                    
                    print(user.email ?? "No users")
                    self.goToContainerViewController()
                } else {
                    print("Error to sign in \(error!.localizedDescription)")
                }
            }
        }
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        signIn()
    }
    
    func goToContainerViewController() {
        if let containerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: containerViewId) as? ContainerViewController {
            
            let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.crossDissolve
            containerViewController.modalTransitionStyle = modalStyle
            present(containerViewController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func createANewAccountButton(_ sender: UIButton) {
        if let createAccountViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: createAccountId) as? CreateAccountViewController {
            
            let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.crossDissolve
            createAccountViewController.modalTransitionStyle = modalStyle
            self.present(createAccountViewController, animated: true, completion: nil)
        }
    }
    
}
