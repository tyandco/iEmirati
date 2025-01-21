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

class ProgressManager: ObservableObject {
    @AppStorage("questProgress") private var questProgressData: Data = Data()

    static let shared = ProgressManager()

    private init() {}

    // Load the progress from AppStorage
    func loadQuestProgress() -> [UUID: [UUID: Bool]] {
        if let loadedProgress = try? JSONDecoder().decode([UUID: [UUID: Bool]].self, from: questProgressData) {
            return loadedProgress
        }
        return [:]
    }

    // Save the progress to AppStorage
    func saveQuestProgress(_ progress: [UUID: [UUID: Bool]]) {
        if let encodedProgress = try? JSONEncoder().encode(progress) {
            questProgressData = encodedProgress
        }
    }

    // Get the progress for a specific location
    func getProgress(for locationId: UUID) -> [UUID: Bool] {
        let progress = loadQuestProgress()
        return progress[locationId] ?? [:]
    }

    // Set the progress for a specific quest at a given location
    func setProgress(for locationId: UUID, questId: UUID, completed: Bool) {
        var progress = loadQuestProgress()

        if progress[locationId] == nil {
            progress[locationId] = [:]
        }

        progress[locationId]?[questId] = completed
        saveQuestProgress(progress)
    }

    // Get the overall location progress (percentage of quests completed)
    func getLocationProgress(for locationId: UUID, quests: [Quest]) -> Double {
        let progress = loadQuestProgress()
        let completedQuests = quests.filter { progress[locationId]?[$0.id] ?? false }
        return Double(completedQuests.count) / Double(quests.count)
    }
}
// Define the WordOfTheDay struct globally
struct WordOfTheDay: Identifiable {
    let id = UUID()
    let word: String
    let meaning: String
    let example: String
}
struct FoodItem: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let imageName: String
}

// Sample word list
let words: [WordOfTheDay] = [
    WordOfTheDay(word: NSLocalizedString("Arqoub", comment: "wordoftheday"), meaning: NSLocalizedString("Arqoub Meaning", comment: "wordoftheday"), example: NSLocalizedString("Arqoub Example", comment: "wordoftheday")),
    WordOfTheDay(word: NSLocalizedString("Khor", comment: "wordoftheday"), meaning: NSLocalizedString("Khor Meaning", comment: "wordoftheday"), example: NSLocalizedString("Khor Example", comment: "wordoftheday"))
]
let traditionalFoods: [FoodItem] = [
    FoodItem(name: NSLocalizedString("Machboos", comment: "traditional food"), description: NSLocalizedString("Machboos Description", comment: "traditional food"), imageName: "machboos"),
    FoodItem(name: NSLocalizedString("Harees", comment: "traditional food"), description: NSLocalizedString("Harees Description", comment: "traditional food"), imageName: "harees"),
    FoodItem(name: NSLocalizedString("Luqaimat", comment: "traditional food"), description: NSLocalizedString("Luqaimat Description", comment: "traditional food"), imageName: "luqaimat")
]

// This function picks a word based on the date
func fetchWordOfTheDay() -> WordOfTheDay {
    let calendar = Calendar.current
    let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
    return words[dayOfYear % words.count] // Cycle through the word list
}

// Struct to represent a quest
struct Quest: Identifiable {
    let id = UUID()
    let name: String
    let description: String
}

// Struct to represent a location with quests
struct Location: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let description: String
    let coordinate: CLLocationCoordinate2D
    let quests: [Quest]
    
    // Store progress for quests
    var progress: [UUID: Bool] = [:]

    // Computed property to calculate percentage progress
    var progressPercentage: Int {
        let completedQuests = progress.values.filter { $0 }.count
        let totalQuests = quests.count
        return totalQuests > 0 ? Int((Double(completedQuests) / Double(totalQuests)) * 100) : 0
    }
}

struct HomeScreen: View {
    let locations: [Location] = [
        Location(name: NSLocalizedString("hervill", comment: "location"),
                 imageName: "hervillage",
                 description: NSLocalizedString("hervilldesc", comment: "location"),
                 coordinate: CLLocationCoordinate2D(latitude: 24.476696, longitude: 54.331250),
                 quests: [
                    Quest(name: NSLocalizedString("hvillquest1", comment: "quest"), description: ""),
                    Quest(name: NSLocalizedString("hvillquest2", comment: "quest"), description: "")
                 ]),
        Location(name: NSLocalizedString("alhosn", comment: "location"),
                 imageName: "qasrhosn",
                 description: NSLocalizedString("alhosndesc", comment: "location"),
                 coordinate: CLLocationCoordinate2D(latitude: 24.482405, longitude: 54.354719),
                 quests: [
                    Quest(name: NSLocalizedString("hosnquest1", comment: "quest"), description: ""),
                    Quest(name: NSLocalizedString("hosnquest2", comment: "quest"), description: "")
                 ]),
        Location(name: NSLocalizedString("jubailmang", comment: "location"),
                 imageName: "jubailmang",
                 description: NSLocalizedString("jubailmangdesc", comment: "location"),
                 coordinate: CLLocationCoordinate2D(latitude: 24.5109261, longitude: 54.3258003),
                 quests: [
                    Quest(name: NSLocalizedString("jubailquest1", comment: "quest"), description: ""),
                    Quest(name: NSLocalizedString("jubailquest2", comment: "quest"), description: "")
                 ])
    ]
    let foods: [FoodItem] = traditionalFoods
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
                    .frame(width: 150, height: 100)
                    .clipped()
                    .cornerRadius(10)

