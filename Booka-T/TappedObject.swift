//
//  TappedObject.swift
//  Booka-T
//
//  Created by Sourav Bhattacharjee on 19/10/24.
//
import Foundation

struct TappedObject: Identifiable, Codable {
    let id: UUID
    var name: String
    var coordinates: CGPoint

    init(name: String, coordinates: CGPoint) {
        self.id = UUID() // Generate a new UUID for each object
        self.name = name
        self.coordinates = coordinates
    }
}



