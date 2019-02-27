//
//  LoginViewController.swift
//  FoodPlaner new
//
//  Created by Björn Åhström on 2019-02-25.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createNewAccountButton: UIButton!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginWithFaceBookButton: UIButton!
    
    @IBOutlet var labelForTextField: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setColorFontAndSizeOnLabelsAndButtons()
    }
    
    func setColorFontAndSizeOnLabelsAndButtons() {
        createNewAccountButton.layer.cornerRadius = 15
        createNewAccountButton.titleLabel?.font = UIFont(name: Theme.current.fontForButtons, size: 15)
        createNewAccountButton.layer.backgroundColor = Theme.current.colorForButtons.cgColor
        createNewAccountButton.setTitleColor(Theme.current.textColorForButtons, for: .normal)
        
        loginButton.layer.cornerRadius = 25
        loginButton.layer.backgroundColor = Theme.current.colorForButtons.cgColor
        loginButton.titleLabel?.font = UIFont(name: Theme.current.fontForButtons, size: 20)
        loginButton.setTitleColor(Theme.current.textColorForButtons, for: .normal)
        
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
    
    @IBAction func createANewAccountButton(_ sender: UIButton) {
        if let createAccountViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createAccount") as? CreateAccountViewController {
            
            let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.crossDissolve
            createAccountViewController.modalTransitionStyle = modalStyle
            self.present(createAccountViewController, animated: true, completion: nil)
        }
    }
    
}