                Text(food.name)
                    .font(.headline)
                    .padding(.top, 5)

                Text(food.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .frame(width: 150)
            .padding(.vertical)
            .cornerRadius(15)
        }
    }
    struct FoodDetailView: View {
        let food: FoodItem
        
        var body: some View {
            VStack {
                Image(food.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .cornerRadius(10)
                
                Text(food.name)
                    .font(.largeTitle)
                    .padding(.top, 10)
                
                Text(food.description) // Display the description of the selected food
                    .font(.body)
                    .padding(.top, 10)
                
                Spacer()
            }
            .padding()
        }
    }
    struct LocationCardView: View {
        let location: Location
        @State private var progressValue: Double = 0.0
        @State private var progressPercentage: Int = 0

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

                VStack {
                    ProgressView(value: progressValue, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle())
                        .frame(height: 10)

                    Text("\(progressPercentage)% Completed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 2)
                }
                .padding(.top, 5)
                .onAppear {
                    loadProgress() // Load progress when the view appears
                }
            }
            .frame(width: 150)
            .padding(.vertical)
            .cornerRadius(15)
        }

        private func loadProgress() {
            let completedCount = location.quests.filter { quest in
                ProgressManager.shared.getProgress(for: location.id)[quest.id] ?? false
            }.count
            let totalQuests = location.quests.count
            progressValue = Double(completedCount) / Double(totalQuests)
            progressPercentage = Int(progressValue * 100)
        }
    }
    struct LocationDetailView: View {
        let location: Location
        @StateObject private var progressManager = ProgressManager.shared

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
                    VStack {
                        Text("\(Int(progressManager.getLocationProgress(for: location.id, quests: location.quests) * 100))% of Quests Completed")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 2)
                        ProgressView(value: progressManager.getLocationProgress(for: location.id, quests: location.quests), total: 1.0)
                            .progressViewStyle(LinearProgressViewStyle())
                            .frame(height: 10)
                    }
                    .padding(.top, 10)

                    // "View Quests" Button
                    NavigationLink(destination: QuestListPage(location: location, progressManager: progressManager)) {
                        Text("View Quests")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                            .background(Capsule().stroke(Color.blue, lineWidth: 2))
                    }

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
    struct QuestListPage: View {
        let location: Location
        @ObservedObject var progressManager: ProgressManager

        @State private var questProgress: [UUID: Bool] = [:]
        @State private var animatedProgress: Double = 0.0

        var body: some View {
            VStack {
                ProgressView(value: animatedProgress, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(height: 20)
                    .padding()
                    .onChange(of: getLocationProgress()) { newValue in
                        withAnimation(.easeInOut(duration: 0.5)) {
                            animatedProgress = newValue
                        }
                    }

                Text("\(Int(animatedProgress * 100))% Completed")
                    .padding()
                    .font(.title2)
                    .fontWeight(.bold)

                List(location.quests, id: \.id) { quest in
                    HStack {
                        Button(action: {
                            toggleQuestProgress(quest.id)
                        }) {
                            HStack {
                                if questProgress[quest.id] == true {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.accentColor)
                                        .frame(width: 30, height: 30)
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundColor(.accentColor)
                                        .frame(width: 30, height: 30)
                                }
                                Text(quest.name)
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }

                Spacer()
            }
            .navigationTitle("\(location.name) Quests")
            .onAppear {
                loadProgress()
                animatedProgress = getLocationProgress()
            }
        }

        private func toggleQuestProgress(_ questID: UUID) {
            let currentProgress = questProgress[questID] ?? false
            questProgress[questID] = !currentProgress

            progressManager.setProgress(for: location.id, questId: questID, completed: !currentProgress)

            withAnimation(.easeInOut(duration: 0.5)) {
                animatedProgress = getLocationProgress()
            }
        }

        private func getLocationProgress() -> Double {
            let completed = location.quests.filter { quest in
                questProgress[quest.id] == true
            }.count

            return Double(completed) / Double(location.quests.count)
        }

        private func loadProgress() {
            let progress = progressManager.getProgress(for: location.id)
            for quest in location.quests {
                questProgress[quest.id] = progress[quest.id] ?? false
            }
        }
    }
    struct WordOfTheDayView: View {
        let word: WordOfTheDay

        var body: some View {
            ScrollView {
                VStack {
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
