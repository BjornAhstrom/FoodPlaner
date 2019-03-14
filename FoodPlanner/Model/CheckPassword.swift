//
//  CheckPassword.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-01.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation

private var passwordMatch: Bool = false

func checkIfPasswordAndConfirmPasswordIsCorrect(password: String, confirmPassword: String) -> Bool{
    if password == confirmPassword {
        passwordMatch = true
    } else {
        passwordMatch = false
    }
    return passwordMatch
}
