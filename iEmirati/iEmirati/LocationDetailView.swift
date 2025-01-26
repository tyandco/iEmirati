//
//  LocationDetailView.swift
//  iEmirati
//
//  Created by TY on 21-01-2025.
//
import Foundation
import MapKit
import SwiftUI

struct LocationDetailView: View {
        let location: Location

        var body: some View {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 20) {
                    // Location Name
                    Text(location.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding()

                    // Map
                    Map(coordinateRegion: .constant(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))),
                        interactionModes: .all,
                        showsUserLocation: false,
                        annotationItems: [location]) { loc in
                        MapMarker(coordinate: loc.coordinate, tint: .blue)
                    }
                    .mapStyle(.imagery)
                    .frame(height: 300)
                    .cornerRadius(15)
                    .padding(.horizontal)

                    // Location Description
                    Text(location.description)
                        .font(.body)
                        .padding()

                    // Show the overall location progress
                    
                    .padding(.top, 10)


                    // Open in Apple Maps Button with icon inside
                    Button(action: {
                        openInAppleMaps()
                    }) {
                        HStack {
                            Image("applemapsico") // Assuming you have an image named 'applemapsico' in your assets
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("Open in  Maps")
                                .font(.headline)
 // Ensure color is defined in your assets
                        }
                        .frame(width: 300)
                        .padding()
 // Ensure color is defined in your assets
                        .cornerRadius(20)
                    }

                    // Open in Google Maps Button with icon inside
                    Button(action: {
                        openInGoogleMaps()
                    }) {
                        HStack {
                            Image("gmapsicon") // Assuming you have an image named 'gmapsicon' in your assets
                                .resizable()
                                .frame(width: 21, height: 30)
                            Text("Open in Google Maps")
                                .font(.headline)
 // Ensure color is defined in your assets
                        }
                        .frame(width: 300)
                        .padding()
 // Ensure color is defined in your assets
                        .cornerRadius(20)
                    }
                }
                .padding()
            }
            .navigationTitle(location.name)
            .navigationBarTitleDisplayMode(.inline)
        }

        // Function to open location in Apple Maps
        private func openInAppleMaps() {
            let regionDistance: CLLocationDistance = 1000
            let coordinates = location.coordinate
            let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinates))
            mapItem.name = location.name
            mapItem.openInMaps(launchOptions: [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ])
        }

        // Function to open location in Google Maps
        private func openInGoogleMaps() {
            let coordinate = location.coordinate
            let locationName = location.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Location"
            if let url = URL(string: "comgooglemaps://?q=\(locationName)&center=\(coordinate.latitude),\(coordinate.longitude)"),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else if let url = URL(string: "https://www.google.com/maps?q=\(locationName)&center=\(coordinate.latitude),\(coordinate.longitude)") {
                UIApplication.shared.open(url)
            }
        }
    }
