//
//  Database.swift
//  DoggyPlaydate
//
//  Created by user203105 on 11/10/21.
//

import UIKit
import Firebase
//import FirebaseFirestore
import FirebaseFirestoreSwift

let db = Firestore.firestore()

/// Includes print statements at the top of all `FirestoreStorable` methods
let VERBOSE = true


/// These are all now in the appropriate classes (Dog, Park, etc.) as `static var COLLECTION_NAME`
/// - Jackson
//let DOG_PROFILES = "DogProfiles"
//let DOG_PARKS = "DogParks"
//let PARK_REVIEW = "ParkReviews"
//let EVENTS = "Events"
//let USER_PROFILES = "UserProfiles"

/// This one in particular is no longer needed, User-Dog ownership connections now stored in `Dog.ownerIds` and `User.dogIds`
//let USERS_DOGS = "UsersDogs"  // No longer needed


protocol FirestoreStorable: Codable, TypeName {
    
    /// Name of the Firestore Collection where all database operations will take place
    static var COLLECTION_NAME: String { get }
    
    /// A string to prefix all new IDs
    /// Ex. ID_PREFIX = "dog" --> getNewUniqueId() = "dog_12345"
    static var ID_PREFIX: String { get }
        
    /// A unique ID that will be the Document name when written to a Collection
    var id: String { get set }
    
    // ======================================================
    
    /**
     Initialize a `Self` instance with default values. Must be a static
     method to allow for asynchronous initialization of `self.id`
     */
    static func defaultInit(completion: @escaping (Self) -> Void)
    
    /** Return a new unique ID string */
    static func getNewUniqueId(completion: @escaping (String) -> Void)
    
    /** Return True if the given ID is not present the appropriate Collection or `T.allIds` */
    static func isUniqueId(id: String, completion: @escaping (Bool) -> Void)
    
    /** If `id` is not a duplicate, return it, else return a new unique ID and print a warning message */
    static func preventDuplicate(id: String, completion: @escaping (String) -> Void)
    
    /**
     Update `obj.id`, delete the Document for `obj` in Firestore, and write a new one under the name `newId`.
     Return a Bool indicating whether a new Document was written for `obj` under the name `newId`.
     If deleting the Document with the old ID fails but a new one was still written, print a warning,
     but return `true`.
     */
    func updateId(obj: Self, newId: String, completion: @escaping (Bool) -> Void)
    
    /**
     Write the object as a Document whose name is `obj.id` and send a Bool
     to `completion` indicating whether the delete was successful
     */
    static func writeDocument(obj: Self, completion: @escaping (Bool) -> Void)
    
    /** Read a record by its ID and convert it back to an object */
    static func fetchDocument(id: String, completion: @escaping (Self?) -> Void)
    
    /** Read the records with the given `ids` */
    static func fetchDocuments(ids: [String], completion: @escaping ([Self?]) -> Void)
    
    /** Read all records */
    static func fetchAllDocuments(completion: @escaping ([Self?]) -> Void)
    
    /** Delete a record by its ID and send a Bool to `completion` indicating whether the delete was successful */
    static func deleteDocument(id: String, completion: @escaping (Bool) -> Void)
}

