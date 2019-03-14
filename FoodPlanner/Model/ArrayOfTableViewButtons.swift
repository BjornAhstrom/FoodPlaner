//
//  ArrayOfButtons.swift
//  FoodPlaner
//
//  Created by Björn Åhström on 2019-03-05.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation
import UIKit

class ArrayOfTableViewButtons {
    private var myRecipes: [Dishes] = []
    private var myPictureRecipes: [UIImage] = []
    private var myWebRecipes: [String] = []
    private var weeklyMenu: [String] = []
    
    init(myRecipes: [Dishes], myPictureRecipes: [UIImage], myWebRecipes: [String], weeklyMenu: [String]) {
        self.myRecipes = myRecipes
        self.myPictureRecipes = myPictureRecipes
        self.myWebRecipes = myWebRecipes
        self.weeklyMenu = weeklyMenu
    }
}
                                                                     
