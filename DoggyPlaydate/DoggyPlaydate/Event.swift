//
//  Event.swift
//  DoggyPlaydate
//
//  Created by user203105 on 11/21/21.
//

import UIKit


extension Event: FirestoreStorable {}
extension Event: Equatable {

    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
}

final class Event {
    
    static var COLLECTION_NAME = "Events"
    static var ID_PREFIX = "event"

    var id: String
    
    // TODO: Rename to clarify, is this a date (toDate) or User id (toUsers) or something else?
    // TODO: Could this instead be a [String]?
    // - Jackson
    var to: String
    // TODO: Same here
    var from: String
    var type: EventType
    var park: Park
    var date: String
    
    init(id: String,
         to: String,
         from: String,
         type: EventType,
         park: Park,
         date: String) {
        Event.isUniqueId(id: id) { isUnique in
            if !isUnique {
                print("Warning: Initializing \(Self.typeName) with existing ID \"\(id)\"")
            }
        }
        
        self.id = id
        self.to = to
        self.from = from
        self.type = type
        self.park = park
        self.date = date
        
        // Add to Firestore
        Event.writeDocument(obj: self) { successful in
            if !successful {
                print("Warning: Failed writing \(Self.typeName) with ID \"\(self.id)\" in init()")
            }
        }
    }
    
    /** Initialize with default fields */
    static func defaultInit(completion: @escaping (Event) -> Void) {
        Event.getNewUniqueId() { newId in
            Park.defaultInit() { newPark in
                OperationQueue.main.addOperation {
                    let event = Event(id: newId,
                                      to: "Unspecified",
                                      from: "Unspecified",
                                      type: EventType.privateInv,
                                      park: newPark,
                                      date: "Unspecified")
                    completion(event)
                }
            }
        }
    }
    
    enum EventType: String, Codable {
        case privateInv = "Private"
        case publicInv = "Public"
    }
}
