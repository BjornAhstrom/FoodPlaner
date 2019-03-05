//
//  HeaderWebrecipes.swift
//  FoodPlaner
//
//  Created by Björn Åhström on 2019-03-03.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class HeaderWebrecipes: UIView {
    @IBOutlet var webrecipesView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        UINib(nibName: "MyWebrecipes", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(webrecipesView)
        webrecipesView.frame = self.bounds
    }
}
