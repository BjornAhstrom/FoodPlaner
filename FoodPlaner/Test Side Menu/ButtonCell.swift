//
//  ButtonCell.swift
//  FoodPlaner
//
//  Created by Björn Åhström on 2019-03-01.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func setButtonTile(title: Button) {
        titleLabel.text = title.buttonTitle
    }
}
