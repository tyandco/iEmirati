//
//  ContentView.swift
//  iEmirati
//
//  Created by TY on 10/12/24.
//

import SwiftUI
import MapKit
import CoreLocation
import Combine
import Foundation
import SwiftData
import UIKit


// Define the WordOfTheDay struct globally
struct WordOfTheDay: Identifiable {
    let id = UUID()
    let word: String
    let meaning: String
    let example: String
    let imageName: String
}
struct FoodItem: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let imageName: String
}
struct TraditionalGame: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    let howToplay: String
    let description: String
}
struct EtiquettePractice: Identifiable {
    let id = UUID()
    let name: String
    let howitworks: String
    let imageName: String
}
// Sample word list
let words: [WordOfTheDay] = [
    WordOfTheDay(word: NSLocalizedString("Arqoub", comment: "wordoftheday"), meaning: NSLocalizedString("Arqoub Meaning", comment: "wordoftheday"), example: NSLocalizedString("Arqoub Example", comment: "wordoftheday"), imageName: "arqoubimage"),
    WordOfTheDay(word: NSLocalizedString("Khor", comment: "wordoftheday"), meaning: NSLocalizedString("Khor Meaning", comment: "wordoftheday"), example: NSLocalizedString("Khor Example", comment: "wordoftheday"), imageName: "khorimage")
]
let traditionalFoods: [FoodItem] = [
    FoodItem(name: NSLocalizedString("Machboos", comment: "traditional food"), description: NSLocalizedString("Machboos Description", comment: "traditional food"), imageName: "machboos"),
    FoodItem(name: NSLocalizedString("Harees", comment: "traditional food"), description: NSLocalizedString("Harees Description", comment: "traditional food"), imageName: "harees"),
    FoodItem(name: NSLocalizedString("Luqaimat", comment: "traditional food"), description: NSLocalizedString("Luqaimat Description", comment: "traditional food"), imageName: "luqaimat")
]
let traditionalGames: [TraditionalGame] = [
    TraditionalGame(name: NSLocalizedString("teela", comment: "traditional game"), image: "teela", howToplay: NSLocalizedString("teelarules", comment: "how to play") , description: NSLocalizedString("teeladesc", comment: "traditional game desc")),
    TraditionalGame(name: NSLocalizedString("aldissais", comment: "traditional game"), image: "aldissais", howToplay: NSLocalizedString("aldissaisrules", comment: "how to play") , description: NSLocalizedString("aldissaisdesc", comment: "traditional game desc")),
    TraditionalGame(name: NSLocalizedString("khobzrigag", comment: "traditional game"), image: "khobzrigag", howToplay: NSLocalizedString("khobzrigaghowtoplay", comment: "how to play") , description: NSLocalizedString("khobzrigagdesc", comment: "traditional game desc")),
]
let etiquette: [EtiquettePractice] = [
    EtiquettePractice(name: NSLocalizedString("greet", comment: "etiquette"), howitworks: NSLocalizedString("howgreet", comment: "etiquette"), imageName: "greeting")
]
// This function picks a word based on the date
func fetchWordOfTheDay() -> WordOfTheDay {
    let calendar = Calendar.current
    let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
    return words[dayOfYear % words.count] // Cycle through the word list
}

// Struct to represent activities
struct Activity: Identifiable {
    let id = UUID()
    let name: String
}

// Struct to represent a location
struct Location: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let description: String
    let coordinate: CLLocationCoordinate2D
    let activities: [Activity]
    
    }

