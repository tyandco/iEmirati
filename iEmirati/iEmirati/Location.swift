//
//  LocationList.swift
//  iEmirati
//
//  Created by TY on 28-10-2024.
//

// Location.swift
import Foundation
import CoreLocation

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let description: String
    let coordinate: CLLocationCoordinate2D
    let quests: [Quest] // Add quests property
}

// Define the Quest struct
struct Quest: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    var completed: Bool = false
}
