//
//  LocationMapView.swift
//  iEmirati
//
//  Created by TY on 28-10-2024.
//
import SwiftUI
import MapKit

struct LocationMapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 24.4539, longitude: 54.3773), // Centered on Abu Dhabi
        span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
    )
    
    let locations: [Location]

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: locations) { location in
            MapAnnotation(coordinate: location.coordinate) {
                NavigationLink(destination: LocationDetailView(location: location)) {
                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title)
                        Text(location.name)
                            .font(.caption)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
