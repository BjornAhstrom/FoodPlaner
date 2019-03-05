//
//  HeaderView.swift
//  FoodPlaner
//
//  Created by Björn Åhström on 2019-03-03.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    @IBOutlet var dishesView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        UINib(nibName: "DishIngredients", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(dishesView)
        dishesView.frame = self.bounds
    }
}