struct HomeScreen: View {
    let locations: [Location] = [
        Location(name: NSLocalizedString("hervill", comment: "location"),
                 imageName: "hervillage",
                 description: NSLocalizedString("hervilldesc", comment: "location"),
                 coordinate: CLLocationCoordinate2D(latitude: 24.476696, longitude: 54.331250),
                 activities: [
                    Activity(name: NSLocalizedString("hvillquest1", comment: "quest")),
                    Activity(name: NSLocalizedString("hvillquest2", comment: "quest"))
                 ]),
        Location(name: NSLocalizedString("alhosn", comment: "location"),
                 imageName: "qasrhosn",
                 description: NSLocalizedString("alhosndesc", comment: "location"),
                 coordinate: CLLocationCoordinate2D(latitude: 24.482405, longitude: 54.354719),
                 activities: [
                    Activity(name: NSLocalizedString("hosnquest1", comment: "quest")),
                    Activity(name: NSLocalizedString("hosnquest2", comment: "quest"))
                 ]),
        Location(name: NSLocalizedString("jubailmang", comment: "location"),
                 imageName: "jubailmang",
                 description: NSLocalizedString("jubailmangdesc", comment: "location"),
                 coordinate: CLLocationCoordinate2D(latitude: 24.5451874, longitude: 54.4828312),
                 activities: [
                    Activity(name: NSLocalizedString("jubailquest1", comment: "quest")),
                    Activity(name: NSLocalizedString("jubailquest2", comment: "quest")),])
    ]
    let foods: [FoodItem] = traditionalFoods
    let games: [TraditionalGame] = traditionalGames
    let etiquett: [EtiquettePractice] = etiquette
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

