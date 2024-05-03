//
//  Registration.swift
//  MP
//
//  Created by aleksej on 3/22/24.
//

import Foundation
import Firebase
import FirebaseAuth

class Registration {
    private static var instance: Registration?
    private var validators = [validatorClosure]()
    private static var dbUsersReference = Database
        .database(url: "https://mpproject-750b8-default-rtdb.europe-west1.firebasedatabase.app")
        .reference(withPath: "Users")
    
    private init() {
        Registration.instance = self
        
        validators.append(Validator.getValidator(type: Validator.ValidatorType.VT_FirstName))
        validators.append(Validator.getValidator(type: Validator.ValidatorType.VT_LastName))
        validators.append(Validator.getValidator(type: Validator.ValidatorType.VT_Email))
        validators.append(Validator.getValidator(type: Validator.ValidatorType.VT_Password))
    }
    
    static func getIntance() -> Registration {
        if (Registration.instance == nil) {
            Registration.instance = Registration()
        }
        
        return Registration.instance!
    }
    
    func validateForm(_ form: RegistrationForm) -> (isSuccessful: Bool, reason: String?) {
        for validator in validators {
            let result = validator(form)
            
            if (!result.isSuccessful) {
                return result
            }
        }
        
        return (true, nil)
    }
    
    static func tryToRegister(validatedForm: RegistrationForm, onSuccess: @escaping () -> Void, alertClosure: @escaping (String?, String?) -> Void) {
         Auth.auth().createUser(withEmail: validatedForm.email!, password: validatedForm.password!) {
            authResult, error in
            
            if let error = error {
                alertClosure(nil, "Error during user registration: \(error.localizedDescription)")
            } else {
                let user = CustomUser(firstName: validatedForm.firstName!, lastName: validatedForm.lastName!)
                let str = validatedForm.email!
                if let range = str.range(of: ".") {
                    let substring = str[..<range.lowerBound]
                    dbUsersReference.child(String(substring)).setValue(user.getEncoded())
                }
                
                SceneDelegate.customUser = user
                onSuccess()
            }
            
        }
    }
}
