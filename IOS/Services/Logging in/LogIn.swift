//
//  LogIn.swift
//  MP
//
//  Created by aleksej on 3/23/24.
//

import Foundation
import FirebaseAuth

class LogIn {

    static func LogIn(form: LogInForm, onSuccess: @escaping () -> Void, alertClosure: @escaping (String?, String?) -> Void) {
        Auth.auth().signIn(withEmail: form.email!, password: form.password!) {
            authResult, error in
            
            if let error = error {
                alertClosure(nil, "Error logging in: \(error.localizedDescription)")
            } else {
                onSuccess()
            }
        }
    }
}
