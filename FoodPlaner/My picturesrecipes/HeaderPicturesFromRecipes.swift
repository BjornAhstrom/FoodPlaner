//
//  HeaderPicturesFromRecipes.swift
//  FoodPlaner
//
//  Created by Björn Åhström on 2019-03-03.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class HeaderPicturesFromRecipes: UIView {
    @IBOutlet var picturesFromRecipesView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        UINib(nibName: "PicturesFromRecipes", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(picturesFromRecipesView)
        picturesFromRecipesView.frame = self.bounds
    }
}
