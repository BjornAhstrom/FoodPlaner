//
//  DishesTableViewCell.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-06-09.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class DishesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewInTableView: UIView!
    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var ingredientLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