extension FirestoreStorable {
    static func getNewUniqueId(completion: @escaping (String) -> Void) {
        
        if VERBOSE {
            print("test: \(Self.typeName).getNewUniqueId() called")
        }
        
        let CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        let CHARS_LEN = 5
        
        let chars = String((0..<CHARS_LEN).map { _ in CHARS.randomElement()! } )
        let id = "\(ID_PREFIX)_\(chars)"
        
        isUniqueId(id: id) { isUnique in
            if isUnique {
                OperationQueue.main.addOperation {
                    completion(id)
                }
            } else {
                // Recurse
                getNewUniqueId() { newId in
                    OperationQueue.main.addOperation {
                        completion(newId)
                    }
                }
            }
        }
    }
    static func isUniqueId(id: String, completion: @escaping (Bool) -> Void) {
        
        if VERBOSE {
            print("test: \(Self.typeName).isUniqueId(id:) called for \(Self.typeName) with ID \"\(id)\"")
        }
        
        Self.fetchDocument(id: id) { obj in
            print("test: ID \"\(id)\" IS " + (obj == nil ? "": "NOT ") + "unique")
            
            OperationQueue.main.addOperation {
                completion(obj == nil)
            }
        }
    }
    static func preventDuplicate(id: String, completion: @escaping (String) -> Void) {
        
        if VERBOSE {
            print("test: \(Self.typeName).preventDuplicate(id:) called for ID \"\(id)\"")
        }
        
        isUniqueId(id: id) { isUnique in
            if isUnique {
                OperationQueue.main.addOperation {
                    completion(id)
                }
            } else {
                getNewUniqueId() { newId in
                    print("Warning: \(Self.typeName) with ID \"\(id)\" already exists in \(Self.COLLECTION_NAME), changed to \"\(newId)\"")
                    OperationQueue.main.addOperation {
                        completion(newId)
                    }
                }
            }
        }
    }
    func updateId(obj: Self, newId: String, completion: @escaping (Bool) -> Void) {
        
        if VERBOSE {
            print("test: \(Self.typeName).updateId(obj:newId:) called for \(Self.typeName) with existing ID "
                + "\"\(obj.id)\" and newId \"\(newId)\"")
        }
        
        // Don't update to a non-unique ID
        Self.isUniqueId(id: newId) { isUnique in
            if !isUnique {
                print("Error: Couldn't update ID to \"\(newId)\" for \(Self.typeName) with "
                    + "current ID \"\(obj.id)\" from \(Self.typeName).updateId(), is not unique")
                OperationQueue.main.addOperation {
                    completion(false)
                }
                return
            }
        }
        
        // Delete Document under name
        Self.deleteDocument(id: obj.id) { successfulDelete in
            if !successfulDelete {
                print("Warning: \(Self.typeName).updateId() failed deleting \(Self.typeName) with"
                    + "ID \"\(obj.id)\" from \(Self.COLLECTION_NAME). A new Document will still "
                    + "be created with the new ID \"\(newId)\".")
            }
            
            // Update ID locally
            obj.id = newId
            
            // Save obj to Firestore as a new Document under `newId`
            Self.writeDocument(obj: obj) { successfulWrite in
                if !successfulWrite {
                    print("Error: Failed writing new Document for \(Self.typeName) with ID \"\(obj.id)\".")
                }
                
                OperationQueue.main.addOperation {
                    completion(successfulWrite)
                }
            }
        }
    }
    static func writeDocument(obj: Self, completion: @escaping (Bool) -> Void) {
        
        if VERBOSE {
            print("test: \(Self.typeName).writeDocument(obj:) called for \(Self.typeName) with ID \"\(obj.id)\"")
        }
        
        Self.isUniqueId(id: obj.id) { isUnique in
            if !isUnique {
                print("Warning: Trying to overwrite a \(Self.typeName) Document in \(COLLECTION_NAME) with ID "
                    + "\"\(obj.id)\", please explicitely delete it and rewrite it to avoid confusion")
                OperationQueue.main.addOperation {
                    completion(false)
                }
                return
            }
            
            // ID was unique, continue with the write
            var successful: Bool
            do {
                try db.collection(COLLECTION_NAME).document(obj.id).setData(from: obj)
                print("test: Success writing \(Self.typeName) with ID \"\(obj.id)\" to \(COLLECTION_NAME)")
                successful = true
            } catch let error {
                print("Error writing \(Self.typeName) with ID \"\(obj.id)\" to \(COLLECTION_NAME)\": \(error)")
                successful = false
            }
            
            OperationQueue.main.addOperation {
                completion(successful)
            }
        }
    }
    static func fetchDocument(id: String, completion: @escaping (Self?) -> Void) {
        if VERBOSE {
            print("test: \(Self.typeName).fetchDocument(id:) called for \(Self.typeName) with ID \"\(id)\"")
        }
        
        let docRef = db.collection(COLLECTION_NAME).document(id)
        docRef.getDocument { (document, error) in
            // Construct a Result type to encapsulate deserialization errors or
            // successful deserialization. Note that if there is no error thrown
            // the value may still be `nil`, indicating a successful deserialization
            // of a value that does not exist.
            //
            // There are thus three cases to handle, which Swift lets us describe
            // nicely with built-in Result types:
            //
            //      Result
            //        /\
            //   Error  Optional<Self>
            //               /\
            //            Nil  Self
            
//            print("test: inside closure in \(Self.typeName).fetchDocument()")
            
            // Initialize val to send to completion
            var completionVal: Self? = nil
            
            let result = Result {
              try document?.data(as: Self.self)
            }
            switch result {
            case .success(let obj):
                if let obj = obj {
                    // A `Self` value was successfully initialized from the DocumentSnapshot.
//                    print("obj: \(obj)")
                    completionVal = obj
                } else {
                    // A nil value was successfully initialized from the DocumentSnapshot,
                    // or the DocumentSnapshot was nil.
                    print("Document does not exist")
                }
            case .failure(let error):
                // A `Self` value could not be initialized from the DocumentSnapshot.
                print("Error decoding \(Self.typeName): \(error)")
            }
            
            OperationQueue.main.addOperation {
//                print("test: completionVal: " + String(completionVal != nil ? completionVal!.id : "nil"))
                completion(completionVal)
            }
        }
    }
    static func fetchDocuments(ids: [String], completion: @escaping ([Self?]) -> Void) {
        
        if VERBOSE {
            print("test: \(Self.typeName).fetchDocument(ids:) called for \(Self.typeName) with IDs "
                + "\(ids.map({ String("\"\($0)\"") }).joined(separator: ", "))")
        }
        
        // DispatchGroup stuff taken from here:
        // https://stackoverflow.com/a/40670398
        
        // 1. Create group
        let taskGroup = DispatchGroup()

        // 2. Enter group
        var docs = [Self?]()
        for id in ids {
            taskGroup.enter()
            fetchDocument(id: id) { doc in
                docs.append(doc)
                // 3. Leave group
                taskGroup.leave()
            }
        }

        // 4. Notify when all task completed at main thread queue.
        taskGroup.notify(queue: .main) {
            // All tasks are done.
            OperationQueue.main.addOperation {
                completion(docs)
            }
        }
    }
    static func fetchAllDocuments(completion: @escaping ([Self?]) -> Void) {
        
        if VERBOSE {
            print("test: \(Self.typeName).fetchAllDocuments() called")
        }
        
        // Initialize val to send to completion
        var docs = [Self?]()
                
        db.collection(COLLECTION_NAME).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    do {
                        try docs.append(document.data(as: Self.self))
                        if VERBOSE {
                            print("test: Successfully restored \(Self.typeName) from \(Self.COLLECTION_NAME) with ID \"\(document.documentID)\"")
                        }
                    } catch let error {
                        print("Error restoring \(Self.typeName) with ID \(document.documentID): \(error)")
                    }
                }
            }
            
            OperationQueue.main.addOperation {
//                print("test: adding docs to completion from \(Self.typeName).fetchAllDocuments()")
//                print("test: docs after db call:")
//                print(docs)
                completion(docs)
            }
        }
    }
    static func deleteDocument(id: String, completion: @escaping (Bool) -> Void) {
        
        if VERBOSE {
            print("test: \(Self.typeName).deleteDocument(id:) called for \(Self.typeName) with ID \"\(id)\"")
        }
        
        // Initialize val to send to completion
        var successful = false
        
        db.collection(COLLECTION_NAME).document(id).delete() { err in
            if let err = err {
                print("Error removing \(Self.typeName) with ID \"\(id)\" from \(Self.COLLECTION_NAME): \(err)")
                successful = false
            } else {
                print("\(Self.typeName) with ID \"\(id)\" was deleted from \(Self.COLLECTION_NAME)")
                successful = true
            }
        }
        
        OperationQueue.main.addOperation {
            completion(successful)
        }
    }
}
