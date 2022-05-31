//
//  DogStore.swift
//  DoggyPlaydate
//
//  Created by Shauna Kimura on 11/16/21.
//

import UIKit
import MapKit

class DogStore {
    var allDogs: [Dog] = []
    var breeds = loadCSV()

    func createDog(completion: @escaping (Dog) -> Void) {
        Dog.defaultInit() { dog in
            self.allDogs.append(dog)
            OperationQueue.main.addOperation {
                completion(dog)
            }
        }
    }
    
    func removeDog(_ dog: Dog) {
        if let index = allDogs.firstIndex(of: dog) {
            allDogs.remove(at: index)
        }
    }
    
    func moveDog(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        let movedDog = allDogs[fromIndex]
        allDogs.remove(at: fromIndex)
        allDogs.insert(movedDog, at: toIndex)
    }
    
}
