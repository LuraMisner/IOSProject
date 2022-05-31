//
//  utils.swift
//  DoggyPlaydate
//
//  Created by Jackson Hall on 12/4/21.
//

import Foundation

// Adds ability to get a class's name as a String, ex. Dog.typeName --> "Dog" 
protocol TypeName: AnyObject {
    static var typeName: String { get }
}
extension TypeName {
    static var typeName: String {
        let type = String(describing: self)
        return type
    }
}
