//
//  Validator.swift
//  MP
//
//  Created by aleksej on 3/22/24.
//

import Foundation

typealias validatorClosure = (RegistrationForm) -> (isSuccessful: Bool, reason: String?)

class Validator
{
    static let namePredicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", "^(?!.*[\\s])[A-Za-z]{1,}$")
    static let emailPredicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[\\@\\.]).{5,}$")
    static let passwordPredicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z]).{8,}$")
    
    enum ValidatorType
    {
        case VT_Email, VT_Password, VT_FirstName, VT_LastName
    }
    
    static func getValidator(type: ValidatorType) -> validatorClosure
    {
        switch type {
        case .VT_Email:
            return validateEmail
        case .VT_Password:
            return validatePassword
        case .VT_FirstName, .VT_LastName:
            return validateName
        }
    }

    private static func validateEmail(form: RegistrationForm) -> (isSuccessful: Bool, reason: String?)
    {
        let result = emailPredicate.evaluate(with: form.email)
        return (result, result ? nil : "The email doesn't meet the requirements!")
    }

    private static func validatePassword(form: RegistrationForm) -> (isSuccessful: Bool, reason: String?)
    {
        let result = passwordPredicate.evaluate(with: form.password)
        return (result, result ? nil : "The password doesn't meet the requirements!")
    }
    
    private static func validateName(form: RegistrationForm) -> (isSuccessful: Bool, reason: String?)
    {
        let result = namePredicate.evaluate(with: form.firstName) && namePredicate.evaluate(with: form.lastName)
        return (result, result ? nil : "Names don't meet the requirements!")
    }
}
