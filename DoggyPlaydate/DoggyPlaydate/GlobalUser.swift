//
//  GlobalUser.swift
//  DoggyPlaydate
//
//  Created by Shauna Kimura on 12/6/21.
//

import UIKit
import Parse

struct GlobalUser {
    static var user = PFObject(className: "AppUser")
    static var username: String = ""
    static var numPlaydates: Int!
    
    static func queryUser() {
            let query = PFQuery(className:"AppUser")

            query.whereKey("username", equalTo:GlobalUser.username)
            query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let objects = objects {
                    let user = objects[0]
                    GlobalUser.numPlaydates = user["numPlaydates"] as? Int
                }
            }
        }
    
    static func saveUser(_ user: PFObject) {
        user.saveInBackground { (succeeded, error)  in
            if (succeeded) {
                print("User data saved")
            } else {
                print(error!)
            }
        }
    }

}
