//
//  DetailViewController.swift
//  DoggyPlaydate
//
//  Created by Shauna Kimura on 11/17/21.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {
        
    @IBOutlet weak var imageView: UIImageView!
    
    var selectedImage: String?
    
    @IBOutlet var nameField: UITextField!
    
    @IBOutlet var ownerField: UITextField!
    
    @IBOutlet var breedField: UITextField!
    
    @IBOutlet var favoriteToyField: UITextField!
    
    @IBOutlet var ageField: UITextField!
            
    @IBOutlet var sexField: UITextField!
 
    @IBOutlet var containerView: UIView!
    
    var dog: Dog! {
        didSet {
            dog.name == "" ? (navigationItem.title = "New Dog") : (navigationItem.title = dog.name)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showScheduleView":
            let scheduleViewController = segue.destination as! ScheduleViewController
            scheduleViewController.dog = dog
        default:
            preconditionFailure("Unexpected Segue Identifier")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.nameField.text = dog.name
        Dog.getOwners(dog: dog) { owners in
            self.ownerField.text = owners.map({ $0.name }).joined(separator: ", ")
        }
        self.breedField.text = dog.breed.rawValue
        self.favoriteToyField.text = dog.favoriteToy
        self.ageField.text = dog.age.rawValue
        self.sexField.text = dog.sex.rawValue
            
        var image: UIImage!
        
        switch dog.id {
        case "reggie123":
            image = UIImage(named: "reggie123")
        case "peter123":
            image = UIImage(named: "peter123")
        case "Callie123":
            image = UIImage(named: "callie123")
        case "hunter123":
            image = UIImage(named: "hunter123")
        case "lucky123":
            image = UIImage(named: "lucky")
        case "benny123":
            image = UIImage(named: "benny")
        case "tyler123":
            image = UIImage(named: "tyler")
        default:
            image = UIImage(named: "dog")
        }
        
        imageView.image = image
        imageView.clipsToBounds = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

