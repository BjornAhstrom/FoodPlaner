//
//  DarkTheme.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-04-14.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class DarkTheme: ThemeProtocol {
    var fontForLabels: String = "Futura"
    
    var textColorForLabels: UIColor = UIColor(named: "TextColor")!
    
    var fontForButtons: String = "Futura"
    
    var colorForButtons: UIColor = UIColor(named: "OldPink")!
    
    var colorForBorder: UIColor = UIColor(named: "OldPink")!
    
    var textColorForButtons: UIColor = UIColor(named: "EggShellWhite")! // Not sidebar
    
    var textColor: UIColor = UIColor(named: "OldRose")!
    
    
    // Side menu buttons and namelabel
    var accountNameFontLabelSideMenu: UIFont = UIFont(name: "SnellRoundhand-Black", size: 25)!
    var accountNameTextColorLabelSideMenu: UIColor = UIColor(named: "OldRose")!
    var backgroundColorSideMenu: UIColor = UIColor(named: "customGray")!
    var sideBarButtonColor: UIColor = UIColor(named: "OldPink")!
    var sideBarButtonFont: UIFont = UIFont(name: "Futura", size: 18)!
    var sideBarAddButtonFont: UIFont = UIFont(name: "Futura", size: 15)!
    var sideBarButtonTextColor: UIColor = UIColor(named: "OldRose")!
    var sideBarButtonBorderColor: UIColor = UIColor(named: "OldRose")!
    
    
    // General
    var navigationbarTextColor: UIColor = UIColor(named: "OldRose")!
    
    
    // Meal of the day
    var backgroundColorMealOfTheDay: UIColor = UIColor(named: "PaleTurquoise")!
    
    var mealOfTheDayLabelFont: UIFont = UIFont(name: "Zapfino", size: 30)!
    var mealOfTheDayLabelTextColor: UIColor = UIColor(named: "Gray")!
    
    var dateLabelFont: UIFont = UIFont(name: "SnellRoundhand-Black", size: 18)!
    var dateLabelTextColor: UIColor = UIColor(named: "OldRose")!
    
    var foodNameLabelFont: UIFont = UIFont(name: "SnellRoundhand-Black", size: 22)!
    var foodNameLabelTextColor: UIColor = UIColor(named: "OldRose")!
    
    var recipeButtonBackgroundColor = UIColor(named: "customGray")!
    var recipeButtonTextColor = UIColor(named: "OldRose")!
    var recipeButtonFont = UIFont(name: "Futura", size: 18)!
    var recipeButtonBorderColor = UIColor(named: "OldRose")!
    
    
    // Dishes view controller
    var backgroundColorInDishesView: UIColor = UIColor(named: "PaleTurquoise")!
    var textColorInTableViewInDishesView: UIColor = UIColor(named: "OldRose")!
    var textFontInTableViewInDishesView: UIFont = UIFont(name: "TimesNewRomanPS-BoldItalicMT", size: 22)!
    
    
    // Show dish view controller
    var backgroundColorShowDishController: UIColor = UIColor(named: "PaleTurquoise")!
    var backgroundColorInTableViewAndTextViewInShowDishController: UIColor = UIColor(named: "PaleTurquoise")!
    var borderColorInTableViewAndTextViewAndImageViewInShowDishController: UIColor = UIColor(named: "OldRose")!
    var textColorInTableViewAndTextViewInShowDishController: UIColor = UIColor(named: "OldRose")!
    var textFontInTextViewInShowDishController: UIFont = UIFont(name: "TimesNewRomanPS-BoldItalicMT", size: 18)!
    var textFontInTableViewInShowDishController: UIFont = UIFont(name: "Futura", size: 16)!
    var labelFontInShowDishController: UIFont = UIFont(name: "TimesNewRomanPS-BoldItalicMT", size: 22)!
    var labelTextColorInShowDishController: UIColor = UIColor(named: "OldRose")!
    var dishNameLabelFontInShowDishController: UIFont = UIFont(name: "TimesNewRomanPS-BoldItalicMT", size: 24)!
    var portionsLabelFontInShowDishController: UIFont = UIFont(name: "TimesNewRomanPS-BoldItalicMT", size: 18)!
    
    
    // Add dish view controller
    var backgroundColorAddDishController: UIColor = UIColor(named: "PaleTurquoise")!
    var borderColorForImageViewAddDishController: UIColor = UIColor(named: "OldRose")!
    var borderColorForIngredentsTableViewAddDishController: UIColor = UIColor(named: "OldRose")!
    var borderColorForCookingDescriptionAddDishController: UIColor = UIColor(named: "OldRose")!
    var borderAndTextColorForStepperAndAddButton: UIColor = UIColor(named: "OldRose")!
    
    
    // Select random dish view controller
    var backgroundColorSelectRandomDishController: UIColor = UIColor(named: "PaleTurquoise")!
    
    
    // Random weekly menuController
    var backgroundColorRandomWeeklyMenuController: UIColor = UIColor(named: "PaleTurquoise")!
    
    
    // Finished weekly menu controller
    var backgrondColorFinishedWeeklyMenuController: UIColor = UIColor(named: "PaleTurquoise")!
    
    
    // Settings View controller
    var backgroundColorForSettingsViewController: UIColor = UIColor(named: "PaleTurquoise")!
    var colorTextOnSettingLabelInSettingsViewController: UIColor = UIColor(named: "OldRose")!
    var fontOnSettingLabelInSettingsViewController: UIFont = UIFont(name: "TimesNewRomanPS-BoldItalicMT", size: 25)!
    
    var colorTextOnLabelsInSettingsViewController: UIColor = UIColor(named: "OldRose")!
    var fonOntLabelsInSettingsViewController: UIFont = UIFont(name: "TimesNewRomanPS-BoldItalicMT", size: 20)!
    
    var colorOnButtonsInSettingsViewController: UIColor = UIColor(named: "OldRose")!
    var collorOntextOnButtonsInSettingViewController: UIColor = UIColor(named: "OldRose")!
    var borderCollorOnButtonsInSettingViewController: UIColor = UIColor(named: "OldRose")!
    var fontOnButtonsInSettingsViewController: UIFont = UIFont(name: "Futura", size: 18)!
    
    
    // Shopping list view controller
    var backgroundColorInShoppingListViewController: UIColor = UIColor(named: "PaleTurquoise")!
    var textColorInTableViewInShoppingViewController: UIColor = UIColor(named: "OldRose")!
    var textFontInTableViewInShoppingViewController: UIFont = UIFont(name: "TimesNewRomanPS-BoldItalicMT", size: 22)!
    var borderColorForCheckBoxInShoppingViewController: UIColor = UIColor(named: "OldRose")!
    var borderColorForTableViewShoppingViewController: UIColor = UIColor(named: "OldRose")!
    
    
    // Finished weekly menu controller
    var backgroundColorInFinishedWeeklyMenuController: UIColor = UIColor(named: "PaleTurquoise")!
    var weeklyMenuLabelFontInFinishedWeeklyMenuController: UIFont = UIFont(name: "TimesNewRomanPS-BoldItalicMT", size: 30)!
    var weeklyMenuLabelTextColorInFinishedWeeklyMenuController: UIColor = UIColor(named: "OldRose")!
    var borderColorTableViewInFinishedWeeklyMenuController: UIColor = UIColor(named: "OldRose")!
}



// Font
// Zapfino, SnellRoundhand-Black
