//
//  ViewController.swift
//  DoggyPlaydate
//
//  Created by Shauna Kimura on 10/14/21.
//

import UIKit
import Firebase

class DogsViewController: UITableViewController {
    var dogs = [Dog]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dogs.count
    }
    
    func initializeDogs() {
        Dog.fetchAllDocuments() { list in
            print(list)
            self.dogs = list.compactMap { $0 }
            print("test: self.dogs:")
            print(self.dogs)
            print("test: reloading tableView data")
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = "Hi, \(GlobalUser.username)"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutTapped))
                
        initializeDogs()
                
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DogCell", for: indexPath) as! DogCell
        let dog = self.dogs[indexPath.row]
        
        cell.nameLabel.text = (dog.name == "") ? "New Dog" : dog.name
        if dog.ownersIds.isEmpty {
            cell.ownerLabel.text = "Owner"
        } else {
            Dog.getOwners(dog: dog) { owners in
                cell.ownerLabel.text = owners.map({ $0.name }).joined(separator: ", ")
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showDog":
            if let row = tableView.indexPathForSelectedRow?.row {
                let dog = self.dogs[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.dog = dog
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    @objc func logOutTapped(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInViewController = storyboard.instantiateViewController(identifier: "LoginViewController")

        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(signInViewController)

    }

}
