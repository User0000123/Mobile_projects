//
//  UserProfileViewController.swift
//  MP
//
//  Created by aleksej on 3/12/24.
//

import UIKit
import FirebaseAuth

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for subView in stackView.arrangedSubviews
        {
            stackView.removeArrangedSubview(subView)
            subView.removeFromSuperview()
        }
        
        var data = [Entry<String, String>]()
        let user = SceneDelegate.customUser!
        let dateFormatter = DateFormatter()
        let fireBaseUser = Auth.auth().currentUser!
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        data.append(Entry(user.firstName!, "First name"))
        data.append(Entry(user.lastName!, "Last name"))
        data.append(Entry(fireBaseUser.email!, "Email"))
        data.append(Entry(String(fireBaseUser.isEmailVerified), "Is email verified"))
        data.append(Entry(String(fireBaseUser.isAnonymous), "Is anonimous"))
        data.append(Entry(String(fireBaseUser.uid), "Providers UID"))
        data.append(Entry(String(fireBaseUser.providerID), "Provider ID"))
        data.append(Entry(String(fireBaseUser.refreshToken ?? "nil"), "Refresh token"))
        data.append(Entry(dateFormatter.string(from: fireBaseUser.metadata.creationDate!), "Creation date"))
        data.append(Entry(String(user.favourites!.count), "Favourites count"))
        
        let font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        for entry in data
        {
            let label = UILabel()
            let attributedString = NSMutableAttributedString(string: entry.key + " : " + entry.value)
            attributedString.addAttribute(.foregroundColor, value: UIColor.systemIndigo, range: NSRange(location: 0, length: entry.key.count))
            attributedString.addAttribute(.foregroundColor, value: UIColor.systemOrange, range: NSRange(location: entry.key.count + 3, length: entry.value.count))
            label.attributedText = attributedString
            label.font = font
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.frame.size.width = stackView.frame.width
            stackView.addArrangedSubview(label)
        }
    }
    
    @IBAction func onSignOutClick()
    {
        do {
            try Auth.auth().signOut()
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            }
        } catch {
            showAlert(title: "Error", text: "Not signed out :(")
        }
    }
    
    @IBAction func onDeleteUserClick()
    {
        let str = Auth.auth().currentUser!.email!
        if let range = str.range(of: ".") {
            let substring = str[..<range.lowerBound]
            SceneDelegate.dbUserReference.child(String(substring)).removeValue()
        }
        
        Auth.auth().currentUser?.delete(completion: {
            error in
                
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            }
        })
    }
    
    private struct Entry<TKey, TValue> {
        var key: TKey
        var value: TValue
        
        init(_ value: TValue, _ key: TKey)
        {
            self.key = key
            self.value = value
        }
    }
}
