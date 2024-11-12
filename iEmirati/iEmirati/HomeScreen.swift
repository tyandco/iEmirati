//
//  ContentView.swift
//  iEmirati
//
//  Created by TY on 10/12/24.
//

import SwiftUI
import UIKit
import MapKit
import CoreLocation

// Define the WordOfTheDay struct globally
struct WordOfTheDay: Identifiable {
    let id = UUID()
    let word: String
    let meaning: String
    let example: String
}

// Sample word list
let words: [WordOfTheDay] = [
    WordOfTheDay(word: NSLocalizedString("Arqoub", comment: "wordoftheday"), meaning: NSLocalizedString("Arqoub Meaning", comment: "wordoftheday"), example: NSLocalizedString("Arqoub Example", comment: "wordoftheday")),
    WordOfTheDay(word: NSLocalizedString("Khor", comment: "wordoftheday"), meaning: NSLocalizedString("Khor Meaning", comment: "wordoftheday"), example: NSLocalizedString("Khor Example", comment: "wordoftheday"))
]

// This function picks a word based on the date
func fetchWordOfTheDay() -> WordOfTheDay {
    let calendar = Calendar.current
    let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
    return words[dayOfYear % words.count] // Cycle through the word list
}

struct HomeScreen: View {
    let locations = [
        Location(name: NSLocalizedString("hervill", comment: "location"), imageName: "hervillage", description: NSLocalizedString("hervilldesc", comment: "location"), coordinate: CLLocationCoordinate2D(latitude: 24.476696, longitude: 54.331250)),
        Location(name: NSLocalizedString("alhosn", comment: "location"), imageName: "qasrhosn", description: NSLocalizedString("alhosndesc", comment: "location"), coordinate: CLLocationCoordinate2D(latitude: 24.482405, longitude: 54.354719)),
        Location(name: NSLocalizedString("jubailmang", comment: "location"), imageName: "jubailmang", description: NSLocalizedString("jubailmangdesc", comment: "location"), coordinate: CLLocationCoordinate2D(latitude: 24.544578, longitude: 54.488503))
    ]
    //24.482405, 54.354719
    var wordOfTheDay: WordOfTheDay {
        fetchWordOfTheDay()
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: true) {
                
                VStack {
                    // NavigationLink to WordOfTheDayView when tapping the CardView
                    NavigationLink(destination: WordOfTheDayView(word: wordOfTheDay)) {
                        CardView(word: wordOfTheDay)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    VStack(alignment: .leading) {
                        Text("Explore Locations")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.all)
                        
                        // Horizontal Scroll View
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(locations) { location in
                                    NavigationLink(destination: LocationDetailView(location: location)) {
                                        LocationCardView(location: location)
                                    }
                                }
                            }
                            .padding(.all)
                        }
                        .frame(height: 150)
                        
                        // Other content
                        Text("There's still more to add! Check back soon!")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        // Additional content can be added here...
                    }
                    .navigationTitle("Home")
                    .padding()
                }
            }
        }
    }
    
    struct CardView: View {
        let word: WordOfTheDay
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.accent.opacity(0.1))
                    .frame(maxWidth: .infinity, maxHeight: 150)
                    .shadow(radius: 5)
                
                VStack(alignment: .leading) {
                    Text("Word of the Day")
                        .font(.headline)
                        .padding(.top, 10)
                    
                    Text(word.word)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.accent)
                        .padding(.top, 5)
                    
                    Text("Tap to learn the meaning!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 10)
                }
                .padding()
            }
            .padding(.horizontal, 20)
        }
    }
    
    struct LocationCardView: View {
        let location: Location
        
        var body: some View {
            VStack(alignment: .leading) {
                Image(location.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 100)
                    .clipped()
                    .cornerRadius(10)
                
                Text(location.name)
                    .font(.headline)
                    .padding(.top, 5)
                
                Text(location.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .frame(width: 150)
            .padding(.vertical)
            .background(Color(.systemBackground))
            .cornerRadius(15)
        }
    }
    
    struct LocationDetailView: View {
        let location: Location
        @State private var showGoogleMapsAlert = false
        // Function to open location in Apple Maps
        func openInAppleMaps() {
            let coordinate = location.coordinate
            let regionDistance: CLLocationDistance = 1000
            let coordinates = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
            let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinates))
            mapItem.name = location.name
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)])
        }
        
        var body: some View {
            ScrollView(.vertical, showsIndicators: true){
                VStack(spacing: 20) {
                    Text(location.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    // Map with rounded corners
                    Map(coordinateRegion: .constant(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))),
                        interactionModes: .all,
                        showsUserLocation: false,
                        annotationItems: [location]) { loc in
                        MapMarker(coordinate: loc.coordinate, tint: .blue)
                    }
                        .mapStyle(.imagery)
                        .frame(height: 300)
                        .cornerRadius(15) // Apply rounded corners here
                        .padding(.horizontal) // Add padding around the map for spacing
                    
                    Text(location.description)
                        .font(.body)
                        .padding()
                    
                    VStack(spacing: 10) {
                        // Apple Maps Button
                        Button(action: {
                            let regionSpan = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
                            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate))
                            mapItem.name = location.name
                            mapItem.openInMaps(launchOptions: [
                                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
                            ])
                        }) {
                            HStack {
                                Image("applemapsico")  // Use your Apple Maps icon name here
                                    .resizable()
                                    .frame(width: 30, height: 30)  // Set icon size here
                                Text("Open in  Maps")
                                    .font(.headline)
                                    .foregroundColor(.aaplmpstxtcol)
                            }
                            .frame(maxWidth: .infinity) // Ensures the button takes up max width
                            .padding()
                            .background(Color.aaplmpsbckcol)
                            .cornerRadius(20)
                        }
                        .padding(.horizontal)
                        
                        // Google Maps Button
                        Button(action: {
                            // Coordinates for the location
                            let latitude = location.coordinate.latitude
                            let longitude = location.coordinate.longitude
                            let locationName = location.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                            
                            // Google Maps URL Scheme for iOS app with name and coordinates
                            let googleMapsURLString = "comgooglemaps://?q=\(locationName)&center=\(latitude),\(longitude)&zoom=14"
                            
                            // Google Maps Web URL (fallback for non-Google Maps users)
                            let googleMapsWebURLString = "https://www.google.com/maps?q=\(locationName)&ll=\(latitude),\(longitude)&z=14"
                            
                            // Create URL objects
                            if let googleMapsURL = URL(string: googleMapsURLString), let googleMapsWebURL = URL(string: googleMapsWebURLString) {
                                
                                // Check if the Google Maps app is installed
                                if UIApplication.shared.canOpenURL(googleMapsURL) {
                                    // Open the location directly in Google Maps app
                                    UIApplication.shared.open(googleMapsURL)
                                } else {
                                    // If the app is not installed, fall back to the web version
                                    UIApplication.shared.open(googleMapsWebURL)
                                }
                            }
                        }) {
                            HStack {
                                Image("gmapsicon")
                                    .resizable()
                                    .frame(width: 21, height: 30)
                                Text("Open in Google Maps")
                                    .font(.headline)
                                    .foregroundColor(.aaplmpstxtcol)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.aaplmpsbckcol)
                            .cornerRadius(20)
                        }
                        .padding(.horizontal)

                        Spacer()
                    }
                    .padding()
                }
            }
        }
    }
        struct WordOfTheDayView: View {
            let word: WordOfTheDay
            
            var body: some View {
                VStack {
                    Text(word.word)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .padding()
                    
                    Text("Meaning: \(word.meaning)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                    
                    Text("Example: \(word.example)")
                        .font(.subheadline)
                        .italic()
                        .fontWeight(.black)
                        .padding()
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Word of the Day") // If you're using a NavigationView
            }
        }
        
        struct Location: Identifiable {
            let id = UUID()
            let name: String
            let imageName: String
            let description: String
            let coordinate: CLLocationCoordinate2D
        }
    }

