//
//  ThemeProtocol.swift
//  FoodPlaner
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
}
