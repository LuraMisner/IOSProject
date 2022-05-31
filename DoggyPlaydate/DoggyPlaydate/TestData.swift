//
//  TestData.swift
//  DoggyPlaydate
//
//  Created by user205639 on 11/16/21.
//

import Foundation


/**
 
 A place to store all hard-coded data for the app.
 
 */


extension User {
    static let JASON = User(id: "json275",
                            name: "Jason Hibbeler",
                            age: 50,
                            gender: User.Gender.male,
                            state: "Vermont",
                            city: "Burlington",
                            dogsIds: ["max123"])
    static let LISA  = User(id: "_lisa_",
                            name: "Lisa Dion",
                            age: 30,
                            gender: User.Gender.female,
                            state: "Vermont",
                            city: "Burlington",
                            dogsIds: ["gingerbread"])
    static let JIM   = User(id: "CSjimbo",
                            name: "James Eddy",
                            age: 40,
                            gender: User.Gender.male,
                            state: "Vermont",
                            city: "Burlington",
                            dogsIds: ["buddy32"])
    static let BOB   = User(id: "nodivs",
                            name: "Bob Erickson",
                            age: 442,
                            gender: User.Gender.male,
                            state: "Vermont",
                            city: "Burlington",
                            dogsIds: ["charlie1"])
    static let TEST_DATA = [
        JASON,
        LISA,
        JIM,
        BOB
    ]
}


extension Dog {
    static let MAX     = Dog(id: "max123",
                             name: "Max",
                             ownersIds: [User.JASON.id],
                             breed: Dog.Breed.labrador_retriever,
                             sex: Dog.Sex.male,
                             favoriteToy: "Tennis ball",
                             age: Dog.Age.puppy)
    static let GINGER  = Dog(id: "gingerbread",
                             name: "Ginger",
                             ownersIds: [User.LISA.id],
                             breed: Dog.Breed.poodle,
                             sex: Dog.Sex.female,
                             favoriteToy: "Frisbee",
                             age: Dog.Age.adult)
    static let BUDDY   = Dog(id: "buddy32",
                             name: "Buddy",
                             ownersIds: [User.JIM.id],
                             breed: Dog.Breed.beagle,
                             sex: Dog.Sex.male,
                             favoriteToy: "Tug rope",
                             age: Dog.Age.senior)
    static let CHARLIE = Dog(id: "charlie1",
                             name: "Charlie",
                             ownersIds: [User.BOB.id],
                             breed: Dog.Breed.golden_retriever,
                             sex: Dog.Sex.male,
                             favoriteToy: "Squeaky plush duck",
                             age: Dog.Age.senior)
    static let TEST_DATA: [Dog] = [
        MAX,
        GINGER,
        BUDDY,
        CHARLIE
    ]
}


extension Park {
    static let WATERFRONT_PARK = Park(id: "waterfront_park",
                                      name: "Waterfront Park",
                                      latitude: 44.480024,
                                      longitude: -73.222048,
                                      state: "VT",
                                      city: "Burlington",
                                      streetAddress: "20 Lake St")

    static let CALAHAN_PARK = Park(id: "calahan_park",
                                   name: "Calahan Park",
                                   latitude: 44.46229,
                                   longitude: -73.21267,
                                   state: "VT",
                                   city: "Burlington",
                                   streetAddress: "45 Locust St")

    static let NORTH_BEACH_PARK = Park(id: "north_beach_park",
                                       name: "North Beach Park",
                                       latitude: 44.49261,
                                       longitude: -73.24042,
                                       state: "VT",
                                       city: "Burlington",
                                       streetAddress: "")

    static let BATTERY_PARK = Park(id: "battery_park",
                                   name: "Battery Park",
                                   latitude: 44.48142,
                                   longitude: -73.21992,
                                   state: "VT",
                                   city: "Burlington",
                                   streetAddress: "Battery Park Extension")
    static let TEST_DATA = [
        WATERFRONT_PARK,
        CALAHAN_PARK,
        NORTH_BEACH_PARK,
        BATTERY_PARK
    ]
}
