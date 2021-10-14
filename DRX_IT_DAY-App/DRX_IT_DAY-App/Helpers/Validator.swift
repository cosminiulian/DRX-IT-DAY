//
//  RegexValidator.swift
//  DRX_IT_DAY-App
//
//  Created by Cosmin Iulian on 02.05.2021.
//

import Foundation

struct Validator {
   
    static let shared = Validator()
    
    private init() {}
    
    // Validator for Date
    func validateDate(_ enteredDate: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.date(from: enteredDate) != nil
    }
    
    // Regex Validator for First and Last name
    func validateFirstAndLastName(_ enteredName: String?) -> Bool {
        let nameFormat = "[A-Z]{1}[a-zA-Z]{2,19}\\s[A-Z]{1}[a-zA-Z]{2,19}"
        let namePredicate = NSPredicate(format:"SELF MATCHES %@", nameFormat)
        return namePredicate.evaluate(with: enteredName)
    }
    
}


