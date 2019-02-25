//
//  LoginViewController.swift
//  FoodPlaner
//
//  Created by Björn Åhström on 2019-02-25.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var textFields: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setColorFontAndSizeOnLabelsAndButtons()
    }
    
    func setColorFontAndSizeOnLabelsAndButtons() {
        for textField in textFields {
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 25
        textField.layer.borderColor = UIColor(named: "OldPink")?.cgColor
        }
    }
}
