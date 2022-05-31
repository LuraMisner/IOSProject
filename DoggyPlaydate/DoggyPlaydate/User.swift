//
//  User.swift
//  DoggyPlaydate
//
//  Created by Jackson Hall on 11/16/21.
//

import Foundation


extension User: FirestoreStorable {}
extension User: Equatable {
    // TODO: Might want to check against all fields instead of just id
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

final class User {
    
//    static var COLLECTION_NAME = "UserProfiles"
    static var COLLECTION_NAME = "UsersTest"
    static var ID_PREFIX = "user"
    
    var id: String
    var name: String
    var age: Int
    var gender: Gender
    var state: String
    var city: String
    var dogsIds: [String]
    
    init(id: String,
         name: String,
         age: Int,
         gender: Gender,
         state: String,
         city: String,
         dogsIds: [String]) {
        User.isUniqueId(id: id) { isUnique in
            if !isUnique {
                print("Warning: Initializing \(Self.typeName) with existing ID \"\(id)\"")
            }
        }
        
        self.id = id
        self.name = name
        self.age = age
        self.gender = gender
        self.state = state
        self.city = city
        self.dogsIds = dogsIds
        
        // Add to Firestore
        User.writeDocument(obj: self) { successful in
            if !successful {
                print("Warning: Failed writing \(Self.typeName) with ID \"\(self.id)\" in init()")
            }
        }
    }
    
    /** Initialize with default fields */
    static func defaultInit(completion: @escaping (User) -> Void) {
        User.getNewUniqueId() { newId in
            OperationQueue.main.addOperation {
                let user = User(id: newId,
                                name: "Unspecified",
                                age: 0,
                                gender: Gender.unspecified,
                                state: "Unspecified",
                                city: "Unspecified",
                                dogsIds: [])
                completion(user)
            }
        }
    }
    
    /** Return an array of Dogs, the `user`'s owned dogs, pulled from Firestore */
    static func getOwnedDogs(user: User, completion: @escaping ([Dog]) -> Void) {
        
        if VERBOSE {
            print("test: User.getOwnedDogs(user:) called")
        }
        
        Dog.fetchDocuments(ids: user.dogsIds) { users in
            OperationQueue.main.addOperation {
                completion(users.compactMap { $0 } )
            }
        }
    }
    
    /** Establish `self`'s ownership of `dog` */
    func addOwnedDog(dog: Dog, completion: @escaping (Bool) -> Void) {
        
        if VERBOSE {
            print("test: User.addOwnedDog(dog:) called")
        }
        
        dog.addOwner(owner: self) { successful in
            OperationQueue.main.addOperation {
                completion(successful)
            }
        }
    }
    
    enum Gender: String, Codable {
        case male = "Male"
        case female = "Female"
        case other = "Other"
        case unspecified = "Unspecified"
    }
}
