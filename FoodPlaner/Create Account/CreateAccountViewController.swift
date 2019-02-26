//
//  CreateAccountViewController.swift
//  FoodPlaner
//
//  Created by Björn Åhström on 2019-02-26.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {
    @IBOutlet weak var createAccountLabel: UILabel!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setColorFontAndSizeOnLabelsAndButtons()
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
