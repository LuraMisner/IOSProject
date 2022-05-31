//
//  Data.swift
//  DoggyPlaydate
//
//  Created by Shauna Kimura on 11/29/21.
//

import Foundation

struct Breed: Identifiable {
    var breed: String = ""
    var heightLow: String = ""  // inches
    var heightHigh: String = ""  // inches
    var weightLow: String = ""  // pounds
    var weightHigh: String = ""  // pounds
    var id = UUID()
    
    init(raw: [String]) {
        breed = raw[0]
        heightLow = raw[1]
        heightHigh = raw[2]
        weightLow = raw[3]
        weightHigh = raw[4]
    }

}

func loadCSV() -> [Breed] {
    var csvToStruct = [Breed]()
    
    // Locate file
    guard let filePath = Bundle.main.path(forResource: "breeds", ofType: "csv") else {
        return []
    }
    
    // Convert contents of file into one string
    var data = ""
    do {
        data = try String(contentsOfFile: filePath, encoding: .ascii)
    } catch {
        print(error)
        return []
    }

    // Split string into array
    var rows = data.components(separatedBy: "\n")

    // Remove header row
    rows.removeFirst()

    // Split rows into columns
    for row in rows {
        let csvColumns = row.components(separatedBy: ",")
        let breedStruct = Breed.init(raw: csvColumns)
        csvToStruct.append(breedStruct)
    }

    return csvToStruct
}
