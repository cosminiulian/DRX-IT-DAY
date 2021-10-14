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
    func validateDate(_ enteredDate: String?) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "DD/MM/YYYY"
        return formatter.date(from: enteredDate)
    }
    
    func validateName(_ enteredName: String) -> Bool {
        guard enteredName.count > 7, enteredName.count < 18 else { return false }

        let namePredicate = NSPredicate(format: "SELF MATCHES %@", "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$")
        return namePredicate.evaluate(with: namePredicate)
    }
    
}
