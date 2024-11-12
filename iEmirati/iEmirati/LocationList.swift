//
//  LocationList.swift
//  iEmirati
//
//  Created by TY on 28-10-2024.
//

import MapKit

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let description: String
    let coordinate: CLLocationCoordinate2D
}
