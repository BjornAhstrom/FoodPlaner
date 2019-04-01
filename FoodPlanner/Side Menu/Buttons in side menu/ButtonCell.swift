//
//  ButtonCell.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-01.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func setButtonTile(title: Button) {
        titleLabel.layer.masksToBounds = true
        titleLabel.text = title.buttonTitle
        titleLabel.textColor = Theme.current.textColorForButtons
        titleLabel.layer.cornerRadius = 20
        titleLabel.backgroundColor = Theme.current.colorForButtons
    }
}
