//
//  ScheduleViewController.swift
//  DoggyPlaydate
//
//  Created by MarkusM on 12/5/21.
//

import UIKit

class ScheduleViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var withDogField: UITextField!
    @IBOutlet var ownerField: UITextField!
    @IBOutlet var timeField: UITextField!
    @IBOutlet var parkField: UITextField!
    
    var dog: Dog! {
        didSet {
            dog.name == "" ? (navigationItem.title = "Playdate with New Dog") : (navigationItem.title = "Playdate with " + dog.name)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "returnToDetailView":
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.dog = dog
        default:
            preconditionFailure("Unexpected Segue Identifier")
        }
    }
    
    @IBAction func scheduleButtonPressed(){
        GlobalUser.user["numPlaydates"] = GlobalUser.numPlaydates + 1
        GlobalUser.saveUser(GlobalUser.user)
        self.displayAlert(withTitle: "Success", message: "Playdate has been scheduled")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        withDogField.text = dog.name
        Dog.getOwners(dog: dog) { owners in
            self.ownerField.text = owners.map({ $0.name }).joined(separator: ", ")
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func displayAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}
