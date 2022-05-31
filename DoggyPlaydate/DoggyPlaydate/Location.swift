//
//  Location.swift
//  DoggyPlaydate
//
//  Created by Jackson Hall on 11/20/21.
//

/** A place to keep backend utility functions / types related to locations */

import Foundation

enum State: String {
    case alabama = "Alabama"
    case alaska = "Alaska"
    case arizona = "Arizona"
    case arkansas = "Arkansas"
    case california = "California"
    case colorado = "Colorado"
    case connecticut = "Connecticut"
    case delaware = "Delaware"
    case florida = "Florida"
    case georgia = "Georgia"
    case hawaii = "Hawaii"
    case idaho = "Idaho"
    case illinois = "Illinois"
    case indiana = "Indiana"
    case iowa = "Iowa"
    case kansas = "Kansas"
    case kentucky = "Kentucky"
    case louisiana = "Louisiana"
    case maine = "Maine"
    case maryland = "Maryland"
    case massachusetts = "Massachusetts"
    case michigan = "Michigan"
    case minnesota = "Minnesota"
    case mississippi = "Mississippi"
    case missouri = "Missouri"
    case montana = "Montana"
    case nebraska = "Nebraska"
    case nevada = "Nevada"
    case new_hampshire = "New Hampshire"
    case new_jersey = "New Jersey"
    case new_mexico = "New Mexico"
    case new_york = "New York"
    case north_carolina = "North Carolina"
    case north_dakota = "North Dakota"
    case ohio = "Ohio"
    case oklahoma = "Oklahoma"
    case oregon = "Oregon"
    case pennsylvania = "Pennsylvania"
    case rhode_island = "Rhode Island"
    case south_carolina = "South Carolina"
    case south_dakota = "South Dakota"
    case tennessee = "Tennessee"
    case texas = "Texas"
    case utah = "Utah"
    case vermont = "Vermont"
    case virginia = "Virginia"
    case washington = "Washington"
    case west_virginia = "West Virginia"
    case wisconsin = "Wisconsin"
    case wyoming = "Wyoming"
}

/** TODO use uscities.csv to get list of all towns & cities by state */
func getCities(in state: String) -> [String] {
    return []
}

/**
 Was going to use Address and Geolocation types in backend but decided to
 simplify things, feel free to uncomment if they can be useful -Jackson */
//struct Address {
//    var state: String
//    var city: String
//    var streetNum: String
//    var street: String
//    var zip: String
//
//    init(state: String,
//         city: String,
//         streetNum: String,
//         street: String,
//         zip: String) {
//        self.state = state
//        self.city = city
//        self.streetNum = streetNum
//        self.street = street
//        self.zip = zip
//    }
//
//    // This var is accessed when print(address) called (it's like a toString())
//    public var description: String {
//        return "\(streetNum) \(street), \(city), \(state) \(zip)"
//    }
//}
//
//struct Geolocation {
//    var latitude: Float
//    var longitude: Float
//
//    init(latitude: Float,
//         longitude: Float) {
//        self.latitude = latitude
//        self.longitude = longitude
//    }
//
//    // This var is accessed when print(geolocation) called (it's like a toString())
//    public var description: String {
//        return "(\(latitude), \(longitude))"
//    }
//}
