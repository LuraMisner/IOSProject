//
//  Park.swift
//  DoggyPlaydate
//
//  Created by Jackson Hall on 11/23/21.
//

import Foundation


extension Park: FirestoreStorable {}
extension Park: Equatable {
    // TODO: Might want to check against all fields instead of just id
    static func == (lhs: Park, rhs: Park) -> Bool {
        return lhs.id == rhs.id
    }
}

final class Park {
    
    static var COLLECTION_NAME = "ParksTest"
    static var ID_PREFIX = "park"
    
    var id: String
    var name: String
    var latitude: Double
    var longitude: Double
    var state: String
    var city: String
    var streetAddress: String
    
    init(id: String,
         name: String,
         latitude: Double,
         longitude: Double,
         state: String,
         city: String,
         streetAddress: String) {
        Park.isUniqueId(id: id) { isUnique in
            if !isUnique {
                print("Warning: Initializing \(Self.typeName) with existing ID \"\(id)\"")
            }
        }
        
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.state = state
        self.city = city
        self.streetAddress = streetAddress
        
        // Add to Firestore
        Park.writeDocument(obj: self) { successful in
            if !successful {
                print("Warning: Failed writing \(Self.typeName) with ID \"\(self.id)\" in init()")
            }
        }
    }
    
    /** Initialize with default fields */
    static func defaultInit(completion: @escaping (Park) -> Void) {
        Park.getNewUniqueId() { newId in
            OperationQueue.main.addOperation {
                let park = Park(id: newId,
                                name: "Unspecified",
                                latitude: 0,
                                longitude: 0,
                                state: "Unspecified",
                                city: "Unspecified",
                                streetAddress: "Unspecified")
                completion(park)
            }
        }
    }
}
