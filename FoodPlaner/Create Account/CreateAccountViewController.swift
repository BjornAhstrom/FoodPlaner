//
//  CreateAccountViewController.swift
//  FoodPlaner new
//
//  Created by Björn Åhström on 2019-02-26.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var createAccountLabel: UILabel!
    @IBOutlet private weak var termsLabel: UILabel!
    @IBOutlet private weak var continueButton: UIButton!
    
    private var passwordMatch: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setColorFontAndSizeOnLabelsAndButtons()
    }
    
    @IBAction func continueButton(_ sender: UIButton) {
        passwordMatch = checkIfPasswordAndConfirmPasswordIsCorrect(password: passwordTextField.text!, confirmPassword: confirmPasswordTextField.text!)
        
        if passwordMatch == true && passwordTextField.text! != "" {
           sendUserToStartView()
        }
        if nameTextField.text! == "" {
            alertMessage(titel: "Namefield can not be empty")
        }
        if emailTextField.text! == "" {
            alertMessage(titel: "Emailfield can not be empty")
        }
        if passwordTextField.text! == "" || confirmPasswordTextField.text! == "" {
            alertMessage(titel: "Passwordfield can not be empty")
        }
        if passwordMatch == false {
            alertMessage(titel: "Password do not match")
        }
    }
    
    func sendUserToStartView() {
        if let containerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "containerView") as? ContainerViewController {
            
            let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.crossDissolve
            containerViewController.modalTransitionStyle = modalStyle
            self.present(containerViewController, animated: true, completion: nil)
        }
    }
    
    func alertMessage(titel: String) {
        let alert = UIAlertController(title: titel, message: "Pleace try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion:  nil)
    }
    
    func setColorFontAndSizeOnLabelsAndButtons() {
        createAccountLabel.font = UIFont(name: Theme.current.fontForLabels, size: 25)
        createAccountLabel.textColor = Theme.current.textColor
        
        termsLabel.font = UIFont(name: Theme.current.fontForLabels, size: 12)
        termsLabel.textColor = Theme.current.textColor
        
        continueButton.layer.cornerRadius = 25
        continueButton.layer.backgroundColor = Theme.current.colorForButtons.cgColor
        continueButton.setTitleColor(Theme.current.textColorForButtons, for: .normal)
    }
}