                    Text("Explore Locations")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.all)
                    // Horizontal Scroll View for Locations
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
                    .frame(height: 200)
                    
                    Text("Traditional Foods")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .padding(.all)
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 15) {
                                                ForEach(foods) { food in
                                                    NavigationLink(destination: FoodDetailView(food: food)){
                                                        FoodCardView(food: food)
                                                    }
                                                }
                                            }
                                            .padding(.horizontal)
                                        }
                                        .frame(height: 200)
                    Text("Traditional Games")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .padding(.all)
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 15) {
                                                ForEach(games) { trdgame in
                                                    NavigationLink(destination: TrdGameDetailView(game: trdgame)){
                                                        TrdGameCardView(tradgame: trdgame)
                                                    }
                                                }
                                            }
                                            .padding(.horizontal)
                                        }
                                        .frame(height: 200)
                    Text("Etiquette in the UAE")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.all)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(etiquett) { etiquette in
                                NavigationLink(destination: EtiquetteDetailView(etiquette: etiquette)){
                                    EtiquetteCardView(etiquette: etiquette)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 200)
                }
                .navigationTitle("Home")
                .padding()
            }
        }
    }

    struct CardView: View {
        let word: WordOfTheDay

        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.accentColor.opacity(0.1))
                    .frame(maxWidth: .infinity, maxHeight: 150)
                    .shadow(radius: 5)

                VStack(alignment: .leading) {
                    Text("Word of the Day")
                        .font(.headline)
                        .padding(.top, 10)

                    Text(word.word)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
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
    struct FoodCardView: View {
        let food: FoodItem

        var body: some View {
            VStack(alignment: .leading) {
                Image(food.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 175, height: 100)
                    .clipped()
                    .cornerRadius(10)

                Text(food.name)
                    .font(.headline)
                    .padding(.top, 5)

                Text("Tap to learn more!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .frame(width: 175)
            .padding(.vertical)
            .cornerRadius(15)
        }
    }
    struct FoodDetailView: View {
        let food: FoodItem
        
        var body: some View {
            VStack {
                ZStack {
                                // Blurred frame
                                Image(food.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:300,height: 200)
                                    .blur(radius: 10)

                                    .opacity(1)
                                
                                // Main image
                    Image(food.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width:300,height: 200)
                        .cornerRadius(30)
                            }
                Text(food.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                
                Text(food.description) // Display the description of the selected food
                    .font(.body)
                    .padding(.top, 10)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Traditional Foods")
        }
    }
    struct LocationCardView: View {
        let location: Location
        var body: some View {
            VStack(alignment: .leading) {
                Image(location.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 100)
                    .clipped()
                    .cornerRadius(10)

                Text(location.name)
                    .font(.headline)
                    .padding(.top,4)

                Text("Tap to view")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                .padding(.top,1)
            }
            .frame(width: 200)
            .padding(.vertical)
            .cornerRadius(15)
        }
    }
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
                    // Things To Do
                    VStack{
                        Text("Things to do:")
                            .font(.headline)
                        ForEach(location.activities) { activity in
                                               HStack {
                                                   Image(systemName: "circlebadge.fill")

                                                       .foregroundColor(.accentColor)
                                                   Text(activity.name)
                                                       .font(.body)
                                               }
                                               .padding(.vertical, 5)
                                           }
                    }
                    Button(action: {
                        openInAppleMaps()
                    }) {
                        HStack {
                            Image("applemapsico") // Assuming you have an image named 'applemapsico' in your assets
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("Open in  Maps")
                                .font(.headline)
                                .foregroundStyle(.primary)
                                 // Ensure color is defined in your assets
                        }
                        .frame(width: 300)
                        .padding()
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
                                .foregroundStyle(.primary)
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
    struct TrdGameCardView: View {
        let tradgame: TraditionalGame

        var body: some View {
            VStack(alignment: .leading) {
                Image(tradgame.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 100, alignment: .center)
                    .clipped()
                    .cornerRadius(10)

                Text(tradgame.name)
                    .font(.headline)
                    .padding(.top, 5)

                Text("Tap to learn more!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .frame(width: 200)
            .padding(.vertical)
            .cornerRadius(15)
        }
    }
    struct TrdGameDetailView: View {
        let game: TraditionalGame
        
        var body: some View {
            ScrollView{
                VStack {
                    ZStack {
                        // Blurred frame
                        Image(game.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:300,height: 200)
                            .blur(radius: 10)
                            .opacity(1)
                            .padding()
                        // Main image
                        Image(game.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width:300,height: 200)
                            .cornerRadius(30)
                    }
                    .padding()
                    Text(game.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                    
                    Text(game.description)
                        .multilineTextAlignment(.center)
                        .font(.body)
                        .padding(.top, 10)
                    Text("How it's played:")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    Text(game.howToplay)
                        .font(.body)
                        .padding()
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
            }
            .padding()
            .navigationTitle("Traditional Games")
        }
    }
    struct EtiquetteCardView: View {
        let etiquette: EtiquettePractice
        var body: some View {
            VStack(alignment: .leading) {
                Image(etiquette.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 125, alignment: .center)
                    .clipped()
                    .cornerRadius(10)

                Text(etiquette.name)
                    .font(.headline)
                    .padding(.top, 5)

                Text("Tap to learn more!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .frame(width: 200)
            .padding(.vertical)
            .cornerRadius(15)
        }
    }
    struct EtiquetteDetailView: View {
        let etiquette: EtiquettePractice
        
        var body: some View {
            ScrollView{
                VStack {
                    ZStack {
                        // Blurred frame
                        Image(etiquette.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:300,height: 200)
                            .blur(radius: 10)
                            .opacity(1)
                            .padding()
                        // Main image
                        Image(etiquette.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width:300,height: 200)
                            .cornerRadius(30)
                    }
                    .padding()
                    Text(etiquette.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                    
                    Text(etiquette.howitworks)
                        .multilineTextAlignment(.center)
                        .font(.body)
                        .padding(.top, 10)
                    
                    Spacer()
                }
            }
            .padding()
            .navigationTitle("Etiquette")
        }
    }
    struct WordOfTheDayView: View {
        let word: WordOfTheDay

        var body: some View {
            ScrollView {
                VStack {
                    ZStack {
                        // Blurred frame
                        Image(word.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 150)
                            .blur(radius: 10)

                            .opacity(1)
                        
                        // Main image
                        Image(word.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 150)
                            .cornerRadius(30)
                            
                    }
                    Text(word.word)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(word.meaning)
                        .font(.title2)
                        .padding()

                    Text("Example: \(word.example)")
                        .font(.body)
                        .padding()

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Word of the Day")
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
