//
//  validators.swift
//  meetups
//
//  Created by Hryhorii Pievniev on 28.10.2020.
//

import Foundation

let EMAIL_PATTERN = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

// At least one uppercase, one lowercase, one number and one symbol with the string itself being at least 6 characters long
let STRONG_PASSWORD_PATTERN = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{6,}$"

func isEmailValid (email: String) -> Bool {
    return NSPredicate(format:"SELF MATCHES %@", EMAIL_PATTERN).evaluate(with: email)
}

func isPasswordStrong(password: String) -> Bool {
    return NSPredicate(format:"SELF MATCHES %@", STRONG_PASSWORD_PATTERN).evaluate(with: password)
}

func validateUsername(username: String) -> String? {
    if username.isEmpty {
        return "Enter your username"
    }
    
    if username.count < 3 {
        return "Username is too short (Should be at least 3 symbols)"
    }
    
    if username.count > 30 {
        return "Username is too long (Should not be longer than 30 symbols)"
    }
    
    return nil
}

func validateEmail(email: String) -> String? {
    if email.isEmpty {
        return "Enter your email"
    }
    
    if !isEmailValid(email: email) {
        return "Email you entered is invalid"
    }
    
    return nil
}

func validatePassword(password: String) -> String? {
    if password.isEmpty {
        return "Enter your password"
    }
    
    if !isPasswordStrong(password: password) {
        return "Enter a stronger password (6+ characters with uppercase, lowercase and numbers)"
    }
    
    return nil
}

func validateConfirmPassword(confirmPassword: String, password: String) -> String? {
    if confirmPassword.isEmpty {
        return "Confirm your password"
    }
    
    if confirmPassword != password {
        return "Passwords do not match"
    }
    
    return nil
}
