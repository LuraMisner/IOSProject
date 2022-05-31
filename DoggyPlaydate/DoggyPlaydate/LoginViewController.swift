//
//  LoginViewController.swift
//  DoggyPlaydate
//
//  Created by Shauna Kimura on 12/5/21.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    
    
    @IBAction func loginTapped(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: self.usernameField.text!, password: self.passwordField.text!) {
                  (user: PFUser?, error: Error?) -> Void in
              if user != nil {
                GlobalUser.username = self.usernameField.text!
                GlobalUser.queryUser()

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                
              } else {
                self.displayAlert(withTitle: "Error", message: error!.localizedDescription)
              }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showRegister":
            let _ = segue.destination as! RegisterViewController
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Login"
    }
    
    func displayAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}

extension String {
    func image() -> UIImage? {
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
