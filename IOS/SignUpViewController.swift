//
//  SignUpViewController.swift
//  MP
//
//  Created by aleksej on 3/13/24.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func onSignUpClick() {
        let registration = Registration.getIntance()
        let form = RegistrationForm()
        
        form.firstName = tfFirstName.text
        form.lastName = tfLastName.text
        form.email = tfEmail.text
        form.password = tfPassword.text
        
        let validationResult = registration.validateForm(form)
        
        if (validationResult.isSuccessful) {
            Registration.tryToRegister(validatedForm: form, onSuccess: {
                                        if let window = UIApplication.shared.windows.first {
                                            window.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePage")
                                        }}, alertClosure: self.showAlert)
        } else {
            showAlert(title: "User not registered!", text: validationResult.reason)
        }
    }
}

extension UIViewController {
    func showAlert(title: String?, text: String?){
        let alertValidationFailure = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alertValidationFailure.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertValidationFailure, animated: true, completion: nil)
    }
}
