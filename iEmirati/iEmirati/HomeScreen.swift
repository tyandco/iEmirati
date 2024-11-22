//
//  ContentView.swift
//  iEmirati
//
//  Created by TY on 10/12/24.
//

import SwiftUI
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
}

struct HomeScreen: View {
    let locations: [Location] = [
        Location(name: NSLocalizedString("hervill", comment: "location"),
                 imageName: "hervillage",
                 description: NSLocalizedString("hervilldesc", comment: "location"),
                 coordinate: CLLocationCoordinate2D(latitude: 24.476696, longitude: 54.331250),
                 quests: [
                    Quest(name: "Look around the area", description: ""),
                    Quest(name: "Buy something as a memory", description: "")
                 ]),
        Location(name: NSLocalizedString("alhosn", comment: "location"),
                 imageName: "qasrhosn",
                 description: NSLocalizedString("alhosndesc", comment: "location"),
                 coordinate: CLLocationCoordinate2D(latitude: 24.482405, longitude: 54.354719),
                 quests: [
                    Quest(name: "Castle Exploration", description: ""),
                    Quest(name: "Check out the Historical Artifacts", description: "")
                 ]),
        Location(name: NSLocalizedString("jubailmang", comment: "location"),
                 imageName: "jubailmang",
                 description: NSLocalizedString("jubailmangdesc", comment: "location"),
                 coordinate: CLLocationCoordinate2D(latitude: 24.544578, longitude: 54.488503),
                 quests: [
                    Quest(name: "Walk in the Mangrove Forests", description: ""),
                    Quest(name: "Bird Watching", description: "")
                 ])
    ]
    
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

                    // Other content
                    Text("There's still more to add! Check back soon!")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                        .padding()
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
        @State private var progressValue: Double = 0.0 // Progress value for quests
        @State private var progressPercentage: Int = 0 // Progress percentage for display

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

