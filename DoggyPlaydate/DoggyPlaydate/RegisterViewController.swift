//
//  SignUpViewController.swift
//  DoggyPlaydate
//
//  Created by Shauna Kimura on 12/5/21.
//

import UIKit
import Parse

class RegisterViewController: UIViewController {
    
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    @IBAction func registerTapped(_ sender: Any) {
        let user = PFUser()
        user.username = self.usernameField.text
        user.password = self.passwordField.text
                
        user.signUpInBackground {(succeeded: Bool, error: Error?) -> Void in
            if let error = error {
                self.displayAlert(withTitle: "Error", message: error.localizedDescription)
            } else {
                let appUser = PFObject(className: "AppUser")
                GlobalUser.user = appUser
                appUser["username"] = self.usernameField.text
                appUser["numPlaydates"] = 0
                
                GlobalUser.saveUser(appUser)

                self.displayAlert(withTitle: "Success", message: "Account has been successfully created")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Register"
    }
    
    func displayAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}
