//
//  ThemeProtocol.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-02-26.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

protocol ThemeProtocol {
    var fontForLabels: String { get }
    var textColorForLabels: UIColor { get }
    var fontForButtons: String { get }
    var colorForButtons: UIColor { get }
    var colorForBorder: UIColor { get }
    var textColorForButtons: UIColor { get }
    var textColor: UIColor { get }
    
    // General
    var navigationbarTextColor: UIColor { get }
    
    // Sidebar menu
    var accountNameFontLabelSideMenu: UIFont { get }
    var accountNameTextColorLabelSideMenu: UIColor { get }
    var backgroundColorSideMenu: UIColor { get }
    var sideBarButtonColor: UIColor { get }
    var sideBarButtonFont: UIFont { get }
    var sideBarAddButtonFont: UIFont { get }
    var sideBarButtonTextColor: UIColor { get }
    var sideBarButtonBorderColor: UIColor { get }
    
    // Meal of the day
    var backgroundColorMealOfTheDay: UIColor { get }
    var mealOfTheDayLabelFont: UIFont { get }
    var mealOfTheDayLabelTextColor: UIColor { get }
    var dateLabelFont: UIFont { get }
    var dateLabelTextColor: UIColor { get }
    var foodNameLabelFont: UIFont { get }
    var foodNameLabelTextColor: UIColor { get }
    var recipeButtonBackgroundColor: UIColor { get }
    var recipeButtonTextColor: UIColor { get }
    var recipeButtonFont: UIFont { get }
    var recipeButtonBorderColor: UIColor { get }
    
    // Dishes view controller
    var backgroundColorInDishesView: UIColor { get }
    var textColorInTableViewInDishesView: UIColor { get }
    var textFontInTableViewInDishesView: UIFont { get }
    
    // Show dish view controller
    var backgroundColorShowDishController: UIColor { get }
    var backgroundColorInTableViewAndTextViewInShowDishController: UIColor { get }
    var borderColorInTableViewAndTextViewAndImageViewInShowDishController: UIColor { get }
    var textColorInTableViewAndTextViewInShowDishController: UIColor { get }
    var textFontInTextViewInShowDishController: UIFont { get }
    var textFontInTableViewInShowDishController: UIFont { get }
    var labelFontInShowDishController: UIFont { get }
    var labelTextColorInShowDishController: UIColor { get }
    var dishNameLabelFontInShowDishController: UIFont { get }
    var portionsLabelFontInShowDishController: UIFont { get }
    
    // Add dish view controller
    var backgroundColorAddDishController: UIColor { get }
    var borderColorForImageViewAddDishController: UIColor { get }
    var borderColorForIngredentsTableViewAddDishController: UIColor { get }
    var borderColorForCookingDescriptionAddDishController: UIColor { get }
    var borderAndTextColorForStepperAndAddButton: UIColor { get }
    
    
    // Select random dish view controller
    var backgroundColorSelectRandomDishController: UIColor { get }
    
    // Random weekly menuController
    var backgroundColorRandomWeeklyMenuController: UIColor { get }
    
    // Finished weekly menu controller
    var backgrondColorFinishedWeeklyMenuController: UIColor { get }
    
    // Settings View controller
    var backgroundColorForSettingsViewController: UIColor { get }
    
    var colorTextOnSettingLabelInSettingsViewController: UIColor { get }
    var fontOnSettingLabelInSettingsViewController: UIFont { get }
    
    var colorTextOnLabelsInSettingsViewController: UIColor { get }
    var fonOntLabelsInSettingsViewController: UIFont { get }
    
    var colorOnButtonsInSettingsViewController: UIColor { get }
    var collorOntextOnButtonsInSettingViewController: UIColor { get }
    var borderCollorOnButtonsInSettingViewController: UIColor { get }
    var fontOnButtonsInSettingsViewController: UIFont { get }
    
    // Shoping items view controller
    var backgroundColorInShoppingListViewController: UIColor { get }
    var textColorInTableViewInShoppingViewController: UIColor { get}
    var textFontInTableViewInShoppingViewController: UIFont { get }
    var borderColorForCheckBoxInShoppingViewController: UIColor { get }
    var borderColorForTableViewShoppingViewController: UIColor { get }
    
    // Finished weekly menu controller
    var backgroundColorInFinishedWeeklyMenuController: UIColor { get }
    var weeklyMenuLabelFontInFinishedWeeklyMenuController: UIFont { get }
    var weeklyMenuLabelTextColorInFinishedWeeklyMenuController: UIColor { get }
    var borderColorTableViewInFinishedWeeklyMenuController: UIColor { get }
}
