//
//  CreateAccountViewController.swift
//  FoodPlanner new
//
//  Created by Björn Åhström on 2019-02-26.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CreateAccountViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
//    @IBOutlet private weak var termsLabel: UILabel!
    @IBOutlet private weak var continueButton: UIButton!
    
    private var passwordMatch: Bool = false
    var db: Firestore!
    var auth: Auth!
    
    var test: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        auth = Auth.auth()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setColorFontAndSizeOnLabelsAndButtons()
        whenEnterIsTappedOnKeyboardMoveToNextTextField()
        showAndHideKeyBoardWithNotifications()
    }
    
    func setColorFontAndSizeOnLabelsAndButtons() {
        navigationBar.barTintColor = UIColor.white
        navigationBar.tintColor = Theme.current.textColor
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Theme.current.textColor]

        
//        termsLabel.font = UIFont(name: Theme.current.fontForLabels, size: 12)
//        termsLabel.textColor = Theme.current.textColor
        
        continueButton.layer.cornerRadius = 25
        continueButton.layer.backgroundColor = Theme.current.colorForButtons.cgColor
        continueButton.setTitleColor(Theme.current.textColorForButtons, for: .normal)
    }
    
    func whenEnterIsTappedOnKeyboardMoveToNextTextField() {
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        nameTextField.tag = 0
        emailTextField.tag = 1
        passwordTextField.tag = 2
        confirmPasswordTextField.tag = 3
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            checkingPassword()
        }
        return false
    }
    
    func showAndHideKeyBoardWithNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func textFieldDidBeginEditing() {
        UITextView.animate(withDuration: 0.2, animations: { self.nameTextField.frame.origin.y = 100 })
        UITextView.animate(withDuration: 0.2, animations: { self.emailTextField.frame.origin.y = 164 })
        UITextView.animate(withDuration: 0.2, animations: { self.passwordTextField.frame.origin.y = 228 })
        UITextView.animate(withDuration: 0.2, animations: { self.confirmPasswordTextField.frame.origin.y = 292 })
        UITextView.animate(withDuration: 0.2, animations: { self.continueButton.frame.origin.y = 420 })
    }
    
    @objc func textFieldDidEndEditing() {
        UITextView.animate(withDuration: 0.3, animations: { self.nameTextField.frame.origin.y = 150 })
        UITextView.animate(withDuration: 0.3, animations: { self.emailTextField.frame.origin.y = 214 })
        UITextView.animate(withDuration: 0.3, animations: { self.passwordTextField.frame.origin.y = 278 })
        UITextView.animate(withDuration: 0.3, animations: { self.confirmPasswordTextField.frame.origin.y = 342 })
        UITextView.animate(withDuration: 0.3, animations: { self.continueButton.frame.origin.y = 470})
    }
    
    @IBAction func continueButton(_ sender: UIButton) {
        checkingPassword()
    }
    
    func checkingPassword() {
        guard let nameText = nameTextField.text else { return }
        guard let passwordText = passwordTextField.text else { return }
        guard let confirmPassword = confirmPasswordTextField.text else { return }
        guard let emailText = emailTextField.text else { return }
        
        passwordMatch = checkIfPasswordAndConfirmPasswordIsCorrect(password: passwordText, confirmPassword: confirmPassword)
        
        if passwordMatch == true && passwordText != "" {
            createUser()
        }
        if nameText == "" {
            self.alertMessage(titel: "\(NSLocalizedString("allFields", comment: ""))", message: "\(NSLocalizedString("alertMessage_TryAgain", comment: ""))")
        }
        if emailText == "" {
            self.alertMessage(titel: "\(NSLocalizedString("allFields", comment: ""))", message: "\(NSLocalizedString("alertMessage_TryAgain", comment: ""))")
        }
        if passwordText == "" || confirmPassword == "" {
            self.alertMessage(titel: "\(NSLocalizedString("allFields", comment: ""))", message: "\(NSLocalizedString("alertMessage_TryAgain", comment: ""))")
        }
        if passwordMatch == false {
           self.alertMessage(titel: "\(NSLocalizedString("passwordMatch", comment: ""))", message: "\(NSLocalizedString("alertMessage_TryAgain", comment: ""))")
        }
    }
    
    func createUser() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let name = nameTextField.text else { return }
        
        auth.createUser(withEmail: email.lowercased(), password: password) { (user, error) in
            guard error == nil else {
                guard let err = error?.localizedDescription else { return }
                
                self.alertMessage(titel: "Error" , message: err)
                return
            }
            
            guard let userId = self.auth.currentUser?.uid else { return }
            
            let userName = User(name: name, email: email.lowercased(), familyAccount: userId)
            
            let changeRequest = self.auth.currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = name
            changeRequest?.commitChanges(completion: { (error) in
                self.alertMessage(titel: "Error", message: error?.localizedDescription ?? "No name")
            })
            
            self.db.collection("users").document(userId).setData(userName.toAny())
            
            self.db.collection("familyAccounts").document(userId).collection("members").document(userId).setData(["name": userName.userId ])
            
            self.db.collection("familyAccounts").document(userId).setData(["name": userName.name ])
            
            self.sendUserToStartView()
        }
    }
    
    func sendUserToStartView() {
        if let containerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "containerView") as? ContainerViewController {
            
            let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.crossDissolve
            containerViewController.modalTransitionStyle = modalStyle
            self.present(containerViewController, animated: true, completion: nil)
        }
    }
}