                // Progress Bar and Percentage
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
                    loadProgress()
                }
            }
            .frame(width: 150)
            .padding(.vertical)
            .background(Color(.systemBackground))
            .cornerRadius(15)
        }

        // Load quest progress for this location
        private func loadProgress() {
            let key = "progress_\(location.id.uuidString)"
            guard let savedData = UserDefaults.standard.data(forKey: key) else { return }

            do {
                let savedProgress = try JSONDecoder().decode([UUID: Bool].self, from: savedData)
                let completedCount = savedProgress.values.filter { $0 }.count
                let totalQuests = location.quests.count
                progressValue = Double(completedCount) / Double(totalQuests)
                progressPercentage = Int(progressValue * 100)
            } catch {
                print("Failed to load progress for \(location.name): \(error)")
            }
        }
    }

    struct LocationDetailView: View {
        let location: Location
        @State private var progressValue: Double = 0.0 // Progress value for quests
        @State private var progressPercentage: Int = 0 // Progress percentage for display

        var body: some View {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 20) {
                    Text(location.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding()

                    // Map with rounded corners
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

                    Text(location.description)
                        .font(.body)
                        .padding()

                    // Display the progress bar and percentage
                    VStack {
                        ProgressView(value: progressValue, total: 1.0)
                            .progressViewStyle(LinearProgressViewStyle())
                            .frame(height: 10)

                        Text("\(progressPercentage)% of Quests Completed")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 2)
                    }
                    .padding(.top, 5)
                    .onAppear {
                        loadProgress()
                    }

                    // Navigate to QuestListPage
                    NavigationLink(destination: QuestListPage(location: location)) {
                        Text("View Quests")
                            .font(.headline)
                            .foregroundColor(.accent)
                            .padding(.top)
                    }

                    // Open in Apple Maps Button with icon inside
                    Button(action: {
                        let regionDistance: CLLocationDistance = 1000
                        let coordinates = location.coordinate
                        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
                        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinates))
                        mapItem.name = location.name
                        mapItem.openInMaps(launchOptions: [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)])
                    }) {
                        HStack {
                            Image("applemapsico")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("Open in  Maps")
                                .font(.headline)
                                .foregroundColor(.aaplmpstxtcol) // Keep original foreground color
                        }
                        .frame(width: 300)
                        .padding()
                        .background(Color.aaplmpsbckcol) // Keep original background color
                        .cornerRadius(20) // Rounded corners
                    }

                    // Open in Google Maps Button with icon inside
                    Button(action: {
                        let coordinate = location.coordinate
                        let locationName = location.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Location"
                        if let url = URL(string: "comgooglemaps://?q=\(locationName)&center=\(coordinate.latitude),\(coordinate.longitude)"),
                           UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        } else if let url = URL(string: "https://www.google.com/maps?q=\(locationName)&center=\(coordinate.latitude),\(coordinate.longitude)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image("gmapsicon")
                                .resizable()
                                .frame(width: 21, height: 30)
                            Text("Open in Google Maps")
                                .font(.headline)
                                .foregroundColor(.aaplmpstxtcol) // Keep original foreground color
                        }
                        .frame(width: 300)
                        .padding()
                        .background(Color.aaplmpsbckcol) // Keep original background color
                        .cornerRadius(20) // Rounded corners
                    }

                }
                .padding()
            }
            .navigationTitle(location.name)
            .navigationBarTitleDisplayMode(.inline)
        }

        // Load quest progress for this location
        private func loadProgress() {
            let key = "progress_\(location.id.uuidString)"
            guard let savedData = UserDefaults.standard.data(forKey: key) else { return }

            do {
                let savedProgress = try JSONDecoder().decode([UUID: Bool].self, from: savedData)
                let completedCount = savedProgress.values.filter { $0 }.count
                let totalQuests = location.quests.count
                progressValue = Double(completedCount) / Double(totalQuests)
                progressPercentage = Int(progressValue * 100)
            } catch {
                print("Failed to load progress for \(location.name): \(error)")
            }
        }
    }
    struct QuestListPage: View {
        let location: Location
        @State private var progress: [UUID: Bool] = [:] // Store progress for quests

        var body: some View {
            VStack {
                // Progress View
                ProgressView(value: Double(progress.values.filter { $0 }.count), total: Double(location.quests.count))
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(height: 20)
                    .padding()

                Text("\(Int((Double(progress.values.filter { $0 }.count) / Double(location.quests.count)) * 100))% Completed")
                    .padding()
                    .font(.title2)
                    .fontWeight(.bold)

                // Quest List
                List(location.quests) { quest in
                    HStack {
                        Button(action: {
                            withAnimation {
                                toggleProgress(for: quest.id)
                            }
                        }) {
                            HStack {
                                if progress[quest.id] == true {
                                    Circle()
                                        .fill(Color.accent)
                                        .frame(width: 30, height: 30)
                                        .overlay(
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.white)
                                                .font(.system(size: 18, weight: .bold))
                                        )
                                } else {
                                    Circle()
                                        .stroke(Color.accent, lineWidth: 2)
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
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                loadProgress()
            }
        }

        // MARK: - Progress Management
        private func toggleProgress(for questID: UUID) {
            progress[questID] = !(progress[questID] ?? false)
            saveProgress()
        }

        private func saveProgress() {
            do {
                let progressData = try JSONEncoder().encode(progress)
                let key = "progress_\(location.id.uuidString)"
                UserDefaults.standard.set(progressData, forKey: key)
            } catch {
                print("Failed to save progress: \(error.localizedDescription)")
            }
        }

        private func loadProgress() {
            let key = "progress_\(location.id.uuidString)"
            guard let savedData = UserDefaults.standard.data(forKey: key) else { return }

            do {
                let loadedProgress = try JSONDecoder().decode([UUID: Bool].self, from: savedData)
                self.progress = loadedProgress
            } catch {
                print("Failed to load progress: \(error.localizedDescription)")
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
