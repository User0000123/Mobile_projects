//
//  ViewController.swift
//  MP
//
//  Created by aleksej on 3/11/24.
//

import UIKit
import Firebase

class WelcomePageController: UIViewController {
    
    @IBOutlet var tfEmail: UITextField!
    @IBOutlet var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Perform actions when the view is about to appear
        if navigationController?.viewControllers.first == self {
            navigationController?.setNavigationBarHidden(true, animated: true )
        }
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Perform actions when the view is about to disappear
        if navigationController?.viewControllers.first == self {
            navigationController?.setNavigationBarHidden(false , animated: true)
        }
    }
    
    @IBAction func onLogInClick() {
        let logInForm = LogInForm()
        
        logInForm.email = tfEmail.text
        logInForm.password = tfPassword.text
        
        if (!(logInForm.email?.isEmpty ?? false) && !(logInForm.password?.isEmpty ?? false)) {
            LogIn.LogIn(form: logInForm, onSuccess: {
                
                if let window = UIApplication.shared.windows.first {
                    SceneDelegate.initCustomUser(Auth.auth().currentUser!)
                    window.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePage")
                }
            }, alertClosure: showAlert)
        } else {
            showAlert(title: "Error logging in!", text: "Check email and password")
        }
    }
}

