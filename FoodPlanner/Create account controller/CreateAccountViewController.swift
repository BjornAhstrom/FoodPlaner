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
    @IBOutlet private weak var termsLabel: UILabel!
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

        
        termsLabel.font = UIFont(name: Theme.current.fontForLabels, size: 12)
        termsLabel.textColor = Theme.current.textColor
        
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
        UITextView.animate(withDuration: 0.2, animations: { self.view.frame.origin.y = -190})
    }
    
    @objc func textFieldDidEndEditing() {
        UITextView.animate(withDuration: 0.2, animations: { self.view.frame.origin.y = 0})
    }
    
    @IBAction func continueButton(_ sender: UIButton) {
        checkingPassword()
    }
    
    func checkingPassword() {
        passwordMatch = checkIfPasswordAndConfirmPasswordIsCorrect(password: passwordTextField.text!, confirmPassword: confirmPasswordTextField.text!)
        
        if passwordMatch == true && passwordTextField.text! != "" {
            createUser()
        }
        if nameTextField.text! == "" {
            self.alertMessage(titel: "Namefield can not be empty", message: "Pleace try again")
        }
        if emailTextField.text! == "" {
            self.alertMessage(titel: "Emailfield can not be empty", message: "Pleace try again")
        }
        if passwordTextField.text! == "" || confirmPasswordTextField.text! == "" {
            self.alertMessage(titel: "Passwordfield can not be empty", message: "Pleace try again")
        }
        if passwordMatch == false {
            self.alertMessage(titel: "Password do not match", message: "Pleace try again")
        }
    }
    
    func createUser() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let name = nameTextField.text else { return }
        
        let userName = User(name: name, email: email)
        
        auth.createUser(withEmail: email, password: password) { (user, error) in
            guard error == nil else {
                self.alertMessage(titel: "Error" , message: error!.localizedDescription)
                return
            }
            
            guard let userId = self.auth.currentUser?.uid else { return }
            
            let changeRequest = self.auth.currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = name
            changeRequest?.commitChanges(completion: { (error) in
                self.alertMessage(titel: "Error", message: error?.localizedDescription ?? "No name")
            })
            
            self.db.collection("users").document(userId).setData(userName.toAny())
            self.db.collection("familyAccount").document(userId).setData(["name": userName.name ])
            print("Account created")
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
